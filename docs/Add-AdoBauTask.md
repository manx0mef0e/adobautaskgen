---
external help file: AdoBauTaskGen-help.xml
Module Name: AdoBauTaskGen
online version:
schema: 2.0.0
---

# Add-AdoBauTask

## SYNOPSIS
Adds task to Azure DevOps PBI.

## SYNTAX

### Frequency (Default)
```
Add-AdoBauTask -Title <String> -Description <String> -ParentId <Int32> -Frequency <String> [<CommonParameters>]
```

### Specific
```
Add-AdoBauTask -Title <String> -Description <String> -ParentId <Int32> -RunDate <Int32> [<CommonParameters>]
```

## DESCRIPTION
Creates a task on the specified PBI with a title based on frequency or run date, converting description from Markdown to HTML.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Description
{{ Fill Description Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Frequency
{{ Fill Frequency Description }}

```yaml
Type: String
Parameter Sets: Frequency
Aliases:
Accepted values: Daily, Weekly, Monthly, Quarterly, Half-Yearly, Yearly

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentId
{{ Fill ParentId Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunDate
{{ Fill RunDate Description }}

```yaml
Type: Int32
Parameter Sets: Specific
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
{{ Fill Title Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
