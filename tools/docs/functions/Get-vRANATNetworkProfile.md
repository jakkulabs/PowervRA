# Get-vRANATNetworkProfile

## SYNOPSIS
Get vRA NAT network profiles

## SYNTAX

### Standard (Default)
```
Get-vRANATNetworkProfile [-Limit <Int32>] [-Page <Int32>] [<CommonParameters>]
```

### ById
```
Get-vRANATNetworkProfile -Id <String[]> [<CommonParameters>]
```

### ByName
```
Get-vRANATNetworkProfile -Name <String[]> [<CommonParameters>]
```

## DESCRIPTION
Get vRA NAT network profiles

## EXAMPLES

### EXAMPLE 1
```
Get-vRANATNetworkProfile -Id 597ff2c1-a35f-4a81-bfd3-ca014
```

### EXAMPLE 2
```
Get-vRANATNetworkProfile -Name NetworkProfile01
```

### EXAMPLE 3
```
Get-vRANATNetworkProfile
```

## PARAMETERS

### -Id
The id of the NAT network profile

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
The name of the NAT network profile

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
System.Int

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
