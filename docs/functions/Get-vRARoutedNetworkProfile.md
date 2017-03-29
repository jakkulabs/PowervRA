# Get-vRARoutedNetworkProfile

## SYNOPSIS
Get vRA routed network profiles

## SYNTAX

### Standard (Default)
```
Get-vRARoutedNetworkProfile [-Limit <Int32>] [-Page <Int32>]
```

### ById
```
Get-vRARoutedNetworkProfile -Id <String[]>
```

### ByName
```
Get-vRARoutedNetworkProfile -Name <String[]>
```

## DESCRIPTION
Get vRA routed network profile

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRARoutedNetworkProfile -Id 597ff2c1-a35f-4a81-bfd3-ca014
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRARoutedNetworkProfile -Name NetworkProfile01
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRARoutedNetworkProfile
```

## PARAMETERS

### -Id
The id of the routed network profile

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
The name of the routed network profile

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
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
The page of response to return.
By default this is 1.

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

## INPUTS

### System.String
System.Int

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

