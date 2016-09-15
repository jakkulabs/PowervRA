function Get-vRAResourceAction {
<#
    .SYNOPSIS
    Retrieve available Resource Actions for a resource
    
    .DESCRIPTION
    A resourceAction is a specific type of ResourceOperation that is performed by submitting a request. 

    .PARAMETER ResourceId
    The id of the resource

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAConsumerResource -Name vm01 | Get-vRAResourceAction 
    
    .EXAMPLE
    Get-vRAConsumerResource -Name vm01 | Get-vRAResourceAction | Select Id, Name, BindingId

#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$ResourceId

    )

    try {

        # --- Set the uri
        $URI = "/catalog-service/api/consumer/resources/$($ResourceId)/actions"

        # --- Get all available resource actions

        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

        if ($Response.content.Count -lt 1){

            throw "No resource Actions available for the resource. Check the users entitlements."

        }

        foreach ($Action in $Response.content) {

            [PSCustomObject] @{

                Id = $Action.id
                Name = $Action.name
                Description = $Action.description
                Type = $Action.type
                ExtensionId = $Action.extensionId
                ProviderTypeId = $Action.providerTypeId
                BindingId = $Action.bindingId
                IconId = $Action.iconId
                HasForm = $Action.hasForm
                FormScale = $Action.formScale

            }

        }

    }
    catch [Exception]{

        throw
    }

}