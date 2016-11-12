---
external help file: DEPRECATED-Get-vRAConsumerResource-help.xml
online version: 
schema: 2.0.0
---

# Get-vRAConsumerResource

## SYNOPSIS
Get a provisioned resource

## SYNTAX

### Standard (Default)
```
Get-vRAConsumerResource [-WithExtendedData] [-WithOperations] [-Limit <String>]
```

### ById
```
Get-vRAConsumerResource [-Id <String[]>] [-Limit <String>]
```

### ByName
```
Get-vRAConsumerResource [-Name <String[]>] [-Limit <String>]
```

## DESCRIPTION
A Resource represents a deployed artifact that has been provisioned by a provider.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAConsumerResource
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAConsumerResource -WithExtendedData
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAConsumerResource -WithOperations
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRAConsumerResource -Id "6195fd70-7243-4dc9-b4f3-4b2300e15ef8"
```

### -------------------------- EXAMPLE 5 --------------------------
```
Get-vRAConsumerResource -Name "vm-01"
```

## PARAMETERS

### -Id
The id of the resource

```yaml
Type: String[]
Parameter Sets: ById
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The Name of the resource

```yaml
Type: String[]
Parameter Sets: ByName
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WithExtendedData
Populate resources' extended data by calling their provider

```yaml
Type: SwitchParameter
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WithOperations
Populate resources' operations attribute by calling the provider.
This will force withExtendedData to true.

```yaml
Type: SwitchParameter
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The number of entries returned per page from the API.
This has a default value of 100.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

