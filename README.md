# Script to change iTunes backup location on Windows

* Work with *iTunes* and *Microsoft Store iTunes*
* Will automatically move old backups to the new location

By default iTunes will backup your iDevices in a home user obscur folder.

iTunes : `"%APPDATA%\Apple Computer\MobileSync\Backup"`

Microsoft Store iTunes : `"%HOMEPATH%\Apple\MobileSync\Backup"`

So here you got script to change this location quickly and easily

* Script must be run as administrator (symbolic link bug)
* It will create a symbolic link to `"E:\Backups\iPhone Backups"`

Enjoy making backups ;)