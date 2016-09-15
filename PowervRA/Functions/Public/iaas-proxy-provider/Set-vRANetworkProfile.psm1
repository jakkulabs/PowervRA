function Set-vRANetworkProfile {
<#
    .SYNOPSIS
    Set a vRA network profile
    
    .DESCRIPTION
    Set a vRA network profiles
    
    .PARAMTER Id
    The network profile id
    
    .PARAMETER Name
    The network profile name
    
    .PARAMETER Description
    The network profile description

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

    .PARAMETER DHCPEnabled
    Enable DHCP for a NAT network profile. Nat type must be One-to-Many

    .PARAMETER DHCPStartAddress
    The start address of the dhcp range

    .PARAMETER DHCPEndAddress
    The end address of the dhcp range

    .PARAMETER RangeSubnetMask
    The subnet mask for the routed range

    .PARAMETER BaseIPAddress
    The base ip address for the routed range

    .INPUTS
    System.String.
    System.Int.
    System.Switch

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRANetworkProfile -Name "Network-External" | Set-vRANetworkProfile -Name "Network-External-Updated" -Description "Updated Description" -SubnetMask "255.255.0.0" -GatewayAddress "10.70.2.1" -PrimaryDNSAddress "10.70.1.100" -SecondaryDNSAddress "10.70.1.101" -DNSSuffix "corp1.local" -DNSSearchSuffix "corp1.local" -DHCPStartAddress "10.70.1.21" -DHCPEndAddress "10.70.1.31"

    .EXAMPLE
    $DefinedRange1 = New-vRANetworkProfileIPRange -Name "NAT-Range-01" -Description "Disable DHCP Test" -StatIPv4Address "10.70.2.2" -EndIPv4Address "10.70.2.20"
    $DefinedRange2 = New-vRANetworkProfileIPRange -Name "NAT-Range-02" -Description "Disable DHCP Test" -StatIPv4Address "10.70.2.21" -EndIPv4Address "10.70.2.30"

    Get-vRANetworkProfile -Name "Network-NAT" | Set-vRANetworkProfile -DHCPEnabled:$false -IPRanges $DefinedRange1,$DefinedRange1

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High", DefaultParameterSetName="External")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory=$true, ValueFromPipelineByPropertyName, ParameterSetName="External")]
        [parameter(Mandatory=$true, ValueFromPipelineByPropertyName, ParameterSetName="NAT")]
        [parameter(Mandatory=$true, ValueFromPipelineByPropertyName, ParameterSetName="Routed")]
        [String]$Id,

        [parameter(Mandatory=$false, ParameterSetName="External")]
        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [parameter(Mandatory=$false, ParameterSetName="Routed")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
    
        [parameter(Mandatory=$false, ParameterSetName="External")]
        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [parameter(Mandatory=$false, ParameterSetName="Routed")]
        [ValidateNotNullOrEmpty()]
        [String]$Description, 

        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [parameter(Mandatory=$false, ParameterSetName="Routed")]
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

        [parameter(Mandatory=$false, ParameterSetName="External")]
        [parameter(Mandatory=$false, ParameterSetName="NAT")]
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

        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [ValidateSet("ONETOONE", "ONETOMANY")]
        [String]$NatType,

        [parameter(Mandatory=$false, ParameterSetName="NAT")]
        [parameter(Mandatory=$false, ParameterSetName="Routed")]
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
        [Int]$DHCPLeaseTime = 0

    )    

    begin {
    
    }
    
    process {     
           
        try {

            # --- Get the network profile
            
            $URI = "/iaas-proxy-provider/api/network/profiles/$($Id)"

            $NetworkProfile = Invoke-vRARestMethod -Method GET -URI $URI

            # --- Set common properties

            if ($PSBoundParameters.ContainsKey("Name")) {

                Write-Verbose -Message "Updating Name: $($NetworkProfile.name) >> $($Name)"

                $NetworkProfile.name = $Name

            }

            if ($PSBoundParameters.ContainsKey("Description")) {

                Write-Verbose -Message "Updating Description: $($NetworkProfile.description) >> $($Description)"

                $NetworkProfile.description = $Description

            }

            if ($PSBoundParameters.ContainsKey("PrimaryDNSAddress")) {

                Write-Verbose -Message "Updating Primary DNS Address: $($NetworkProfile.primaryDNSAddress) >> $($PrimaryDNSAddress)"

                $NetworkProfile.primaryDNSAddress = $PrimaryDNSAddress

            }

            if ($PSBoundParameters.ContainsKey("SecondaryDNSAddress")) {

                Write-Verbose -Message "Updating Secondary DNS Address: $($NetworkProfile.secondaryDNSAddress) >> $($SecondaryDNSAddress)"

                $NetworkProfile.secondaryDNSAddress = $SecondaryDNSAddress

            }

            if ($PSBoundParameters.ContainsKey("DNSSuffix")) {

                Write-Verbose -Message "Updating DNS Suffix: $($NetworkProfile.dnsSuffix) >> $($DNSSuffix)"

                $NetworkProfile.dnsSuffix = $DNSSuffix

            }

            if ($PSBoundParameters.ContainsKey("DNSSearchSuffix")) {

                Write-Verbose -Message "Updating DNS Search Address: $($NetworkProfile.dnsSearchSuffix) >> $($DNSSearchSuffix)"

                $NetworkProfile.dnsSearchSuffix = $DNSSearchSuffix

            }

            if ($PSBoundParameters.ContainsKey("PrimaryWinsAddress")) {

                Write-Verbose -Message "Updating Primary WINS Address: $($NetworkProfile.primaryWinsAddress) >> $($PrimaryWinsAddress)"

                $NetworkProfile.primaryWinsAddress = $PrimaryWinsAddress

            }

            if ($PSBoundParameters.ContainsKey("SecondaryWinsAddress")) {

                Write-Verbose -Message "Updating Secondary WINS Address: $($NetworkProfile.secondaryWinsAddress) >> $($SecondaryWinsAddress)"

                $NetworkProfile.secondaryWinsAddress = $SecondaryWinsAddress

            }

            switch($NetworkProfile.profileType) {

                'External' {           

                    if ($PSBoundParameters.ContainsKey("GatewayAddress")) {

                        Write-Verbose -Message "Updating Gateway Address: $($NetworkProfile.gatewayAddress) >> $GatewayAddress"

                        $NetworkProfile.gatewayAddress = $GatewayAddress

                    }

                    if ($PSBoundParameters.ContainsKey("IPRanges")) {

                        foreach ($IPRange in $IPRanges) {

                            Write-Verbose -Message "Adding IP Address Range $($IPRange.name) To Network Profile $($NetworkProfile.Name)"

                            $NetworkProfile.definedRanges += $IPRange

                        }

                    }

                    break

                }

                'NAT' {

                    if ($PSBoundParameters.ContainsKey("ExternalNetworkProfile")) {

                        Write-Verbose "Updating $($NetworkProfile.externalNetworkProfileName) >> $($ExternalNetworkProfile)"
                        
                        $ExternalNetworKProfileObject = Get-vRANetworkProfile -Name $ExternalNetworkProfile

                        if ($ExternalNetworkProfileObject.ProfileType -ne "EXTERNAL") {

                            throw "The selected network profile is not external"

                        }

                        $NetworkProfile.externalNetworkProfileId = $ExternalNetworKProfileObject.id
                        $NetworkProfile.externalNetworkProfileName = $ExternalNetworkProfileObject.name

                        if ($UseExternalNetworkProfileSettings) {

                            Write-Verbose -Message "Using External Network Profile Settings"
                    
                            $NetworkProfile.primaryDNSAddress = $ExternalNetworKProfileObject.primaryDNSAddress
                            $NetworkProfile.secondaryDNSAddress = $ExternalNetworKProfileObject.secondaryDNSAddress
                            $NetworkProfile.dnsSuffix = $ExternalNetworKProfileObject.dnsSuffix
                            $NetworkProfile.dnsSearchSuffix = $ExternalNetworKProfileObject.dnsSearchSuffix
                            $NetworkProfile.primaryWinsAddress = $ExternalNetworKProfileObject.primaryWinsAddress
                            $NetworkProfile.secondaryWinsAddress = $ExternalNetworKProfileObject.secondaryWinsAddress

                        }

                    }

                    if ($PSBoundParameters.ContainsKey("NatType")) {

                        Write-Verbose -Message "Updating Nat Type: $($NetworkProfile.natType) >> $($NatType)"

                        $NetworkProfile.natType = $NatType

                        if ($NatType -eq "ONETOONE" -and $NetworkProfile.dhcpConfig) {

                            Write-Verbose -Message "Nat Type is One-to-One and DHCP is ENABLED"
                            Write-Verbose -Message "Disabling DHCP"

                            $NetworkProfile.PSObject.properties.Remove("dhcpConfig")

                        }

                    }

                    if ($PSBoundParameters.ContainsKey("GatewayAddress")) {

                        Write-Verbose -Message "Updating Gateway Address: $($NetworkProfile.gatewayAddress) >> $($GatewayAddress)"

                        $NetworkProfile.gatewayAddress = $GatewayAddress

                    }

                    if ($PSBoundParameters.ContainsKey("DHCPEnabled")) {

                        if ($DHCPEnabled -and !$NetworkProfile.dhcpConfig -and $NetworkProfile.natType -eq "ONETOMANY") {

                            Write-Verbose -Message "DHCP has been enabled and nat type is set to One-to-Many"
                            
                            $DHCPConfigurationTemplate = @"

                                {
                                    "dhcpStartIPAddress": null,
                                    "dhcpEndIPAddress": null,
                                    "dhcpLeaseTimeInSeconds": null
                                }

"@
                          
                            # --- Add the dhcp configuration to the network profile object

                            $DHCPConfiguration = $DHCPConfigurationTemplate | ConvertFrom-Json               

                            Add-Member -InputObject $NetworkProfile -MemberType NoteProperty -Name "dhcpConfig" -Value $DHCPConfiguration

                        }

                        if (!$DHCPEnabled) {

                            if ($NetworkProfile.dhcpConfig) {

                                Write-Verbose -Message "Disabling DHCP"

                                $NetworkProfile.PSObject.properties.Remove("dhcpConfig")

                            }


                        }

                    }

                    if ($PSBoundParameters.ContainsKey("DHCPStartAddress")) {

                        if ($NetworkProfile.dhcpConfig) {

                            Write-Verbose -Message "Updating DHCP Start Address: $($NetworkProfile.dhcpConfig.dhcpStartIPAddress) >> $($DHCPStartAddress)"

                            $NetworkProfile.dhcpConfig.dhcpstartIPAddress = $DHCPStartAddress

                        }

                    }

                    if ($PSBoundParameters.ContainsKey("DHCPEndAddress")) {

                        if ($NetworkProfile.dhcpConfig) {

                            Write-Verbose -Message "Updating DHCP End Address: $($NetworkProfile.dhcpConfig.dhcpEndIPAddress) >> $($DHCPEndAddress)"

                            $NetworkProfile.dhcpConfig.dhcpEndIPAddress = $DHCPEndAddress

                        }

                    }

                    if ($PSBoundParameters.ContainsKey("DHCPLeaseTime")) {

                        if ($NetworkProfile.dhcpConfig) {

                            Write-Verbose -Message "Updating DHCP Lease Time: $($NetworkProfile.dhcpConfig.dhcpLeaseTimeInSeconds) >> $($DHCPLeaseTime)"

                            $NetworkProfile.dhcpConfig.dhcpLeaseTimeInSeconds = $DHCPLeaseTime

                        }

                    }
                    
                    if ($PSBoundParameters.ContainsKey("IPRanges")) {

                        foreach ($IPRange in $IPRanges) {

                            Write-Verbose -Message "Adding IP Address Range $($IPRange.name) To Network Profile $($NetworkProfile.Name)"

                            $NetworkProfile.definedRanges += $IPRange

                        }

                    }

                    break

                }

                'Routed' {
                
                    if ($PSBoundParameters.ContainsKey("ExternalNetworkProfile")){

                        Write-Verbose "Updating $($NetworkProfile.externalNetworkProfileName) >> $($ExternalNetworkProfile)"
                        
                        $ExternalNetworKProfileObject = Get-vRANetworkProfile -Name $ExternalNetworkProfile

                        if ($ExternalNetworkProfileObject.ProfileType -ne "EXTERNAL") {

                            throw "The selected network profile is not external"

                        }

                        $NetworkProfile.externalNetworkProfileId = $ExternalNetworKProfileObject.id
                        $NetworkProfile.externalNetworkProfileName = $ExternalNetworkProfileObject.name

                        if($UseExternalNetworkProfileSettings) {

                            Write-Verbose -Message "Using External Network Profile Settings"
                    
                            $NetworkProfile.primaryDNSAddress = $ExternalNetworKProfileObject.primaryDNSAddress
                            $NetworkProfile.secondaryDNSAddress = $ExternalNetworKProfileObject.secondaryDNSAddress
                            $NetworkProfile.dnsSuffix = $ExternalNetworKProfileObject.dnsSuffix
                            $NetworkProfile.dnsSearchSuffix = $ExternalNetworKProfileObject.dnsSearchSuffix
                            $NetworkProfile.primaryWinsAddress = $ExternalNetworKProfileObject.primaryWinsAddress
                            $NetworkProfile.secondaryWinsAddress = $ExternalNetworKProfileObject.secondaryWinsAddress

                        }

                    }
                                                         
                    if ($PSBoundParameters.ContainsKey("IPRanges")) {

                        foreach ($IPRange in $IPRanges) {

                            Write-Verbose -Message "Adding IP Address Range $($IPRange.name) To Network Profile $($NetworkProfile.Name)"

                            $NetworkProfile.definedRanges += $IPRange

                        }

                    }                     
                                                   
                    break

                }

            }

            $NetworkProfileTemplate = $NetworkProfile | ConvertTo-Json -Depth 20 -Compress

            $NetworkProfileTemplate

            if ($PSCmdlet.ShouldProcess($Id)){

                $URI = "/iaas-proxy-provider/api/network/profiles/$($Id)"
                
                Write-Verbose -Message "Preparing PUT to $($URI)"  
  
                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body $NetworkProfileTemplate

                Write-Verbose -Message "SUCCESS"

                # --- Output the Successful Result
                Get-vRANetworkProfile -Id $Id
            }
        }
        catch [Exception]{

            throw
        }
    }
    
    end {
        
    }
}