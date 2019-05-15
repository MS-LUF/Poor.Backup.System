---
external help file: Poor.Backup.System-help.xml
Module Name: Poor.Backup.System
online version:
schema: 2.0.0
---

# Import-PoorBackupSettings

## SYNOPSIS
Import PoorBackup Settings file into current PowerShell environment

## SYNTAX

```
Import-PoorBackupSettings [[-SettingsFile] <String>] [<CommonParameters>]
```

## DESCRIPTION
Import PoorBackup Settings file into current PowerShell environment as global variable PoorBackupSettings

## EXAMPLES

### EXAMPLE 1
```
Import PoorBackup settings using default file and path
```

C:\PS\> Import-PoorBackupSettings

### EXAMPLE 2
```
Import PoorBackup settings using a specific config file
```

C:\PS\> Import-PoorBackupSettings -SettingsFile C:\tmp\mybackupstuff.xml

## PARAMETERS

### -SettingsFile
-SettingsFile string {full path to target xml file name, directory must exist}
default value : $home\".PoorBackup\settings.xml"
full path to custom target xml settings file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (join-path $home ".PoorBackup\settings.xml")
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Deserialized.System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
