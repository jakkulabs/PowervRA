# Get-vRAResourceActionRequestTemplate

## SYNOPSIS
Get the request template of a resource action that the user is entitled to see

## SYNTAX

### ByResourceId (Default)
```
Get-vRAResourceActionRequestTemplate -ActionId <String> -ResourceId <String[]> [<CommonParameters>]
```

### ByResourceName
```
Get-vRAResourceActionRequestTemplate -ActionId <String> -ResourceName <String[]> [<CommonParameters>]
```

## DESCRIPTION
Get the request template of a resource action that the user is entitled to see

## EXAMPLES

### EXAMPLE 1
```
Get-vRAResourceActionRequestTemplate -ActionId "fae08c75-3506-40f6-9c9b-35966fe9125c" -ResourceName vm01
```

### EXAMPLE 2
```
Get-vRAResourceActionRequestTemplate -ActionId "fae08c75-3506-40f6-9c9b-35966fe9125c" -ResourceId 20402e93-fb1d-4bd9-8a51-b809fbb946fd
```

## PARAMETERS

### -ActionId
The id resource action

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

### -ResourceId
The id of the resource

```yaml
Type: String[]
Parameter Sets: ByResourceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ResourceName
The name of the resource

```yaml
Type: String[]
Parameter Sets: ByResourceName
Aliases:

Required: True
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

### System.String

## NOTES

## RELATED LINKS
