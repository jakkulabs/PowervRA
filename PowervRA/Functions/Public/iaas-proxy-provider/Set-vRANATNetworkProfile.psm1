function Set-vRANATNetworkProfile {
<#
    .SYNOPSIS
    Set a vRA network profile
    
    .DESCRIPTION
    Set a vRA network profiles
    
    .PARAMETER Id
    The network profile id
    
    .PARAMETER Name
    The network profile name
    
    .PARAMETER Description
    The network profile description

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

    .PARAMETER PrimaryWinsAddress
    The address of the primary wins server

    .PARAMETER SecondaryWinsAddress
    The address of the secondary wins server

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
    System.String.
    System.Int.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRANATNetworkProfile -Name "Network-Nat" | Set-vRANATNetworkProfile -Name "Network-NAT-Updated" -Description "Updated Description" -GatewayAddress "10.70.2.1" -PrimaryDNSAddress "10.70.1.100"

    .EXAMPLE
    Set-vRANATNetworkProfile -Id 1ada4023-8a02-4349-90bd-732f25001852 -Description "Updated Description"

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String]$Id,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
    
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$GatewayAddress,

        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$PrimaryDNSAddress,

        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$SecondaryDNSAddress,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$DNSSuffix,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$DNSSearchSuffix,

        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -match [IPAddress]$_ })] 
        [String]$PrimaryWinsAddress,

        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [String]$SecondaryWinsAddress,

        [Parameter(Mandatory=$false)]
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
        [Int]$DHCPLeaseTime

    )    

    begin {
    
    }
    
    process {     
           
        try {

            # --- Get the network profile     
            $URI = "/iaas-proxy-provider/api/network/profiles/$($Id)"

            $NetworkProfile = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

            if ($NetworkProfile.profileType -ne "NAT") {

                throw "Network Profile $($NetworkProfile.id) is not of type NAT"

            }

            # --- Set Properties
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

            if ($PSBoundParameters.ContainsKey("GatewayAddress")) {

                Write-Verbose -Message "Updating Gateway Address: $($NetworkProfile.gatewayAddress) >> $GatewayAddress"

                $NetworkProfile.gatewayAddress = $GatewayAddress

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

            $NetworkProfileTemplate = $NetworkProfile | ConvertTo-Json -Depth 100

            if ($PSCmdlet.ShouldProcess($Id)){

                $URI = "/iaas-proxy-provider/api/network/profiles/$($Id)"
                  
                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body $NetworkProfileTemplate -Verbose:$VerbosePreference

                # --- Output the Successful Result
                Get-vRANATNetworkProfile -Id $Id -Verbose:$VerbosePreference
                
            }

        }
        catch [Exception]{

            throw

        }

    }
    
    end {
        
    }

}