function Get-vRAComponentRegistryServiceEndpoint {
<#
    .SYNOPSIS
    Retrieve a list of endpoints for a service

    .DESCRIPTION
    Retrieve a list of endpoints for a service

    .PARAMETER Id
    The Id of the service. Specifying the Id of the service will retrieve detailed information.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
     Get-vRAComponentRegistryServiceEndpoint

    .EXAMPLE
    Get-vRAComponentRegistryService -Id xxxxxxxxxxxxxxxxxxxxxxxx | Get-vRAComponentRegistryServiceEndpoint

#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id
    )

    Begin {

    }

    Process {

        try {

            foreach ($ServiceId in $Id) {

                $URI = "/component-registry/services/$($ServiceId)/endpoints"
                $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                foreach ($Endpoint in $Response.content) {

                    [PSCustomObject] @{

                        Id = $Endpoint.id
                        CreatedDate = $Endpoint.createdDate
                        LastUpdated = $Endpoint.lastUpdated
                        Url = $Endpoint.url
                        EndPointType = $Endpoint.endpointType
                        ServiceInfoId = $Endpoint.serviceInfoId
                        EndPointAttributes = $Endpoint.endPointAttributes
                        SSlTrusts = $Endpoint.sslTrusts

                    }

                }

            }

            Write-Verbose -Message "Total: $($Response.metadata.totalElements) | Page: $($Response.metadata.number) of $($Response.metadata.totalPages) | Size: $($Response.metadata.size)"

        } catch [Exception] {

            throw
        }

    }

    End {

    }

}

