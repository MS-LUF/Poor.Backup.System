# Poor.Backup.System
A blazing stupid backup solution for Windows &amp; Linux - based on a simple PowerShell Module working with Powershell Core on both Linux and Windows platform (should work also on Mac but not tested currently).

This project was just a demo to play with Powershell Core on both Linux and Windows to study differences & bugs.

At the end, this is the release. It's a very simple stuff I have built to be able to save easily file during some tests phase on non-industrialized environments.

(c) 2019 lucas-cueff.com Distributed under Artistic Licence 2.0 (https://opensource.org/licenses/artistic-license-2.0).

## Description
This release (I am not sure it will be another one, but don't hesitate to ask if you want some new features...) can be used to build a backup list and easily add/remove item to this list from a Powershell command line and then start a backup of this list...
Your backup is availabe as zip or classic folder with log files.

## Exported Functions and Alias
### Functions
- Start-PoorBackup
- Set-PoorBackupSettings
- Add-ItemToPoorBackup
- Remove-ItemFromPoorBackup
- Import-PoorBackupSettings
- Write-PoorBackupLog

## install Poor.Backup.System from PowerShell Gallery repository
You can easily install it from powershell gallery repository
https://www.powershellgallery.com/packages/Poor.Backup.System/
using a simple powershell command and an internet access :-) 
```
	Install-Module -Name Poor.Backup.System
```

## import module from PowerShell 
```
	C:\PS> import-module Poor.Backup.System.psd1
```

## module content
documentation in markdown available here : https://github.com/MS-LUF/Poor.Backup.System/tree/master/docs

## Play with it - Linux sample
### Create your main config file
create my main config file in default location ($home/.PoorBackup/settings.xml) to backup "/var/www","/etc/nginx","/etc/stuff" in /home/you as an archive and log it in /var/log
```
	PS> Set-PoorBackupSettings -LogDir /var/log -TargetBackupDir /home/you -ItemsToBackup @("/var/www","/etc/nginx","/etc/stuff") -CompressBackup
```
### Load one of my conf file before running a backup
Load mybackupstuff.xml from /tmp
```
	PS> Import-PoorBackupSettings -SettingsFile /tmp/mybackupstuff.xml
```
### Add a new item to my backup list
Add "/test/important" to my backup list
```
	PS> get-item "/test/important" | Add-ItemToPoorBackup
```
### Remove an existing item from my backup list
Remove "/test/notimportant" from my backup list
```
	Remove-ItemFromPoorBackup -BackupItem "/test/notimportant"
```
### Start a backup session
```
	PS> Start-PoorBackup
```
