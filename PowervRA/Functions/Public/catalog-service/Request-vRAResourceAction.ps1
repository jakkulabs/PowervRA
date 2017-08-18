function Request-vRAResourceAction {
<#
    .SYNOPSIS
    Request an available resourceAction for a catalog resource
    
    .DESCRIPTION
    A resourceAction is a specific type of ResourceOperation that is performed by submitting a request. 
    Unlike ResourceExtensions, resource actions can be invoked via the Service Catalog service and subject to approvals.
    
    .PARAMETER ActionId
    The Id for the resource action
    
    .PARAMETER ResourceId
    The id of the resource that the resourceAction will execute against

    .PARAMETER ResourceName
    The name of the resource that the resourceAction will execute against

    .PARAMETER JSON
    A JSON payload for the request

    .PARAMETER Wait
    Wait for the request to complete
    
    .INPUTS
    System.String

    .EXAMPLE
    $ResourceActionId = (Get-vRAResource -Name vm01 | Get-vRAResourceAction "Reboot").id
    Request-vRAResourceAction -Id $ResourceActionId -ResourceName vm01

    .EXAMPLE
    Request-vRAResourceAction -Id 6a301f8c-d868-4908-8348-80ad0eb35b00 -ResourceId 20402e93-fb1d-4bd9-8a51-b809fbb946fd

    .EXAMPLE
    Request-vRAResourceAction -Id 6a301f8c-d868-4908-8348-80ad0eb35b00 -ResourceName vm01

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

    $JSON | Request-vRAResourceAction

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="ByResourceId")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ParameterSetName="ByResourceId")]
        [Parameter(Mandatory=$true,ParameterSetName="ByResourceName")]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [String]$ActionId,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ByResourceId")]
        [ValidateNotNullOrEmpty()]
        [String]$ResourceId,

        [Parameter(Mandatory=$true,ParameterSetName="ByResourceName")]
        [ValidateNotNullOrEmpty()]
        [String]$ResourceName,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true, ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

        [Parameter(Mandatory=$false)]
        [Switch]$Wait
        
    )

    Begin {

        xRequires -Version 7.0

    }

    Process {
                
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

                $JSON = Get-vRAResourceActionRequestTemplate -ActionId $ActionId -ResourceId $ResourceId

            }

            # --- Execute the request
            if ($PSCmdlet.ShouldProcess($ResourceId)){

                $URI = "/catalog-service/api/consumer/resources/$($ResourceId)/actions/$($ActionId)/requests"

                $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $JSON -Verbose:$VerbosePreference

                if ($PSBoundParameters.ContainsKey("Wait")) {

                    While($true) {

                        $URI = "/catalog-service/api/consumer/requests/$($Response.Id)"

                        $Request = Invoke-vRARestMethod -Method Get -URI $URI -Verbose:$VerbosePreference

                        Write-Verbose -Message "State: $($Request.state)"

                        if ($Request.state -eq "SUCCESSFUL" -or $Request.state -Like "*FAILED") {

                            if ($Request.state -Like "*FAILED") {

                                throw "$($Request.requestCompletion.completionDetails)"

                            }

                            Write-Verbose -Message "Request $($Request.id) was successful"
                            break
                        }

                        Start-Sleep -Seconds 5

                    }

                }

                # --- Return the request
                Get-vRARequest -Id $Response.Id

            }

        }
        catch [Exception]{

            throw

        }

    }

    End {

    }

}
