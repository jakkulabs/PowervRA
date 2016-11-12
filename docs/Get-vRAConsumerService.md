---
external help file: DEPRECATED-Get-vRAConsumerService-help.xml
online version: 
schema: 2.0.0
---

# Get-vRAConsumerService

## SYNOPSIS
Retrieve vRA services

## SYNTAX

### Standard (Default)
```
Get-vRAConsumerService [-Limit <String>]
```

### ById
```
Get-vRAConsumerService [-Id <String[]>] [-Limit <String>]
```

### ByName
```
Get-vRAConsumerService [-Name <String[]>] [-Limit <String>]
```

## DESCRIPTION
A service represents a customer-facing/user friendly set of activities.
In the context of this Service Catalog, 
these activities are the catalog items and resource actions. 
A service must be owned by a specific organization and all the activities it contains should belongs to the same organization.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAConsumerService
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAConsumerService -Id 332d38d5-c8db-4519-87a7-7ef9f358091a
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAConsumerService -Name "Default Service"
```

## PARAMETERS

### -Id
The id of the service

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
The Name of the service

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

