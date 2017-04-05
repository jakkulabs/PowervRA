# New-vRANetworkProfileIPRangeDefinition

## SYNOPSIS
Creates a new network profile ip range definition

## SYNTAX

```
New-vRANetworkProfileIPRangeDefinition [-Name] <String> [[-Description] <String>] [-StartIPv4Address] <String>
 [-EndIPv4Address] <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Creates a new network profile ip range definition

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-vRANetworkProfileIPRangeDefinition -Name "External-Range-01" -Description "Example" -StartIPv4Address "10.20.1.2" -EndIPv4Address "10.20.1.5"
```

## PARAMETERS

### -Name
The name of the network profile ip range

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
A description of the network profile ip range

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartIPv4Address
The start IPv4 address

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndIPv4Address
The end IPv4 address

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 4
Default value: None
Accept pipeline input: False
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

### System.String.

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

