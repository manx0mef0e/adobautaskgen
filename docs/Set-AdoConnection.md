---
external help file: AdoBauTaskGen-help.xml
Module Name: AdoBauTaskGen
online version:
schema: 2.0.0
---

# Set-AdoConnection

## SYNOPSIS
Sets a default project along with account name and personal access token to be used with other calls in the module.

## SYNTAX

```
Set-AdoConnection [-Url] <String> [-Project] <String> [-PersonalAccessToken] <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
A number of the functions in this module require a project name, account name, and personal access token

By setting these parameters here they can be omitted from function calls and this default will be used instead.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-AdoConnection -Url "vbl-core.visualstudio.com" -Project "IT-Operations" -PersonalAccessToken 4vq95A6CjvjQI8DbmRif
```

Stores the Azure DevOps account url, project name, and PAT ready for calls within the module.

## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PersonalAccessToken
The personal access token from ADO to use to access this account.

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

### -Project
Specifies the team project for which this function operates.

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

### -Url
Specifies the URL of the Azure DevOps account to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
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
