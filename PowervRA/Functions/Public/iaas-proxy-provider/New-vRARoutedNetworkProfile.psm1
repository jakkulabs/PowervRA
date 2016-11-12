function New-vRARoutedNetworkProfile {
<#
    .SYNOPSIS
    Create a vRA routed network profile
    
    .DESCRIPTION
    Create a vRA routed network profiles
    
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

    .PARAMETER RangeSubnetMask
    The subnetMask for the routed range

    .PARAMETER BaseIPAddress
    The base ip of the routed range

    .INPUTS
    System.String
    System.Switch
    PSCustomObject

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRARoutedNetworkProfile -Name Network-Routed -Description "Routed" -SubnetMask "255.255.255.0" -GatewayAddress "10.80.1.1" -PrimaryDNSAddress "10.80.1.100" -SecondaryDNSAddress "10.80.1.101" -DNSSuffix "corp.local" -DNSSearchSuffix "corp.local" -ExternalNetworkProfile "Network-External" -RangeSubnetMask "255.255.255.0" -BaseIPAddress "10.80.1.2"

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

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
        [ValidateScript({$_ -match [IPAddress]$_ })] 
        [String]$RangeSubnetMask,

        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -match [IPAddress]$_ })] 
        [String]$BaseIPAddress

    )    

    begin {

        xRequires -Version 7.1
    
    }
    
    process {     
           
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

            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/iaas-proxy-provider/api/network/profiles"
                  
                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $Template -Verbose:$VerbosePreference

                # --- Output the Successful Result
                Get-vRARoutedNetworkProfile -Name $Name -Verbose:$VerbosePreference

            }

        }
        catch [Exception]{

            throw
        }

    }
    end {
        
    }
    
}