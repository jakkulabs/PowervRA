# Get-vRAResourceType

## SYNOPSIS
Get a resource type

## SYNTAX

### Standard (Default)
```
Get-vRAResourceType [-Page <Int32>] [-Limit <Int32>]
```

### ById
```
Get-vRAResourceType -Id <String[]>
```

### ByName
```
Get-vRAResourceType -Name <String[]>
```

## DESCRIPTION
A Resource type is a type assigned to resources.
The types are defined by the provider types. 
It allows similar resources to be grouped together.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAResourceType
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAResourceType -Id "Infrastructure.Machine"
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAResourceType -Name "Machine"
```

## PARAMETERS

### -Id
The id of the resource type

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
The Name of the resource type

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

