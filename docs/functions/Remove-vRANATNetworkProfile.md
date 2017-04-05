# Remove-vRANATNetworkProfile

## SYNOPSIS
Remove a NAT network profile

## SYNTAX

```
Remove-vRANATNetworkProfile [-Id] <String[]> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Remove a NAT network profile

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRANATNetworkProfile -Name NetworkProfile01 | Remove-vRANATNetworkProfile
```

### -------------------------- EXAMPLE 2 --------------------------
```
Remove-vRANATNetworkProfile -Id 597ff2c1-a35f-4a81-bfd3-ca014
```

## PARAMETERS

### -Id
The id of the NAT network profile

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

## NOTES

## RELATED LINKS

