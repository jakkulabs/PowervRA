# Get-vRAEntitledService

## SYNOPSIS
Retrieve vRA services that the user is entitled to see

## SYNTAX

### Standard (Default)
```
Get-vRAEntitledService [-Page <Int32>] [-Limit <Int32>]
```

### ById
```
Get-vRAEntitledService [-Id <String[]>]
```

### ByName
```
Get-vRAEntitledService [-Name <String[]>]
```

## DESCRIPTION
A service represents a customer-facing/user friendly set of activities.
In the context of this Service Catalog, 
these activities are the catalog items and resource actions. 
A service must be owned by a specific organization and all the activities it contains should belongs to the same organization.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAEntitledService
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAEntitledService -Id 332d38d5-c8db-4519-87a7-7ef9f358091a
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAEntitledService -Name "Default Service"
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
This has a default value of 100.

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

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

