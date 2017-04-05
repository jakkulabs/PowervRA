# New-vRAExternalNetworkProfile

## SYNOPSIS
Create a vRA external network profile

## SYNTAX

```
New-vRAExternalNetworkProfile [-Name] <String> [[-Description] <String>] [-SubnetMask] <String>
 [[-GatewayAddress] <String>] [[-PrimaryDNSAddress] <String>] [[-SecondaryDNSAddress] <String>]
 [[-DNSSuffix] <String>] [[-DNSSearchSuffix] <String>] [[-IPRanges] <PSObject[]>]
 [[-PrimaryWinsAddress] <String>] [[-SecondaryWinsAddress] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Create a vRA external network profile

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$DefinedRange1 = New-vRANetworkProfileIPRangeDefinition -Name "External-Range-01" -Description "Example 1" -StartIPv4Address "10.60.1.2" -EndIPv4Address "10.60.1.5"
```

$DefinedRange2 = New-vRANetworkProfileIPRangeDefinition -Name "External-Range-02" -Description "Example 2" -StartIPv4Address "10.60.1.10" -EndIPv4Address "10.60.1.20"

New-vRAExternalNetworkProfile -Name Network-External -Description "External" -SubnetMask "255.255.255.0" -GatewayAddress "10.60.1.1" -PrimaryDNSAddress "10.60.1.100" -SecondaryDNSAddress "10.60.1.101" -DNSSuffix "corp.local" -DNSSearchSuffix "corp.local" -IPRanges $DefinedRange1,$DefinedRange2

## PARAMETERS

### -Name
The network profile Name

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
The network profile Description

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

### -SubnetMask
The subnet mask of the network profile

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

### -GatewayAddress
The gateway address of the network profile

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrimaryDNSAddress
The address of the primary DNS server

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecondaryDNSAddress
The address of the secondary DNS server

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSSuffix
The DNS suffix

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSSearchSuffix
The DNS search suffix

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPRanges
An array of ip address ranges

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrimaryWinsAddress
The address of the primary wins server

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecondaryWinsAddress
The address of the secondary wins server

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 11
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

### System.String
PSCustomObject

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

