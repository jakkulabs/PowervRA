function Remove-vRAExternalNetworkProfile {
<#
    .SYNOPSIS
    Remove an external network profile
    
    .DESCRIPTION
    Remove an external network profile
    
    .PARAMETER Id
    The id of the external network profile

    .PARAMETER Name
    The name of the external network profile

    .INPUTS
    System.String

    .EXAMPLE
    Get-vRAExternalNetworkProfile -Name NetworkProfile01 | Remove-vRAExternalNetworkProfile

    .EXAMPLE
    Remove-vRExternalANetworkProfile -Id 597ff2c1-a35f-4a81-bfd3-ca014

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