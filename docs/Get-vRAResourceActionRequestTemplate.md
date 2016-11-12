---
external help file: Get-vRAResourceActionRequestTemplate-help.xml
online version: 
schema: 2.0.0
---

# Get-vRAResourceActionRequestTemplate

## SYNOPSIS
Get the request template of a resource action that the user is entitled to see

## SYNTAX

### ByResourceId (Default)
```
Get-vRAResourceActionRequestTemplate -ActionId <String> -ResourceId <String[]>
```

### ByResourceName
```
Get-vRAResourceActionRequestTemplate -ActionId <String> -ResourceName <String[]>
```

## DESCRIPTION
Get the request template of a resource action that the user is entitled to see

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAResourceActionRequestTemplate -ActionId "fae08c75-3506-40f6-9c9b-35966fe9125c" -ResourceName vm01
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAResourceActionRequestTemplate -ActionId "fae08c75-3506-40f6-9c9b-35966fe9125c" -ResourceId 20402e93-fb1d-4bd9-8a51-b809fbb946fd
```

## PARAMETERS

### -ActionId
{{Fill ActionId Description}}

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
{{Fill ResourceId Description}}

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
{{Fill ResourceName Description}}

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

## INPUTS

### System.String

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS

