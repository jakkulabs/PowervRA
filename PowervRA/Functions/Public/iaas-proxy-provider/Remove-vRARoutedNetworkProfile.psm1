function Remove-vRARoutedNetworkProfile {
<#
    .SYNOPSIS
    Remove a routed network profile
    
    .DESCRIPTION
    Remove a routed network profile
    
    .PARAMETER Id
    The id of the routed network profile

    .PARAMETER Name
    The name of the routed network profile

    .INPUTS
    System.String

    .EXAMPLE
    Get-vRARoutedNetworkProfile -Name NetworkProfile01 | Remove-vRARoutedNetworkProfile

    .EXAMPLE
    Remove-vRARoutedNetworkProfile -Id 597ff2c1-a35f-4a81-bfd3-ca014

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