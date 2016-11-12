function Set-vRAExternalNetworkProfile {
<#
    .SYNOPSIS
    Set a vRA external network profile
    
    .DESCRIPTION
    Set a vRA external network profiles
    
    .PARAMETER Id
    The network profile id
    
    .PARAMETER Name
    The network profile name
    
    .PARAMETER Description
    The network profile description

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

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAExternalNetworkProfile -Name "Network-External" | Set-vRAExternalNetworkProfile -Name "Network-External-Updated" -Description "Updated Description" -PrimaryDNSAddress "10.70.1.100"

    .EXAMPLE
    Set-vRAExternalNetworkProfile -Id 1ada4023-8a02-4349-90bd-732f25001852 -Description "Update Description"

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
    
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Description, 

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
        [String]$SecondaryWinsAddress

    )    

    begin {

        xRequires -Version 7.1
    
    }
    
    process {     
           
        try {

            # --- Get the network profile     
            $URI = "/iaas-proxy-provider/api/network/profiles/$($Id)"

            $NetworkProfile = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

            if ($NetworkProfile.profileType -ne "EXTERNAL") {

                throw "Network Profile $($NetworkProfile.id) is not of type EXTERNAL"

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

            $NetworkProfileTemplate = $NetworkProfile | ConvertTo-Json -Depth 100

            if ($PSCmdlet.ShouldProcess($Id)){

                $URI = "/iaas-proxy-provider/api/network/profiles/$($Id)"
                  
                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body $NetworkProfileTemplate -Verbose:$VerbosePreference

                # --- Output the Successful Result
                Get-vRAExternalNetworkProfile -Id $Id -Verbose:$VerbosePreference

            }

        }
        catch [Exception]{

            throw

        }

    }
    
    end {
        
    }

}