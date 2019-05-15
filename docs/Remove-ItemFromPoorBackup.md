---
external help file: Poor.Backup.System-help.xml
Module Name: Poor.Backup.System
online version:
schema: 2.0.0
---

# Remove-ItemFromPoorBackup

## SYNOPSIS
Remove new item from backup list

## SYNTAX

```
Remove-ItemFromPoorBackup [-BackupItem] <Object> [<CommonParameters>]
```

## DESCRIPTION
Remove new item (file or folder) from backup list

## EXAMPLES

### EXAMPLE 1
```
Remove folder c:\important from backup list
```

C:\PS\> Remove-ItemFromPoorBackup -BackupItem "c:\important"

### EXAMPLE 2
```
Remove folder c:\important from backup list (pipe mode)
```

C:\PS\> get-item "c:\important" | Remove-ItemFromPoorBackup

## PARAMETERS

### -BackupItem
-BackupItem String or System.IO
mandatory
current item to remove from backup list

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
