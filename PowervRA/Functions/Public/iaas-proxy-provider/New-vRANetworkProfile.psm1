function New-vRANetworkProfile {
<#
    .SYNOPSIS
    Create a vRA network profile
    
    .DESCRIPTION
    Create a vRA network profiles
    
    .PARAMETER Name
    The network profile Name
    
    .PARAMETER Description
    The network profile Description

    .PARAMETER Hidden
    Creates a hidden network profile

    .PARAMETER SubnetMask
    The subnet mask of the network profile

    .PARAMETER GatewayAddress
    The gateway address of the network profile

    .PARAMETER PrimaryDNSAddress
    The address of the primary DNS server

    .PARAMETER SecondaryDNSAddress
    The address of the secondary DNS server

    .PARAMETER DNSSuffix
    The DNS suffix

    .PARAMETER DNSSearchSuffix
    The DNS search suffix

    .PARAMETER IPRanges
    An array of ip address ranges

    .PARAMETER PrimaryWinsAddress
    The address of the primary wins server

    .PARAMETER SecondaryWinsAddress
    The address of the secondary wins server

    .PARAMETER NatType
    The nat type. This can be One-to-One or One-to-Many

    .PARAMETER ExternalNetworkProfile
    The external network profile that will be linked to that Routed or NAT network profile

    .PARAMETER UseExternalNetworkProfileSettings

    .PARAMETER DHCPEnabled
    Enable DHCP for a NAT network profile. Nat type must be One-to-Many

    .PARAMETER DHCPStartAddress
    The start address of the dhcp range

    .PARAMETER DHCPEndAddress
    The end address of the dhcp range

    .INPUTS
    System.String.
    System.Int.
    System.Switch

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    $DefinedRange1 = New-vRANetworkProfileIPRange -Name "External-Range-01" -Description "Example 1" -StatIPv4Address "10.60.1.2" -EndIPv4Address "10.60.1.5"
    $DefinedRange2 = New-vRANetworkProfileIPRange -Name "External-Range-02" -Description "Example 2" -StatIPv4Address "10.60.1.10" -EndIPv4Address "10.60.1.20"

    New-vRANetworkProfile -ProfileType External -Name Network-External -Description "External" -SubnetMask "255.255.255.0" -GatewayAddress "10.60.1.1" -PrimaryDNSAddress "10.60.1.100" -SecondaryDNSAddress "10.60.1.101" -DNSSuffix "corp.local" -DNSSearchSuffix "corp.local" -IPRanges $DefinedRange1,$DefinedRange2

    .EXAMPLE
    New-vRANetworkProfile -ProfileType NAT -Name Network-NAT -Description "NAT" -SubnetMask "255.255.255.0" -GatewayAddress "10.70.1.1" -PrimaryDNSAddress "10.70.1.100" -SecondaryDNSAddress "10.70.1.101" -DNSSuffix "corp.local" -DNSSearchSuffix "corp.local" -NatType ONETOMANY -ExternalNetworkProfile "Network-External" -DHCPEnabled -DHCPStartAddress "10.70.1.20" -DHCPEndAddress "10.70.1.30"

    .EXAMPLE
    New-vRANetworkProfile -ProfileType Routed -Name Network-Routed -Description "Routed" -SubnetMask "255.255.255.0" -GatewayAddress "10.80.1.1" -PrimaryDNSAddress "10.80.1.100" -SecondaryDNSAddress "10.80.1.101" -DNSSuffix "corp.local" -DNSSearchSuffix "corp.local" -ExternalNetworkProfile "Network-External" -RangeSubnetMask "255.255.255.0" -BaseIPAddress "10.80.1.2"

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory=$true, ValueFromPipelineByPropertyName, ParameterSetName="External")]
        [parameter(Mandatory=$true, ValueFromPipelineByPropertyName, ParameterSetName="NAT")]
        [parameter(Mandatory=$true, ValueFromPipelineByPropertyName, ParameterSetName="Routed")]
        [ValidateSet("External", "NAT", "Routed")]
        [String]$ProfileType,

        [parameter(Mandatory=$true, ParameterSetName="External")]
        [parameter(Mandatory=$true, ParameterSetName="NAT")]
        [parameter(Mandatory=$true, ParameterSetName="Routed")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
    
        [parameter(Mandatory=$false, ParameterSetName="External")]
        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [parameter(Mandatory=$false, ParameterSetName="Routed")]
        [ValidateNotNullOrEmpty()]
        [String]$Description, 

        [parameter(Mandatory=$true, ParameterSetName="External")]
        [parameter(Mandatory=$true, ParameterSetName="NAT")]
        [parameter(Mandatory=$true, ParameterSetName="Routed")]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$SubnetMask,

        [parameter(Mandatory=$false, ParameterSetName="External")]
        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [parameter(Mandatory=$false, ParameterSetName="Routed")]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$GatewayAddress,

        [parameter(Mandatory=$false, ParameterSetName="External")]
        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [parameter(Mandatory=$false, ParameterSetName="Routed")]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$PrimaryDNSAddress,

        [parameter(Mandatory=$false, ParameterSetName="External")]
        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [parameter(Mandatory=$false, ParameterSetName="Routed")]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$SecondaryDNSAddress,

        [parameter(Mandatory=$false, ParameterSetName="External")]
        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [parameter(Mandatory=$false, ParameterSetName="Routed")]
        [ValidateNotNullOrEmpty()]
        [String]$DNSSuffix,

        [parameter(Mandatory=$false, ParameterSetName="External")]
        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [parameter(Mandatory=$false, ParameterSetName="Routed")]
        [ValidateNotNullOrEmpty()]
        [String]$DNSSearchSuffix,

        [parameter(Mandatory=$true, ParameterSetName="External")]
        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [parameter(Mandatory=$true, ParameterSetName="Routed")]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject[]]$IPRanges,

        [parameter(Mandatory=$false, ParameterSetName="External")]
        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [parameter(Mandatory=$false, ParameterSetName="Routed")]
        [ValidateScript({$_ -match [IPAddress]$_ })] 
        [String]$PrimaryWinsAddress,

        [parameter(Mandatory=$false, ParameterSetName="External")]
        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [parameter(Mandatory=$false, ParameterSetName="Routed")]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$SecondaryWinsAddress,

        [parameter(Mandatory=$true, ParameterSetName="NAT")]
        [ValidateSet("ONETOONE", "ONETOMANY")]
        [String]$NatType,

        [parameter(Mandatory=$true, ParameterSetName="NAT")]
        [parameter(Mandatory=$true, ParameterSetName="Routed")]
        [ValidateNotNullOrEmpty()]
        [String]$ExternalNetworkProfile,

        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [parameter(Mandatory=$false, ParameterSetName="Routed")]
        [ValidateNotNullOrEmpty()]
        [Switch]$UseExternalNetworkProfileSettings,

        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [ValidateNotNullOrEmpty()]
        [Switch]$DHCPEnabled,

        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [ValidateScript({$_ -match [IPAddress]$_ })] 
        [String]$DHCPStartAddress,

        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [ValidateScript({$_ -match [IPAddress]$_ })] 
        [String]$DHCPEndAddress,

        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [ValidateNotNullOrEmpty()]
        [Int]$DHCPLeaseTime = 0,
        
        [parameter(Mandatory=$false, ParameterSetName="Routed")]
        [ValidateScript({$_ -match [IPAddress]$_ })] 
        [String]$RangeSubnetMask,

        [parameter(Mandatory=$false, ParameterSetName="Routed")]
        [ValidateScript({$_ -match [IPAddress]$_ })] 
        [String]$BaseIPAddress

    )    

    begin {
    
    }
    
    process {     
           
        try {

            switch($PSBoundParameters.ProfileType) {

                'External' {

                    Write-Verbose -Message "Creating an EXTERNAL network profile"

                    # --- Define the network profile template

                    $Template = @"

                        {
                            "@type": "ExternalNetworkProfile",
                            "name": "$($Name)",
                            "description": "$($Description)",
                            "createdDate": null,
                            "lastModifiedDate": null,
                            "isHidden": false,
                            "definedRanges": [],
                            "profileType": "EXTERNAL",
                            "subnetMask": "$($SubnetMask)",
                            "gatewayAddress": "$($GatewayAddress)",
                            "primaryDnsAddress": "$($PrimaryDNSAddress)",
                            "secondaryDnsAddress": "$($SecondaryDNSAddress)",
                            "dnsSuffix": "$($DNSSuffix)",
                            "dnsSearchSuffix": "$($DNSSearchSuffix)",
                            "primaryWinsAddress": "$($PrimaryWinsAddress)",
                            "secondaryWinsAddress": "$($SecondaryWinsAddress)"
                        }

"@

                    if ($PSBoundParameters.ContainsKey("IPRanges")) {

                        $Object = $Template | ConvertFrom-Json

                        foreach ($IPRange in $IPRanges) {

                            $Object.definedRanges += $IPRange

                        }

                        $Template = $Object | ConvertTo-Json -Depth 20 -Compress

                    }
                
                    break

                }

                'NAT' {

                    Write-Verbose -Message "Creating a NAT network profile"

                    $ExternalNetworkProfileObject = Get-vRANetworkProfile -Name $ExternalNetworkProfile

                    # --- Check if the returned network profile is external

                    if ($ExternalNetworkProfileObject.ProfileType -ne "EXTERNAL") {

                        throw "The selected network profile is not external"

                    }

                    if ($UseExternalNetworkProfileSettings) {

                        Write-Verbose -Message "Using External Network Profile Settings"
                    
                        if ($ExternalNetworkProfileObject.primaryDNSAddress) {
                        
                            $PrimaryDNSAddress = $ExternalNetworKProfileObject.primaryDNSAddress

                        }

                        if ($ExternalNetworkProfileObject.secondaryDNSAddress) {

                            $SecondaryDNSAddress = $ExternalNetworKProfileObject.secondaryDNSAddress

                        }

                        if ($ExternalNetworkProfileObject.dnsSuffix) {

                            $DNSSuffix = $ExternalNetworKProfileObject.dnsSuffix

                        }

                        if ($ExternalNetworkProfileObject.dnsSearchSuffix) {

                            $DNSSearchSuffix = $ExternalNetworKProfileObject.dnsSearchSuffix

                        }

                        if ($ExternalNetworkProfileObject.primaryWinsAddress) {

                            $PrimaryWinsAddress = $ExternalNetworKProfileObject.primaryWinsAddress

                        }

                        if ($ExternalNetworkProfileObject.secondaryWinsAddress) {

                            $SecondaryWinsAddress = $ExternalNetworKProfileObject.secondaryWinsAddress

                        }

                    }

                    # --- Define the network profile template

                    $Template = @"

                        {
                            "@type": "NATNetworkProfile",
                            "name": "$($Name)",
                            "description": "$($Description)",
                            "createdDate": null,
                            "lastModifiedDate": null,
                            "isHidden": false,
                            "definedRanges": [],
                            "profileType": "NAT",
                            "natType": "$($NatType)",
                            "subnetMask": "$($SubnetMask)",
                            "gatewayAddress": "$($GatewayAddress)",
                            "primaryDnsAddress": "$($PrimaryDNSAddress)",
                            "secondaryDnsAddress": "$($SecondaryDNSAddress)",
                            "dnsSuffix": "$($DNSSuffix)",
                            "dnsSearchSuffix": "$($DNSSearchSuffix)",
                            "primaryWinsAddress": "$($PrimaryWinsAddress)",
                            "secondaryWinsAddress": "$($SecondaryWinsAddress)",
                            "externalNetworkProfileId": "$($ExternalNetworkProfileObject.id)",
                            "externalNetworkProfileName": "$($ExternalNetworkProfileObject.name)"
                        }

"@

                    # --- Enable DHCP

                    if ($DHCPEnabled -and $NatType -eq "ONETOMANY") {

                        Write-Verbose -Message "DHCP has been enabled and nat type is set to One-to-Many"
                            
                        $DHCPConfigurationTemplate = @"

                                {
                                    "dhcpStartIPAddress": "$($DHCPStartAddress)",
                                    "dhcpEndIPAddress": "$($DHCPEndAddress)",
                                    "dhcpLeaseTimeInSeconds": $($DHCPLeaseTime)
                                }



"@
                            
                        # --- Add the dhcp configuration to the network profile object

                        $Object = $Template | ConvertFrom-Json

                        $DHCPConfiguration = $DHCPConfigurationTemplate | ConvertFrom-Json               

                        Add-Member -InputObject $Object -MemberType NoteProperty -Name "dhcpConfig" -Value $DHCPConfiguration

                        # --- Convert the modified object back to json

                        $Template = $Object | ConvertTo-Json -Depth 20 -Compress

                    }

                    if ($PSBoundParameters.ContainsKey("IPRanges")) {

                        $Object = $Template | ConvertFrom-Json

                        foreach ($IPRange in $IPRanges) {

                            $Object.definedRanges += $IPRange

                        }

                        $Template = $Object | ConvertTo-Json -Depth 20 -Compress

                    }
                
                    break

                }

                'Routed' {

                    Write-Verbose -Message "Creating a ROUTED network profile" 
                    
                    $ExternalNetworkProfileObject = Get-vRANetworkProfile -Name $ExternalNetworkProfile

                    # --- Check if the returned network profile is external

                    if ($ExternalNetworkProfileObject.ProfileType -ne "EXTERNAL") {

                        throw "The selected network profile is not external"

                    }

                    if ($UseExternalNetworkProfileSettings) {

                        Write-Verbose -Message "Using External Network Profile Settings"
                    
                        if ($ExternalNetworkProfileObject.primaryDNSAddress) {
                        
                            $PrimaryDNSAddress = $ExternalNetworKProfileObject.primaryDNSAddress

                        }

                        if ($ExternalNetworkProfileObject.secondaryDNSAddress) {

                            $SecondaryDNSAddress = $ExternalNetworKProfileObject.secondaryDNSAddress

                        }

                        if ($ExternalNetworkProfileObject.dnsSuffix) {

                            $DNSSuffix = $ExternalNetworKProfileObject.dnsSuffix

                        }

                        if ($ExternalNetworkProfileObject.dnsSearchSuffix) {

                            $DNSSearchSuffix = $ExternalNetworKProfileObject.dnsSearchSuffix

                        }

                        if ($ExternalNetworkProfileObject.primaryWinsAddress) {

                            $PrimaryWinsAddress = $ExternalNetworKProfileObject.primaryWinsAddress

                        }

                        if ($ExternalNetworkProfileObject.secondaryWinsAddress) {

                            $SecondaryWinsAddress = $ExternalNetworKProfileObject.secondaryWinsAddress

                        }

                    }

                    # --- Define the network profile template
               
                    $Template = @"

                        {
                            "@type": "RoutedNetworkProfile",
                            "name": "$($Name)",
                            "description": "$($Description)",
                            "createdDate": null,
                            "lastModifiedDate": null,
                            "isHidden": false,
                            "definedRanges": [],
                            "profileType": "ROUTED",
                            "rangeSubnetMask": "$($RangeSubnetMask)",
                            "subnetMask": "$($SubnetMask)",
                            "primaryDnsAddress": "$($PrimaryDNSAddress)",
                            "secondaryDnsAddress": "$($SecondaryDNSAddress)",
                            "dnsSuffix": "$($DNSSuffix)",
                            "dnsSearchSuffix": "$($DNSSearchSuffix)",
                            "primaryWinsAddress": "$($PrimaryWinsAddress)",
                            "secondaryWinsAddress": "$($SecondaryWinsAddress)",
                            "externalNetworkProfileId": "$($ExternalNetworkProfileObject.id)",
                            "externalNetworkProfileName": "$($ExternalNetworkProfileObject.name)",
                            "baseIP": "$($BaseIPAddress)"
                        }

"@

                    if ($PSBoundParameters.ContainsKey("IPRanges")) {

                        $Object = $Template | ConvertFrom-Json

                        foreach ($IPRange in $IPRanges) {

                            $Object.definedRanges += $IPRange

                        }

                        $Template = $Object | ConvertTo-Json -Depth 20 -Compress

                    }                

                    break

                }

            }

            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/iaas-proxy-provider/api/network/profiles"
                
                Write-Verbose -Message "Preparing POST to $($URI)"  
  
                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $Template

                Write-Verbose -Message "SUCCESS"

                # --- Output the Successful Result
                Get-vRANetworkProfile -Name $Name
            }

        }
        catch [Exception]{

            throw
        }
    }
    end {
        
    }
}