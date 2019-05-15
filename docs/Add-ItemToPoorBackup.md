---
external help file: Poor.Backup.System-help.xml
Module Name: Poor.Backup.System
online version:
schema: 2.0.0
---

# Add-ItemToPoorBackup

## SYNOPSIS
Add new item to backup list

## SYNTAX

```
Add-ItemToPoorBackup [-BackupItem] <Object> [<CommonParameters>]
```

## DESCRIPTION
Add new item (file or folder) to backup list

## EXAMPLES

### EXAMPLE 1
```
Add folder c:\important to backup list
```

C:\PS\> Add-ItemToPoorBackup -BackupItem "c:\important"

### EXAMPLE 2
```
Add folder c:\important to backup list (pipe mode)
```

C:\PS\> get-item "c:\important" | Add-ItemToPoorBackup

## PARAMETERS

### -BackupItem
-BackupItem String or System.IO
mandatory
new item to add to backup list

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES

## RELATED LINKS
