<# Import-Module Appx
Get-AppxPackage -Name "AppleInc.iTunes" #>

Set-Variable -Name "bkp_new_path" -Value "E:\Backups\iPhone Backups"

$software = "iTunes"
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null

if (-Not $installed) {
    Set-Variable -Name "bkp_old_base_path" -Value ($env:HOMEDRIVE + ${env:HOMEPATH} + "\Apple")
} 
else {
    Set-Variable -Name "bkp_old_base_path" -Value ($env:APPDATA + "\Apple Computer")
}

Set-Variable -Name "bkp_old_base_path" -Value ($env:HOMEDRIVE + ${env:HOMEPATH} + "\Apple")
Set-Variable -Name "bkp_old_short_path" -Value ($bkp_old_base_path + "\MobileSync")
Set-Variable -Name "bkp_old_path" -Value ($bkp_old_short_path + "\Backup")



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

