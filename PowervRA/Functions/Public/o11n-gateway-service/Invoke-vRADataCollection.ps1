function Invoke-vRADataCollection {
<#
    .SYNOPSIS
    Force a data collection run

    .DESCRIPTION
    Force a data collection run via the o11n-gateway-service provided by vRA. The command assumes that the
    embedded vRO is being used for extensibility and that there is only one IaaS host configured.

    .INPUTS
    None

    .OUTPUTS
    None

    .EXAMPLE
    Invoke-vRADataCollection

#>
[CmdletBinding()][OutputType()]

    Param ()

    try {

        # --- Function requires at least 7.1
        xRequires -Version 7.1

        # --- Get metadata for the request
        $Tenant = $Global:vRAConnection.Tenant
        $RequestedBy = $Global:vRAConnection.Username
        $DataCollectionWorkflowId = "9ef7fdb1-2385-4fe5-adc7-5527ca124da7"

        # --- Retrive the vRO inventory Id of the associated IaaS host (vCAC:vCACHost)
        Write-Verbose -Message "Retrieving the registered vCACHost id"
        $vCACHostId = (Invoke-vRARestMethod -Method GET -URI "/o11n-gateway-service/api/tenants/$($Tenant)/inventory/vCAC:vCACHost").Id

        if (!$vCACHostId) {
            throw "Could not find a registered entity for type vCAC:vCACHost"
        }

        Write-Verbose -Message "Found vCAC:vCACHost entity with id $($vCACHostId)"

        # --- Build the request data
        $RequestData = [PSCustomObject]@{
            entries = @(
                @{
                    key = "host"
                    value = [PSCustomObject]@{
                        type = "string"
                        value = $vCACHostId
                    }
                }
            )
        }

        # --- Build the body of the request and add the RequestData object
        $Body = [PSCustomObject]@{
            requestHeader = $null
            requestData = $RequestData
            correlation = $null
            requestedBy = $RequestedBy
            description = $null
            callbackServiceId = $null
        }

        # --- Submit the request
        Invoke-vRARestMethod -Method POST -URI "/o11n-gateway-service/api/tenants/$($Tenant)/workflows/$($DataCollectionWorkflowId)" -Body ($Body | ConvertTo-Json -Depth 50) -Verbose:$VerbosePreference    
    }
    catch {

        throw $_
    }
}