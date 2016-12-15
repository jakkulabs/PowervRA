# Get-vRAContentType

## SYNOPSIS
Get a list of available vRA content types

## SYNTAX

### Standard (Default)
```
Get-vRAContentType [-Page <Int32>] [-Limit <Int32>]
```

### ById
```
Get-vRAContentType -Id <String[]>
```

### ByName
```
Get-vRAContentType -Name <String[]>
```

## DESCRIPTION
Get a list of available vRA content types

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAContentType -Id property-group
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAContentType -Name "Property Group"
```

## PARAMETERS

### -Id
The id of the content type

```yaml
Type: String[]
Parameter Sets: ById
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
The name of the content type

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

