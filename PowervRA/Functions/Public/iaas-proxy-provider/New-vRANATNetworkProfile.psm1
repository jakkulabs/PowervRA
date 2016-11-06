function New-vRANATNetworkProfile {
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
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true, ParameterSetName="Standard")]
        [Parameter(Mandatory=$true, ParameterSetName="UseExternalProfileSettings")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
    
        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [Parameter(Mandatory=$false, ParameterSetName="UseExternalProfileSettings")]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory=$true, ParameterSetName="Standard")]
        [Parameter(Mandatory=$true, ParameterSetName="UseExternalProfileSettings")]
        [ValidateNotNullOrEmpty()]
        [String]$ExternalNetworkProfile,

        [Parameter(Mandatory=$false, ParameterSetName="UseExternalProfileSettings")]
        [ValidateNotNullOrEmpty()]
        [Switch]$UseExternalNetworkProfileSettings,

        [Parameter(Mandatory=$true, ParameterSetName="Standard")]
        [Parameter(Mandatory=$true, ParameterSetName="UseExternalProfileSettings")]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$SubnetMask,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [Parameter(Mandatory=$false, ParameterSetName="UseExternalProfileSettings")]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$GatewayAddress,

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

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [Parameter(Mandatory=$false, ParameterSetName="UseExternalProfileSettings")]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject[]]$IPRanges,

        [Parameter(Mandatory=$true, ParameterSetName="Standard")]
        [Parameter(Mandatory=$true, ParameterSetName="UseExternalProfileSettings")]
        [ValidateSet("ONETOONE", "ONETOMANY")]
        [String]$NatType,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [Parameter(Mandatory=$false, ParameterSetName="UseExternalProfileSettings")]
        [ValidateNotNullOrEmpty()]
        [Switch]$DHCPEnabled,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [Parameter(Mandatory=$false, ParameterSetName="UseExternalProfileSettings")]
        [ValidateScript({$_ -match [IPAddress]$_ })] 
        [String]$DHCPStartAddress,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [Parameter(Mandatory=$false, ParameterSetName="UseExternalProfileSettings")]
        [ValidateScript({$_ -match [IPAddress]$_ })] 
        [String]$DHCPEndAddress,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [Parameter(Mandatory=$false, ParameterSetName="UseExternalProfileSettings")]
        [ValidateNotNullOrEmpty()]
        [Int]$DHCPLeaseTime = 0

    )    

    begin {
    
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
                $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $Template -Verbose:$VerbosePreference

                # --- Output the Successful Result
                Get-vRANATNetworkProfile -Name $Name -Verbose:$VerbosePreference
            }

        }
        catch [Exception]{

            throw
        }
    }
    end {
        
    }

}