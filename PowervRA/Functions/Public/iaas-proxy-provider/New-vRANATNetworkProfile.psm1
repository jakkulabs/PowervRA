function New-vRANATNetworkProfile {
<#
    .SYNOPSIS
    Create a vRA nat network profile
    
    .DESCRIPTION
    Create a vRA nat network profile
    
    .PARAMETER Name
    The network profile Name
    
    .PARAMETER Description
    The network profile Description

    .PARAMETER SubnetMask
    The subnet mask of the network profile

    .PARAMETER GatewayAddress
    The gateway address of the network profile

    .PARAMETER ExternalNetworkProfile
    The external network profile that will be linked to that Routed or NAT network profile

    .PARAMETER UseExternalNetworkProfileSettings
    Use the settings from the selected external network profile

    .PARAMETER PrimaryDNSAddress
    The address of the primary DNS server

    .PARAMETER SecondaryDNSAddress
    The address of the secondary DNS server

    .PARAMETER DNSSuffix
    The DNS suffix

    .PARAMETER DNSSearchSuffix
    The DNS search suffix

    .PARAMETER PrimaryWinsAddress
    The address of the primary wins server

    .PARAMETER SecondaryWinsAddress
    The address of the secondary wins server

    .PARAMETER IPRanges
    An array of ip address ranges

    .PARAMETER NatType
    The nat type. This can be One-to-One or One-to-Many

    .PARAMETER DHCPEnabled
    Enable DHCP for a NAT network profile. Nat type must be One-to-Many

    .PARAMETER DHCPStartAddress
    The start address of the dhcp range

    .PARAMETER DHCPEndAddress
    The end address of the dhcp range

    .PARAMETER DHCPLeaseTime
    The dhcp lease time in seconds. The default is 0.

    .INPUTS
    System.String
    System.Int
    System.Switch
    PSCustomObject

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    $DefinedRange1 = New-vRANetworkProfileIPRangeDefinition -Name "External-Range-01" -Description "Example 1" -StartIPv4Address "10.70.1.2" -EndIPv4Address "10.70.1.5"

    New-vRANATNetworkProfile -Name Network-NAT -Description "NAT" -SubnetMask "255.255.255.0" -GatewayAddress "10.70.1.1" -PrimaryDNSAddress "10.70.1.100" -SecondaryDNSAddress "10.70.1.101" -DNSSuffix "corp.local" -DNSSearchSuffix "corp.local" -NatType ONETOMANY -ExternalNetworkProfile "Network-External" -DHCPEnabled -DHCPStartAddress "10.70.1.20" -DHCPEndAddress "10.70.1.30" -IPRanges $DefinedRange1

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
    
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$SubnetMask,

        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$GatewayAddress,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$ExternalNetworkProfile,

        [Parameter(Mandatory=$false, ParameterSetName="UseExternalProfileSettings")]
        [ValidateNotNullOrEmpty()]
        [Switch]$UseExternalNetworkProfileSettings,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$PrimaryDNSAddress,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$SecondaryDNSAddress,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$DNSSuffix,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$DNSSearchSuffix,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateScript({$_ -match [IPAddress]$_ })] 
        [String]$PrimaryWinsAddress,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$SecondaryWinsAddress,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject[]]$IPRanges,

        [Parameter(Mandatory=$true)]
        [ValidateSet("ONETOONE", "ONETOMANY")]
        [String]$NatType,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Switch]$DHCPEnabled,

        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -match [IPAddress]$_ })] 
        [String]$DHCPStartAddress,

        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -match [IPAddress]$_ })] 
        [String]$DHCPEndAddress,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Int]$DHCPLeaseTime = 0

    )    

    xRequires -Version 7.1
               
    try {

        $ExternalNetworkProfileObject = Get-vRAExternalNetworkProfile -Name $ExternalNetworkProfile -Verbose:$VerbosePreference

        if ($PSBoundParameters.ContainsKey("UseExternalNetworkProfileSettings")) {

            Write-Verbose -Message "Using External Network Profile Settings"
        
            if ($ExternalNetworkProfileObject.primaryDNSAddress) {
            
                $PrimaryDNSAddress = $ExternalNetworKProfileObject.primaryDNSAddress

                Write-Verbose -Message "Primary DNS Address: $($PrimaryDNSAddress)"

            }

            if ($ExternalNetworkProfileObject.secondaryDNSAddress) {

                $SecondaryDNSAddress = $ExternalNetworKProfileObject.secondaryDNSAddress

                Write-Verbose -Message "Secondary DNS Address: $($SecondaryDNSAddress)"

            }

            if ($ExternalNetworkProfileObject.dnsSuffix) {

                $DNSSuffix = $ExternalNetworKProfileObject.dnsSuffix

                Write-Verbose -Message "DNS Suffix: $($DNSSuffix)"

            }

            if ($ExternalNetworkProfileObject.dnsSearchSuffix) {

                $DNSSearchSuffix = $ExternalNetworKProfileObject.dnsSearchSuffix

                Write-Verbose -Message "DNS Search Suffix: $($DNSSearchSuffix)"

            }

            if ($ExternalNetworkProfileObject.primaryWinsAddress) {

                $PrimaryWinsAddress = $ExternalNetworKProfileObject.primaryWinsAddress

                Write-Verbose -Message "Primary Wins Address: $($PrimaryWinsAddress)"

            }

            if ($ExternalNetworkProfileObject.secondaryWinsAddress) {

                $SecondaryWinsAddress = $ExternalNetworKProfileObject.secondaryWinsAddress

                Write-Verbose -Message "Secondary Wins Address: $($SecondaryWinsAddress)"

            }

        }

        # --- Define the network profile
        $Template = @"

            {
                "@type": "NATNetworkProfile",
                "name": "$($Name)",
                "description": "$($Description)",
                "createdDate": null,
                "lastModifiedDate": null,
                "isHidden": false,
                "definedRanges": [],
                "reclaimedAddresses":  null,
                "IPAMEndpointId":  null,
                "IPAMEndpointName":  null,
                "addressSpaceExternalId":  null,
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
            $Template = $Object | ConvertTo-Json -Depth 20

        }

        if ($PSBoundParameters.ContainsKey("IPRanges")) {

            $Object = $Template | ConvertFrom-Json

            foreach ($IPRange in $IPRanges) {

                $Object.definedRanges += $IPRange

            }

            $Template = $Object | ConvertTo-Json -Depth 20 -Compress

        }

        if ($PSCmdlet.ShouldProcess($Name)){

            $URI = "/iaas-proxy-provider/api/network/profiles"
            
            # --- Run vRA REST Request
            Invoke-vRARestMethod -Method POST -URI $URI -Body $Template -Verbose:$VerbosePreference | Out-Null

            # --- Output the Successful Result
            Get-vRANATNetworkProfile -Name $Name -Verbose:$VerbosePreference

        }

    }
    catch [Exception]{

        throw
        
    }

}