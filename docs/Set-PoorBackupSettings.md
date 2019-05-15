---
external help file: Poor.Backup.System-help.xml
Module Name: Poor.Backup.System
online version:
schema: 2.0.0
---

# Set-PoorBackupSettings

## SYNOPSIS
Set PoorBackup settings

## SYNTAX

```
Set-PoorBackupSettings [-LogDir] <String> [-TargetBackupDir] <String> [-ItemsToBackup] <ArrayList>
 [-CompressBackup] [[-SettingsFile] <String>] [<CommonParameters>]
```

## DESCRIPTION
Set PoorBackup settings (as global variable and external file) : Log directory, target backup directory, file and folder to backup, backup compression

## EXAMPLES

### EXAMPLE 1
```
Backup "C:\Users\adm\Documents\GitHub","C:\Users\adm\Documents\Gitlab\","C:\Users\adm\Documents\file.ext" to C:\Backup with compression and log operations to c:\logs
```

C:\PS\> Set-PoorBackupSettings -LogDir c:\logs -TargetBackupDir C:\Backup -ItemsToBackup @("C:\Users\adm\Documents\GitHub","C:\Users\adm\Documents\Gitlab\","C:\Users\adm\Documents\file.ext") -CompressBackup

## PARAMETERS

### -LogDir
-LogDir string {full path to target log directory, directory must exist}
mandatory
full path to target log directory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetBackupDir
-TargetBackupDir string {full path to target backup directory, directory must exist}
mandatory
full path to target backup directory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ItemsToBackup
-ItemsToBackup array of string
mandatory
List of items (file or folder) to backup

```yaml
Type: ArrayList
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompressBackup
-CompressBackup switch
Enable Backup as a zip file archive

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SettingsFile
-SettingsFile string {full path to target settings xml file, directory must exist}
default value : $home\".PoorBackup\settings.xml"
full path to target settings xml file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: (join-path $home ".PoorBackup\settings.xml")
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.IO.DirectoryInfo
###       System.IO.FileInfo
## NOTES

## RELATED LINKS
