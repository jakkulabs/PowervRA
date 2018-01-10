
function Get-vRARequestDetail {
<#
    .SYNOPSIS
    Get detailed information about vRA request
    
    .DESCRIPTION
    Get detailed information about vRA request. These are result produced by the request (if any)
    
    .PARAMETER Id
    The Id of the request to query
    
    .PARAMETER RequestNumber
    The request number of the request to query

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRARequestDetail -Id 972ab103-950a-4240-8a3d-97174ee07f35
    
    .EXAMPLE
    Get-vRARequestDetail -RequestNumber 965299

    .EXAMPLE
    Get-vRARequestDetail -RequestNumber 965299,965300
    
    .EXAMPLE
    Get-vRARequest -RequestNumber 965299 | Get-vRARequestDetail

#>
[CmdletBinding(DefaultParameterSetName="ById")][OutputType('System.Management.Automation.PSObject', 'System.Object[]')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,
        
        [Parameter(Mandatory=$true,ParameterSetName="ByRequestNumber")]
        [ValidateNotNullOrEmpty()]
        [String[]]$RequestNumber

    )

    Begin {

        # --- Test for vRA API version
        xRequires -Version 7.0

    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- If the id parameter is passed returned detailed information about the request
                'ById' { 

                        foreach ($RequestId in $Id){

                            $RequestNumber = (Get-vRARequest -Id $RequestId).RequestNumber
                            $URI = "/catalog-service/api/consumer/requests/$($RequestId)/forms/details"
                            $RequestDetail = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
                            
                            [PSCustomObject] @{
                                
                                Id = $RequestId
                                RequestNumber = $RequestNumber
                                Detail = $RequestDetail.values.entries
                            }                                
                        }

                        break

                }
                # --- If the request number parameter is passed returned detailed information about the request
                'ByRequestNumber' {

                        foreach ($Number in $RequestNumber){                             

                            $RequestId = (Get-vRARequest -RequestNumber $Number).id
                            $URI = "/catalog-service/api/consumer/requests/$($RequestId)/forms/details"
                            $RequestDetail = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
                            
                            [PSCustomObject] @{
                                
                                Id = $RequestId
                                RequestNumber = $Number
                                Detail = $RequestDetail.values.entries
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

    End {

    }

}
