---
external help file: Poor.Backup.System-help.xml
Module Name: Poor.Backup.System
online version:
schema: 2.0.0
---

# Write-PoorBackupLog

## SYNOPSIS
Write to log file

## SYNTAX

```
Write-PoorBackupLog [-Message] <String> [-Path] <String> [[-Level] <String>] [<CommonParameters>]
```

## DESCRIPTION
Write to log file

## EXAMPLES

### EXAMPLE 1
```
Write "Hello world" as information to "c:\logs\test.log"
```

C:\PS\> Write-PoorBackupLog -Message "Hello world" -Path "c:\logs\test.log"

### EXAMPLE 2
```
Write "Bad world" as error to "c:\logs\test.log"
```

C:\PS\> Write-PoorBackupLog -Message "Bad world" -Path "c:\logs\test.log" -Level Error

## PARAMETERS

### -Message
-Message string
mandatory
string to write to log file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Path
-Path string {full path to target log file}
mandatory
full path to log file to write in

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

### -Level
-Level string {"Error","Warn","Info"}
default value : Info
Type of information to log

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Info
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### none
## NOTES

## RELATED LINKS
