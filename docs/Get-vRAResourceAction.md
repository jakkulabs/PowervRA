---
external help file: Get-vRAResourceAction-help.xml
online version: 
schema: 2.0.0
---

# Get-vRAResourceAction

## SYNOPSIS
Retrieve available Resource Actions for a resource

## SYNTAX

```
Get-vRAResourceAction [-ResourceId] <String[]>
```

## DESCRIPTION
A resourceAction is a specific type of ResourceOperation that is performed by submitting a request.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAConsumerResource -Name vm01 | Get-vRAResourceAction
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAConsumerResource -Name vm01 | Get-vRAResourceAction | Select Id, Name, BindingId
```

## PARAMETERS

### -ResourceId
The id of the resource

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

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

