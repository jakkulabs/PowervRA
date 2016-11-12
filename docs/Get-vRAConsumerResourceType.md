# Get-vRAConsumerResourceType

## SYNOPSIS
Get a consumer resource type

## SYNTAX

### Standard (Default)
```
Get-vRAConsumerResourceType [-Limit <String>]
```

### ById
```
Get-vRAConsumerResourceType [-Id <String[]>] [-Limit <String>]
```

### ByName
```
Get-vRAConsumerResourceType [-Name <String[]>] [-Limit <String>]
```

## DESCRIPTION
A Resource type is a type assigned to resources.
The types are defined by the provider types. 
It allows similar resources to be grouped together.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAConsumerResourceType
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAConsumerResourceType -Id "Infrastructure.Machine"
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAConsumerResourceType -Name "Machine"
```

## PARAMETERS

### -Id
The id of the resource type

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
The Name of the resource type

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

