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

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

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
    [String[]]$Name,
    
    [parameter(Mandatory=$false,ValueFromPipeline=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100" 
    )

    try {
    
        $URI = "/advanced-designer-service/api/tenants/$($Global:vRAConnection.Tenant)/blueprints"

        # --- Run vRA REST Request
        $Response = Invoke-vRARestMethod -Method GET -URI $URI   
                     
        switch ($PsCmdlet.ParameterSetName) 
        { 
            "ById"  {                 

                foreach ($ASDBlueprintId in $Id){
                    
                    $ASDBlueprint = $Response.content | Where-Object {$_.Id.id -eq $ASDBlueprintId}

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

            "ByName"  {                

               foreach ($ASDBlueprintName in $Name){

                    $ASDBlueprint = $Response.content | Where-Object {$_.name -eq $ASDBlueprintName}

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

            "Standard"  {

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