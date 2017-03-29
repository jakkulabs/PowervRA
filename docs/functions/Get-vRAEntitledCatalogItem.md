# Get-vRAEntitledCatalogItem

## SYNOPSIS
Get a catalog item that the user is entitled to see

## SYNTAX

### Standard (Default)
```
Get-vRAEntitledCatalogItem [-Service <String>] [-Page <Int32>] [-Limit <Int32>]
```

### ByID
```
Get-vRAEntitledCatalogItem -Id <String[]>
```

### ByName
```
Get-vRAEntitledCatalogItem -Name <String[]>
```

## DESCRIPTION
Get catalog items that are entitled to.
Consumer Entitled CatalogItem(s) are basically catalog items:
- in an active state.
- the current user has the right to consume.
- the current user is entitled to consume.
- associated to a service.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAEntitledCatalogItem
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAEntitledCatalogItem -Limit 9999
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAEntitledCatalogItem -Service "Default Service"
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRAEntitledCatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e
```

### -------------------------- EXAMPLE 5 --------------------------
```
Get-vRAEntitledCatalogItem -Name Centos_Template
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
Accept pipeline input: True (ByPropertyName, ByValue)
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

### -Service
Return catalog items in a specific service

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
The index of the page to display

```yaml
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The number of entries returned per page from the API.
This has a default value of 100

```yaml
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String
System.Int

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

