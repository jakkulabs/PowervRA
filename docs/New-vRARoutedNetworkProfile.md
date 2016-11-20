# New-vRARoutedNetworkProfile

## SYNOPSIS
Create a vRA routed network profile

## SYNTAX

### Standard (Default)
```
New-vRARoutedNetworkProfile -Name <String> [-Description <String>] -SubnetMask <String>
 [-GatewayAddress <String>] -ExternalNetworkProfile <String> [-PrimaryDNSAddress <String>]
 [-SecondaryDNSAddress <String>] [-DNSSuffix <String>] [-DNSSearchSuffix <String>]
 [-PrimaryWinsAddress <String>] [-SecondaryWinsAddress <String>] [-RangeSubnetMask <String>]
 [-BaseIPAddress <String>] -IPRanges <PSObject[]> [-WhatIf] [-Confirm]
```

### UseExternalProfileSettings
```
New-vRARoutedNetworkProfile -Name <String> [-Description <String>] -SubnetMask <String>
 [-GatewayAddress <String>] -ExternalNetworkProfile <String> [-UseExternalNetworkProfileSettings]
 [-RangeSubnetMask <String>] [-BaseIPAddress <String>] -IPRanges <PSObject[]> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Create a vRA routed network profiles

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$DefinedRange1 = New-vRANetworkProfileIPRangeDefinition -Name "External-Range-01" -Description "Example 1" -StartIPv4Address "10.80.1.2" -EndIPv4Address "10.80.1.5"
```

New-vRARoutedNetworkProfile -Name Network-Routed -Description "Routed" -SubnetMask "255.255.255.0" -GatewayAddress "10.80.1.1" -PrimaryDNSAddress "10.80.1.100" -SecondaryDNSAddress "10.80.1.101" -DNSSuffix "corp.local" -DNSSearchSuffix "corp.local" -ExternalNetworkProfile "Network-External" -RangeSubnetMask "255.255.255.0" -BaseIPAddress "10.80.1.2" -IPRanges $DefinedRange1

## PARAMETERS

### -Name
The network profile Name

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExternalNetworkProfile
The external network profile that will be linked to that Routed or NAT network profile

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseExternalNetworkProfileSettings
Use the settings from the selected external network profile

```yaml
Type: SwitchParameter
Parameter Sets: UseExternalProfileSettings
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrimaryDNSAddress
The address of the primary DNS server

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

### -SecondaryDNSAddress
The address of the secondary DNS server

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

### -DNSSuffix
The DNS suffix

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

### -DNSSearchSuffix
The DNS search suffix

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

### -PrimaryWinsAddress
The address of the primary wins server

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

### -SecondaryWinsAddress
The address of the secondary wins server

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

### -RangeSubnetMask
The subnetMask for the routed range

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BaseIPAddress
The base ip of the routed range

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
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

Required: True
Position: Named
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
System.Switch
PSCustomObject

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

