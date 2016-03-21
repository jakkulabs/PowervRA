function Get-vRABlueprint {
<#
    .SYNOPSIS
    Retrieve vRA Blueprints
    
    .DESCRIPTION
    Retrieve vRA Blueprints
    
    .PARAMETER Id
    Specify the ID of a Blueprint

    .PARAMETER Name
    Specify the Name of a Blueprint

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRABlueprint
    
    .EXAMPLE
    Get-vRABlueprint -Id "309100fd-b8ce-4e8c-ac8c-a667b8ace54f"

    .EXAMPLE
    Get-vRABlueprint -Name "Blueprint01","Blueprint02"
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
        switch ($PsCmdlet.ParameterSetName) 
        { 
            "ById"  {                
                
                foreach ($BlueprintId in $Id){

                    $URI = "/content-management-service/api/contents/$($BlueprintId)"

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI
                    
                    $Blueprints = $Response | Where-Object {$_.contentTypeId -eq "composite-blueprint"}

                    foreach ($Blueprint in $Blueprints){

                        [pscustomobject]@{

                            Name = $Blueprint.name
                            Id = $Blueprint.id                
                            Description = $Blueprint.description
                            ContentId = $Blueprint.contentId
                            TenantId = $Blueprint.tenantId
                            MimeType = $Blueprint.mimeType
                            SubtenantId = $Blueprint.subtenantId
                            Dependencies = $Blueprint.dependencies
                            CreatedDate = $Blueprint.createdDate
                            LastUpdated = $Blueprint.lastUpdated
                            version = $Blueprint.version
                        }
                    }
                }                              
            
                break
            }

            "ByName"  {                

               foreach ($BlueprintName in $Name){

                    $URI = "/content-management-service/api/contents?`$filter=name%20eq%20'$($BlueprintName)'"

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI
                    
                    $Blueprints = $Response.content | Where-Object {$_.contentTypeId -eq "composite-blueprint"}

                    if (-not $Blueprints){

                        throw "Unable to find vRA Blueprint: $($BlueprintName)"
                    }

                    foreach ($Blueprint in $Blueprints){

                        [pscustomobject]@{

                            Name = $Blueprint.name
                            Id = $Blueprint.id                
                            Description = $Blueprint.description
                            ContentId = $Blueprint.contentId
                            TenantId = $Blueprint.tenantId
                            MimeType = $Blueprint.mimeType
                            SubtenantId = $Blueprint.subtenantId
                            Dependencies = $Blueprint.dependencies
                            CreatedDate = $Blueprint.createdDate
                            LastUpdated = $Blueprint.lastUpdated
                            version = $Blueprint.version
                        }
                    }
                }  
                
                break
            }

            "Standard"  {

                $URI = "/content-management-service/api/contents?`$filter=contentTypeId%20eq%20'composite-blueprint'"

                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method GET -URI $URI

                $Blueprints = $Response.content

                foreach ($Blueprint in $Blueprints){

                    [pscustomobject]@{

                        Name = $Blueprint.name
                        Id = $Blueprint.id                
                        Description = $Blueprint.description
                        ContentId = $Blueprint.contentId
                        TenantId = $Blueprint.tenantId
                        MimeType = $Blueprint.mimeType
                        SubtenantId = $Blueprint.subtenantId
                        Dependencies = $Blueprint.dependencies
                        CreatedDate = $Blueprint.createdDate
                        LastUpdated = $Blueprint.lastUpdated
                        version = $Blueprint.version
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