function Get-vRAResourceMetrics {
<#
    .SYNOPSIS
    Retrieve metrics for a deployed resource
    
    .DESCRIPTION
    Retrieve metrics for a deployed resource
    
    .PARAMETER Id
    The id of the catalog resource
    
    .PARAMETER Name
    The name of the catalog resource

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAResourceMetrics

    .EXAMPLE
    Get-vRAConsumerCatalogItem -Name vm01 | Get-vRAResourceMetrics

    .EXAMPLE
    Get-vRAResourceMetrics -Id "448fcd09-b8c0-482c-abbc-b3ab818c2e31"

    .EXAMPLE
    Get-vRAResourceMetrics -Name vm01
    
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$false, ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,
    
    [parameter(Mandatory=$false, ValueFromPipelineByPropertyName, ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String[]]$Limit = "100"

    )
                
    try {

        switch ($PsCmdlet.ParameterSetName) {

            # --- Get metrics by resource id
            'ById'{
        
                foreach ($ResoureId in $Id ) {
                
                    $Resource = Get-vRAConsumerResource -Id $ResoureId

                    $MachineId = $Resource.Data.machineId

                    Write-Verbose -Message "Found machineid $($MachineId) for resource $($Resource.name)"

                    # --- Using $filter param here because GET method doesn't return stats
                    $URI = "/management-service/api/management/metrics"

                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body "{}"
                    
                    $Metric = $Response.Content | Where-Object {$_.iaasUuid -eq $MachineId}

                    Write-Verbose -Message "SUCCESS"

                    [pscustomobject] @{

                        Moref = $Metric.moref
                        vCOPSUuid = $Metric.vcopsUuid
                        IaasUuid = $Metric.iaasUuid
                        ServerGuid = $Metric.serverGuid
                        PendingRequest = $Metric.pendingRequest
                        DailyCost = $Metric.dailyCost
                        ExpirationDate = $Metric.expirationDate
                        Health = $Metric.health
                        Stats = $Metric.stats
                        Strings = $Metric.strings

                    }

                }

                break

            }
                
            # --- Get metrics by resource name
            'ByName' {

                foreach ($ResourceName in $Name) {

                    $Resource = Get-vRAConsumerResource -Name $ResourceName

                    $MachineId = $Resource.Data.machineId

                    Write-Verbose -Message "Found machineid $($MachineId) for resource $($ResourceName)"

                    # --- Using $filter param here because GET method doesn't return stats
                    $URI = "/management-service/api/management/metrics"

                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body "{}"
                    
                    $Metric = $Response.Content | Where-Object {$_.iaasUuid -eq $MachineId}

                    Write-Verbose -Message "SUCCESS"

                    [pscustomobject] @{

                        Moref = $Metric.moref
                        vCOPSUuid = $Metric.vcopsUuid
                        IaasUuid = $Metric.iaasUuid
                        ServerGuid = $Metric.serverGuid
                        PendingRequest = $Metric.pendingRequest
                        DailyCost = $Metric.dailyCost
                        ExpirationDate = $Metric.expirationDate
                        Health = $Metric.health
                        Stats = $Metric.stats
                        Strings = $Metric.strings

                    }
                    
                }
                    
                break

            }

            # --- No parameters passed so return all metrics
            'Standard' {

                $URI = "/management-service/api/management/metrics"

                Write-Verbose -Message "Preparing PUT to $($URI)"

                $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body "{}"

                Write-Verbose -Message "SUCCESS"

                foreach ($ResourceMetric in $Response.content) {

                    [pscustomobject] @{

                        Moref = $ResourceMetric.moref
                        vCOPSUuid = $ResourceMetric.vcopsUuid
                        IaasUuid = $ResourceMetric.iaasUuid
                        ServerGuid = $ResourceMetric.serverGuid
                        PendingRequest = $ResourceMetric.pendingRequest
                        DailyCost = $ResourceMetric.dailyCost
                        ExpirationDate = $ResourceMetric.expirationDate
                        Health = $ResourceMetric.health
                        Stats = $ResourceMetric.stats
                        Strings = $ResourceMetric.strings

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