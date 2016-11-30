# Get-vRAConsumerCatalogItemRequestTemplate

## SYNOPSIS
Get the request template of a catalog item that the user is entitled to see

## SYNTAX

### Standard (Default)
```
Get-vRAConsumerCatalogItemRequestTemplate [-Limit <String>]
```

### ById
```
Get-vRAConsumerCatalogItemRequestTemplate -Id <String> [-Limit <String>]
```

### ByName
```
Get-vRAConsumerCatalogItemRequestTemplate -Name <String> [-Limit <String>]
```

## DESCRIPTION
Get the request template of a catalog item that the user is entitled to see and return a JSON payload to reuse in a request

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAConsumerCatalogItemRequestTemplate -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAConsumerCatalogItemRequestTemplate -Name Centos_Template
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAConsumerEntitledCatalogItem | Get-vRAConsumerCatalogItemRequestTemplate
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRAConsumerEntitledCatalogItem -Name Centos_Template | Get-vRAConsumerCatalogItemRequestTemplate
```

### -------------------------- EXAMPLE 5 --------------------------
```
Get-vRAConsumerEntitledCatalogItem -Name Centos_Template | Get-vRAConsumerCatalogItemRequestTemplate | ConvertFrom-Json
```

## PARAMETERS

### -Id
The id of the catalog item

```yaml
Type: String
Parameter Sets: ById
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The name of the catalog item

```yaml
Type: String
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

### System.String

## NOTES

## RELATED LINKS

