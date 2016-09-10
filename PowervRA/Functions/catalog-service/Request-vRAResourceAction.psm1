function Request-vRAResourceAction {
<#
    .SYNOPSIS
    Request an available resourceAction for a catalog resource
    
    .DESCRIPTION
    A resourceAction is a specific type of ResourceOperation that is performed by submitting a request. 
    Unlike ResourceExtensions, resource actions can be invoked via the Service Catalog service and subject to approvals.
    
    .PARAMETER Id
    The Id for the resource action
    
    .PARAMETER ResourceId
    The id of the resource that the resourceAction will execute against

    .PARAMETER ResourceName
    The name of the resource that the resourceAction will execute against

    .INPUTS
    System.String

    .EXAMPLE
    $ResourceActionId = (Get-vRAConsumerResource -Name vm01 | Get-vRAConsumerResourceAction "Reboot").id
    Request-vRAConsumerResourceAction -Id $ResourceActionId -ResourceName vm01

    .EXAMPLE
    Request-vRAConsumerResourceAction -Id 6a301f8c-d868-4908-8348-80ad0eb35b00 -ResourceId 20402e93-fb1d-4bd9-8a51-b809fbb946fd

    .EXAMPLE
    Request-vRAConsumerResourceAction -Id 6a301f8c-d868-4908-8348-80ad0eb35b00 -ResourceName vm01

    .EXAMPLE

    $JSON = @"
        {
            "type":  "com.vmware.vcac.catalog.domain.request.CatalogResourceRequest",
            "resourceId":  "448fcd09-b8c0-482c-abbc-b3ab818c2e31",
            "actionId":  "fae08c75-3506-40f6-9c9b-35966fe9125c",
            "description":  null,
            "data":  {
                         "description":  null,
                         "reasons":  null
                     }
        }        
    "@

    $JSON | Request-vRAConsumerResourceAction

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="ByResourceId")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [String]$ActionId,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName="ByResourceId")]
        [ValidateNotNullOrEmpty()]
        [String]$ResourceId,         

        [Parameter(Mandatory=$true, ParameterSetName="ByResourceName")]
        [ValidateNotNullOrEmpty()]
        [String]$ResourceName,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

    )

    begin {

    }

    process {
                
         try {

            switch ($PsCmdlet.ParameterSetName) {

                'JSON' {

                    # --- Extract id's from json payload
                    $Body = $JSON | ConvertFrom-Json
                    $ResourceId = $Body.resourceId
                    $ActionId = $Body.actionId

                    break

                }

                'ByResourceName' {

                    # --- Get the resource id
                    Write-verbose -Message "Retrieving Id for resource $($Name)"
                    $Resource = Get-vRAResource -Name $ResourceName
                    $ResourceId = $Resource.ResourceId

                    break

                }

            }

            if (!$PSBoundParameters.ContainsKey("JSON")) {

                # --- Get the request template
                Write-Verbose -Message "Retrieving request template"

                $JSON = Get-vRAResourceActionRequestTemplate -Id $ActionId -ResourceId $ResourceId

            }

            # --- Execute the request
            if ($PSCmdlet.ShouldProcess($ResourceId)){

                $URI = "/catalog-service/api/consumer/resources/$($ResourceId)/actions/$($ActionId)/requests"

                Invoke-vRARestMethod -Method POST -URI $URI -Body $JSON -Verbose:$VerbosePreference | Out-Null

            }

        }
        catch [Exception]{

            throw

        }

    }

}