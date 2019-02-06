# New-vRANATNetworkProfile

## SYNOPSIS
Create a vRA nat network profile

## SYNTAX

### Standard (Default)
```
New-vRANATNetworkProfile -Name <String> [-Description <String>] -SubnetMask <String> [-GatewayAddress <String>]
 -ExternalNetworkProfile <String> [-PrimaryDNSAddress <String>] [-SecondaryDNSAddress <String>]
 [-DNSSuffix <String>] [-DNSSearchSuffix <String>] [-PrimaryWinsAddress <String>]
 [-SecondaryWinsAddress <String>] [-IPRanges <PSObject[]>] -NatType <String> [-DHCPEnabled]
 [-DHCPStartAddress <String>] [-DHCPEndAddress <String>] [-DHCPLeaseTime <Int32>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### UseExternalProfileSettings
```
New-vRANATNetworkProfile -Name <String> [-Description <String>] -SubnetMask <String> [-GatewayAddress <String>]
 -ExternalNetworkProfile <String> [-UseExternalNetworkProfileSettings] [-IPRanges <PSObject[]>]
 -NatType <String> [-DHCPEnabled] [-DHCPStartAddress <String>] [-DHCPEndAddress <String>]
 [-DHCPLeaseTime <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Create a vRA nat network profile

## EXAMPLES

### EXAMPLE 1
```
$DefinedRange1 = New-vRANetworkProfileIPRangeDefinition -Name "External-Range-01" -Description "Example 1" -StartIPv4Address "10.70.1.2" -EndIPv4Address "10.70.1.5"
```

New-vRANATNetworkProfile -Name Network-NAT -Description "NAT" -SubnetMask "255.255.255.0" -GatewayAddress "10.70.1.1" -PrimaryDNSAddress "10.70.1.100" -SecondaryDNSAddress "10.70.1.101" -DNSSuffix "corp.local" -DNSSearchSuffix "corp.local" -NatType ONETOMANY -ExternalNetworkProfile "Network-External" -DHCPEnabled -DHCPStartAddress "10.70.1.20" -DHCPEndAddress "10.70.1.30" -IPRanges $DefinedRange1

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

### -IPRanges
An array of ip address ranges

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NatType
The nat type.
This can be One-to-One or One-to-Many

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

### -DHCPEnabled
Enable DHCP for a NAT network profile.
Nat type must be One-to-Many

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DHCPStartAddress
The start address of the dhcp range

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

### -DHCPEndAddress
The end address of the dhcp range

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

### -DHCPLeaseTime
The dhcp lease time in seconds.
The default is 0.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
System.Int
System.Switch
PSCustomObject

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
