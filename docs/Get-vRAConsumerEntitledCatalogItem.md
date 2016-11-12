---
external help file: DEPRECATED-Get-vRAConsumerEntitledCatalogItem-help.xml
online version: 
schema: 2.0.0
---

# Get-vRAConsumerEntitledCatalogItem

## SYNOPSIS
Get the a catalog item that the user is entitled to see

## SYNTAX

### Standard (Default)
```
Get-vRAConsumerEntitledCatalogItem [-Limit <String>]
```

### ByID
```
Get-vRAConsumerEntitledCatalogItem -Id <String[]> [-Limit <String>]
```

### ByName
```
Get-vRAConsumerEntitledCatalogItem -Name <String[]> [-Limit <String>]
```

## DESCRIPTION
Consumer API for entitled catalog items exposed for users.
Consumer Entitled CatalogItem(s) are basically catalog items:
- In an active state.
- The current user has the right to consume.
- The current user is entitled to consume.
- Associated to a service.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAConsumerEntitledCatalogItem
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAConsumerEntitledCatalogItem -Limit 9999
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAConsumerEntitledCatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRAConsumerEntitledCatalogItem -Name Centos_Template
```

## PARAMETERS

### -Id
{{Fill Id Description}}

```yaml
Type: String[]
Parameter Sets: ByID
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the catalog item

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

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

