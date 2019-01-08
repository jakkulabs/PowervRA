# Get-vRACustomForm

## SYNOPSIS
Retrieve vRA CustomForms

## SYNTAX

### Standard (Default)
```
Get-vRACustomForm -id <BlueprintId>
```

### From vRA Blueprint
```
Get-vRABlueprint -Name "<BlueprintName>" | Get-vRACustomForm
```

## DESCRIPTION
Retrieve vRA CustomForms

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRACustomForm
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRABlueprint -Name "<BlueprintName>" | Get-vRACustomForm
```


## PARAMETERS

### -Id
Specify the ID of a CustomForm

```yaml
Type: String[]
Parameter Sets: ById
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS
