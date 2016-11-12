function Remove-vRANATNetworkProfile {
<#
    .SYNOPSIS
    Remove a NAT network profile
    
    .DESCRIPTION
    Remove a NAT network profile
    
    .PARAMETER Id
    The id of the NAT network profile

    .PARAMETER Name
    The name of the NAT network profile

    .INPUTS
    System.String

    .EXAMPLE
    Get-vRANATNetworkProfile -Name NetworkProfile01 | Remove-vRANATNetworkProfile

    .EXAMPLE
    Remove-vRANATNetworkProfile -Id 597ff2c1-a35f-4a81-bfd3-ca014

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param (

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id
       
    )
    
    Begin {}
    
    Process {    

        try {

            foreach ($NetworkProfileId in $Id) {

                if ($PSCmdlet.ShouldProcess($NetworkProfileId)){

                    $URI = "/iaas-proxy-provider/api/network/profiles/$($NetworkProfileId)"

                    Invoke-vRARestMethod -Method DELETE -URI "$($URI)" -Verbose:$VerbosePreference | Out-Null

                }

            }

        }
        catch [Exception]{
        
            throw

        }
        
    }   
     
}