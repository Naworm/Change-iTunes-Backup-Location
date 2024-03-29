<# Import-Module Appx
Get-AppxPackage -Name "AppleInc.iTunes" #>

Set-Variable -Name "bkp_new_path" -Value "D:\Backups\iPhone Backups"

$software = "iTunes"
$installed = $null -ne (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq $software })

if (-Not $installed) {
    Set-Variable -Name "bkp_old_base_path" -Value ($env:HOMEDRIVE + ${env:HOMEPATH} + "\Apple")
} 
else {
    Set-Variable -Name "bkp_old_base_path" -Value ($env:APPDATA + "\Apple Computer")
}

Set-Variable -Name "bkp_old_short_path" -Value ($bkp_old_base_path + "\MobileSync")
Set-Variable -Name "bkp_old_path" -Value ($bkp_old_short_path + "\Backup")


# Checking if Itunes is running and prevent continue

# get iTunes process
$iTunes = Get-Process "iTunes" -ErrorAction SilentlyContinue
if ($iTunes) {
    # try gracefully first
    Write-Output "iTunes is running, closing properly" 
    $iTunes.CloseMainWindow()
    # kill after five seconds
    Start-Sleep 5
    if (!$iTunes.HasExited) {
        Write-Output "iTunes is still running, stopping script"
        Exit
        #Stop-Process -processname "iTunes"
    }
}

function Test-ReparsePoint([string]$path) {
    $file = Get-Item $path -Force -ea SilentlyContinue
    return [bool]($file.Attributes -band [IO.FileAttributes]::ReparsePoint)
}
  
if (Test-ReparsePoint($bkp_old_path)) {
    if ((Get-Item $bkp_old_path | Select-Object -ExpandProperty Target) -eq $bkp_new_path) {
        Write-Output "Backup folder already migrated"
        Exit
    }
}


if (!(Test-Path $bkp_old_base_path)) {
    New-Item -ItemType Directory -Path $bkp_old_base_path
}

if (!(Test-Path $bkp_old_short_path)) {
    New-Item -ItemType Directory -Path $bkp_old_short_path
}

if (Test-Path $bkp_old_path) {
    if ((Get-ChildItem $bkp_old_path | Measure-Object).Count -eq 0) {
        Remove-Item -Path $bkp_old_path
    }
    else {
        Get-ChildItem -Path $bkp_old_path -Recurse -Directory | Move-Item -Destination $bkp_new_path -Confirm -Force
        Remove-Item -Path $bkp_old_path -Force -Recurse
    }
}

New-Item -ItemType SymbolicLink -Target $bkp_new_path -Path $bkp_old_path

