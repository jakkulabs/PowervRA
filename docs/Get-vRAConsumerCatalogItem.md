# Get-vRAConsumerCatalogItem

## SYNOPSIS
Get a consumer catalog item that the user is allowed to review.

## SYNTAX

### Standard (Default)
```
Get-vRAConsumerCatalogItem [-Limit <String>]
```

### ById
```
Get-vRAConsumerCatalogItem -Id <String[]> [-Limit <String>]
```

### ByName
```
Get-vRAConsumerCatalogItem -Name <String[]> [-Limit <String>]
```

## DESCRIPTION
Consumer REST API for Catalog Items.
This API does not take entitlements into account but only global user permissions.
However, if a request is submitted for a catalogitem without the appropriate entitlement it will be rejected.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAConsumerCatalogItem
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAConsumerCatalogItem -Limit 9999
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAConsumerCatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRAConsumerCatalogItem -Name Centos_Template
```

## PARAMETERS

### -Id
The id of the catalog item

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

