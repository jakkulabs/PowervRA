function Get-vRAServiceBlueprint {
<#
    .SYNOPSIS
    Retrieve vRA ASD Blueprints

    .DESCRIPTION
    Retrieve vRA ASD Blueprints

    .PARAMETER Id
    Specify the ID of an ASD Blueprint

    .PARAMETER Name
    Specify the Name of an ASD Blueprint

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAServiceBlueprint

    .EXAMPLE
    Get-vRAServiceBlueprint -Id "309100fd-b8ce-4e8c-ac8c-a667b8ace54f"

    .EXAMPLE
    Get-vRAServiceBlueprint -Name "ASDBlueprint01","ASDBlueprint02"
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,

    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name
    )

    begin {}

    process {

        try {


            switch ($PsCmdlet.ParameterSetName)
            {
                "ById"  {

                    foreach ($ASDBlueprintId in $Id){

                        $URI = "/advanced-designer-service/api/tenants/$($Script:vRAConnection.Tenant)/blueprints/$($ASDBlueprintId)"

                        # --- Run vRA REST Request
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI

                        [pscustomobject]@{

                            Name = $Response.name
                            Id = $Response.id.id
                            Description = $Response.description
                            WorkflowId = $Response.workflowId
                            CatalogRequestInfoHidden = $Response.catalogRequestInfoHidden
                            Forms = $Response.forms
                            Status = $Response.status
                            StatusName = $Response.statusName
                            Version = $Response.version
                            OutputParameter = $Response.outputParameter
                        }
                    }

                    break
                }

                "ByName"  {

                foreach ($ASDBlueprintName in $Name){

                        $URI = "/advanced-designer-service/api/tenants/$($Script:vRAConnection.Tenant)/blueprints?`$filter=name%20eq%20'$($ASDBlueprintName)'"

                        # --- Run vRA REST Request
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI

                        if ($Response.content){

                            $ASDBlueprints = $Response.content
                        }
                        else {

                            throw "Unable to find Service Blueprint with name $($ASDBlueprintName)"
                        }

                        foreach ($ASDBlueprint in $ASDBlueprints){

                            [pscustomobject]@{

                                Name = $ASDBlueprint.name
                                Id = $ASDBlueprint.id.id
                                Description = $ASDBlueprint.description
                                WorkflowId = $ASDBlueprint.workflowId
                                CatalogRequestInfoHidden = $ASDBlueprint.catalogRequestInfoHidden
                                Forms = $ASDBlueprint.forms
                                Status = $ASDBlueprint.status
                                StatusName = $ASDBlueprint.statusName
                                Version = $ASDBlueprint.version
                                OutputParameter = $ASDBlueprint.outputParameter
                            }
                        }
                    }

                    break
                }

                "Standard"  {

                    $URI = "/advanced-designer-service/api/tenants/$($Script:vRAConnection.Tenant)/blueprints"

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    $ASDBlueprints = $Response.content

                    foreach ($ASDBlueprint in $ASDBlueprints){

                        [pscustomobject]@{

                            Name = $ASDBlueprint.name
                            Id = $ASDBlueprint.id.id
                            Description = $ASDBlueprint.description
                            WorkflowId = $ASDBlueprint.workflowId
                            CatalogRequestInfoHidden = $ASDBlueprint.catalogRequestInfoHidden
                            Forms = $ASDBlueprint.forms
                            Status = $ASDBlueprint.status
                            StatusName = $ASDBlueprint.statusName
                            Version = $ASDBlueprint.version
                            OutputParameter = $ASDBlueprint.outputParameter
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