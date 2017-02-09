function Get-vRAComponentRegistryServiceStatus {
<#
    .SYNOPSIS
    Get component registry service status
    
    .DESCRIPTION
    Get component registry service status

    .PARAMETER Id
    The Id of the service
    
    .PARAMETER Name
    The name of the service

    .PARAMETER Current
    Return the maximum amount of service information. Using this switch will make a connection to the defined
    url of each endpoint and gather data from the ServiceRegistryStatus responses.

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .PARAMETER Page
    The index of the page to display.

    .INPUTS
    System.String
    System.Int
    System.Management.Automation.SwitchParameter

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
     Get-vRAComponentRegistryServiceStatus

    .EXAMPLE
     Get-vRAComponentRegistryServiceStatus -Current

    .EXAMPLE
     Get-vRAComponentRegistryServiceStatus -Limit 9999

    .EXAMPLE
     Get-vRAComponentRegistryServiceStatus -Page 1

    .EXAMPLE
     Get-vRAComponentRegistryServiceStatus -Id xxxxxxxxxxxxxxxxxxxxxxxx

    .EXAMPLE
     Get-vRAComponentRegistryServiceStatus -Name "iaas-service"

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [parameter(Mandatory=$true, ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.SwitchParameter]$Current,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1,

        [parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100
       
    )

    Begin {

        $BaseURI = "/component-registry/services/status"

    }

    Process {

        try {

            switch($PSCmdlet.ParameterSetName) {

                'ById'{

                    foreach ($ServiceId in $Id) {

                        $URI = "$($BaseURI)/current/$($ServiceId)"

                        $Service = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        [PSCustomObject]@{

                            Id = $Service.serviceId
                            Name = $Service.serviceName
                            TypeId = $Service.serviceTypeId
                            NotAvailable = $Service.notAvailable
                            LastUpdated = $Service.lastUpdated
                            EndpointUrl = $Service.statusEndPointUrl
                            ServiceStatus = $Service.serviceStatus
                        }

                    }

                    break
                }

                'ByName' {

                    foreach ($ServiceName in $Name) {

                        $URI = "$($BaseURI)/current?`$filter=name eq '$($ServiceName)'"            

                        $EscapedURI = [uri]::EscapeUriString($URI)

                        $Service = (Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference).content

                        if ($Service.Length -eq 0) {

                            throw "Could not find service with name $($ServiceName)"

                        }

                        [PSCustomObject]@{

                            Id = $Service.serviceId
                            Name = $Service.serviceName
                            TypeId = $Service.serviceTypeId
                            NotAvailable = $Service.notAvailable
                            LastUpdated = $Service.lastUpdated
                            EndpointUrl = $Service.statusEndPointUrl
                            ServiceStatus = $Service.serviceStatus
                        }

                    }

                    break
                }

                'Standard' {

                    # --- Build up the URI string depending on switch
                    if ($PSBoundParameters.ContainsKey("Current")) {

                        Write-Verbose -Message "Current switch parameter passed. Retrieving detailed status information."
                        $URI = "$($BaseURI)/current?limit=$($Limit)&page=$($Page)&`$orderby=name asc"
                    } else {

                        $URI = "$($BaseURI)?limit=$($Limit)&page=$($Page)&`$orderby=name asc"
                    }

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    foreach ($Service in $Response.content) {

                        [PSCustomObject]@{

                            Id = $Service.serviceId
                            Name = $Service.serviceName
                            TypeId = $Service.serviceTypeId
                            NotAvailable = $Service.notAvailable
                            LastUpdated = $Service.lastUpdated
                            EndpointUrl = $Service.statusEndPointUrl
                            ServiceStatus = $Service.serviceStatus
                        }

                    }

                    Write-Verbose -Message "Total: $($Response.metadata.totalElements) | Page: $($Response.metadata.number) of $($Response.metadata.totalPages) | Size: $($Response.metadata.size)"

                    break
                }

            }
            
        }
        catch [Exception]{
            
            throw

        }   


    }

}