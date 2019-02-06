# Set-vRAExternalNetworkProfile

## SYNOPSIS
Set a vRA external network profile

## SYNTAX

```
Set-vRAExternalNetworkProfile [-Id] <String> [[-Name] <String>] [[-Description] <String>]
 [[-PrimaryDNSAddress] <String>] [[-SecondaryDNSAddress] <String>] [[-DNSSuffix] <String>]
 [[-DNSSearchSuffix] <String>] [[-PrimaryWinsAddress] <String>] [[-SecondaryWinsAddress] <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set a vRA external network profiles

## EXAMPLES

### EXAMPLE 1
```
Get-vRAExternalNetworkProfile -Name "Network-External" | Set-vRAExternalNetworkProfile -Name "Network-External-Updated" -Description "Updated Description" -PrimaryDNSAddress "10.70.1.100"
```

### EXAMPLE 2
```
Set-vRAExternalNetworkProfile -Id 1ada4023-8a02-4349-90bd-732f25001852 -Description "Update Description"
```

## PARAMETERS

### -Id
The network profile id

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The network profile name

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

### -Description
The network profile description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
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
Position: 5
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
Position: 6
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
Position: 7
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
Position: 8
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
Position: 9
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
