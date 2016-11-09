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
    Remove-vRARoutedNetworkProfile -Name NetworkProfile01

    .EXAMPLE
    Remove-vRARoutedNetworkProfile -Id 597ff2c1-a35f-4a81-bfd3-ca014

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="ById")]

    Param (

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName, ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true, ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name   
       
    )
    
    begin {}
    
    process {    

        try {

            switch ($PSCmdlet.ParameterSetName) {

                'ById' {

                    foreach ($NetworkProfileId in $Id) {

                        if ($PSCmdlet.ShouldProcess($NetworkProfileId)){

                            $URI = "/iaas-proxy-provider/api/network/profiles/$($NetworkProfileId)"
            
                            Write-Verbose -Message "Preparing DELETE to $($URI)"

                            $Response = Invoke-vRARestMethod -Method DELETE -URI "$($URI)"

                            Write-Verbose -Message "SUCCESS"

                        }

                    }

                    break

                }

                'ByName' {

                    foreach ($NetworkProfileName in $Name) {

                        if ($PSCmdlet.ShouldProcess($NetworkProfileName)){

                            $Id = (Get-vRANetworkProfile -Name $NetworkProfileName).id

                            $URI = "/iaas-proxy-provider/api/network/profiles/$($Id)"
            
                            Write-Verbose -Message "Preparing DELETE to $($URI)"

                            $Response = Invoke-vRARestMethod -Method DELETE -URI "$($URI)"

                            Write-Verbose -Message "SUCCESS"

                        }

                    }

                    break

                }
  
            }
    
        }
        catch [Exception]{
        
            throw

        }
        
    }   
     
}