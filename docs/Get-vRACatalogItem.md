# Get-vRACatalogItem

## SYNOPSIS
Get a catalog item that the user is allowed to review.

## SYNTAX

### Standard (Default)
```
Get-vRACatalogItem [-ListAvailable] [-Page <Int32>] [-Limit <Int32>]
```

### ById
```
Get-vRACatalogItem -Id <String[]>
```

### ByName
```
Get-vRACatalogItem -Name <String[]>
```

## DESCRIPTION
API for catalog items that a system administrator can interact with.
It allows the user to interact 
with catalog items that the user is permitted to review, even if they were not published or entitled to them.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRACatalogItem
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRACatalogItem -Limit 9999
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRACatalogItem -ListAvailable
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRACatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e
```

### -------------------------- EXAMPLE 5 --------------------------
```
Get-vRACatalogItem -Name Centos_Template
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

### -ListAvailable
Show catalog items that are not assigned to a service

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

### -Page
The index of the page to display.

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
Switch

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

