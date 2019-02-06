# Export-vRAPackage

## SYNOPSIS
Export a vRA Package

## SYNTAX

### ById (Default)
```
Export-vRAPackage -Id <String[]> [-Path <String>] [<CommonParameters>]
```

### ByName
```
Export-vRAPackage -Name <String[]> [-Path <String>] [<CommonParameters>]
```

## DESCRIPTION
Export a vRA Package

## EXAMPLES

### EXAMPLE 1
```
Export-vRAPackage -Id "b2d72c5d-775b-400c-8d79-b2483e321bae" -Path C:\Packages\Package01.zip
```

### EXAMPLE 2
```
Export-vRAPackage -Name "Package01" -Path C:\Packages\Package01.zip
```

### EXAMPLE 3
```
Get-vRAPackage | Export-vRAPackage
```

### EXAMPLE 4
```
Get-vRAPackage -Name "Package01" | Export-vRAPackage -Path C:\Packages\Package01.zip
```

## PARAMETERS

### -Id
Specify the ID of a Package

```yaml
Type: String[]
Parameter Sets: ById
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specify the Name of a Package

```yaml
Type: String[]
Parameter Sets: ByName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The resulting path.
If this parameter is not passed the action will be exported to
the current working directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

## OUTPUTS

### System.IO.FileInfo

## NOTES

## RELATED LINKS
