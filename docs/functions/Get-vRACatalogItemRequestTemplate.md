# Get-vRACatalogItemRequestTemplate

## SYNOPSIS
Get the request template of a catalog item that the user is entitled to see

## SYNTAX

### ById (Default)
```
Get-vRACatalogItemRequestTemplate -Id <String>
```

### ByName
```
Get-vRACatalogItemRequestTemplate -Name <String>
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
Get-vRAConsumerEntitledCatalogItem | Get-vRACatalogItemRequestTemplate
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRAConsumerEntitledCatalogItem -Name Centos_Template | Get-vRACatalogItemRequestTemplate
```

### -------------------------- EXAMPLE 5 --------------------------
```
Get-vRAConsumerEntitledCatalogItem -Name Centos_Template | Get-vRACatalogItemRequestTemplate | ConvertFrom-Json
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
Accept pipeline input: True (ByPropertyName, ByValue)
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

## INPUTS

### System.String

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS

