# Import-vRAPackage

## SYNOPSIS
Imports a vRA Content Package

## SYNTAX

```
Import-vRAPackage [-File] <String[]> [-DontValidatePackage] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Imports a vRA Content Package

## EXAMPLES

### EXAMPLE 1
```
Import-vRAPackage -File C:\Packages\Package100.zip
```

### EXAMPLE 2
```
Get-ChildItem -Path C:\Packages\Package100.zip| Import-vRAPackage -Confirm:$false
```

## PARAMETERS

### -File
The content package file

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -DontValidatePackage
Skip Package Validation.
Not recommended by the API documentation

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
System.Switch

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
