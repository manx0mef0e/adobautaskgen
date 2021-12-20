---
external help file: AdoBauTaskGen-help.xml
Module Name: AdoBauTaskGen
online version:
schema: 2.0.0
---

# Add-AdoBauTask

## SYNOPSIS
Adds a task to an Azure DevOps PBI.

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
PS C:\> Add-AdoBauTask -Title "Server Capacity Daily Check" -Description "Carry out server capacity checks" -ParentId 51823 -Frequency "Daily"
```

This command adds a daily task called "{DayOfWeek}: Server Capacity Daily Check" to the Parent PBI 51823.

### Example 2
```powershell
PS C:\> Add-AdoBauTask -Title "Tape Media housekeeping & restores" -Description "Carry out tape library maintenance" -ParentId 51823 -Specific 21
```

This command adds a monthly task called "21 {Month}: Tape Media housekeeping & restores" to the Parent PBI 51823.

## PARAMETERS

### -Description
Specifies the description field within the task.

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
Specifies the frequency on which the task will be generated.

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
Specifies the PBI number to which the task will be added as a child of.

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
Specifies the Day of the month on which the task will be generated.

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
Specifies the Title for the created task.

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
