function Get-vRAConsumerCatalogItemRequestTemplate {
<#
    .SYNOPSIS
    Get the request template of a catalog item that the user is entitled to see
    
    .DESCRIPTION
    Get the request template of a catalog item that the user is entitled to see and return a JSON payload to reuse in a request
    
    .PARAMETER Id
    The id of the catalog item

    .PARAMETER Name
    The name of the catalog item

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.String

    .EXAMPLE
    Get-vRAConsumerCatalogItemRequestTemplate -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e
    
    .EXAMPLE
    Get-vRAConsumerCatalogItemRequestTemplate -Name Centos_Template
    
    .EXAMPLE
    Get-vRAConsumerEntitledCatalogItem | Get-vRAConsumerCatalogItemRequestTemplate
    
    .EXAMPLE
    Get-vRAConsumerEntitledCatalogItem -Name Centos_Template | Get-vRAConsumerCatalogItemRequestTemplate   
 
    .EXAMPLE
    Get-vRAConsumerEntitledCatalogItem -Name Centos_Template | Get-vRAConsumerCatalogItemRequestTemplate | ConvertFrom-Json        
    
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.String')]

    Param (
 
    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String]$Id,        
        
    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100"
    
    )
    
    Begin {
        # --- Test for vRA API version
        if ($Global:vRAConnection.APIVersion -lt 7){

            throw "$($MyInvocation.MyCommand) is not supported with vRA API version $($Global:vRAConnection.APIVersion)"
        }        
    }    
 
    Process {

        try {

            # --- If the name parameter is passed derive the id from the result
            if ($PSBoundParameters.ContainsKey("Name")){ 

                $URI = "/catalog-service/api/consumer/entitledCatalogItems?limit=$($Limit)"                 
                                    
                $Filter = "name%20eq%20'$($Name)'" 
                
                Write-Verbose -Message "Preparing GET to $($URI)&`$filter=$($Filter)"                              

                $Response = Invoke-vRARestMethod -Method GET -URI "$($URI)&`$filter=$($Filter)"

                Write-Verbose -Message "SUCCESS"

                if ($Response.content.Length -eq 0) {

                    throw "Could not find entitled catalog item with name: $($Name)"

                }
                
                $Id = $Response.content.catalogitem.id
                
                Write-Verbose -Message "Got catalog item id: $($Id)"            

            }
                                
            # --- Build base URI for the request template 
            $URI = "/catalog-service/api/consumer/entitledCatalogItems/$($Id)/requests/template"
            
            Write-Verbose -Message "Preparing GET to $($URI)"                                                               
                            
            # --- Grab the request template and convert to JSON
            $Response = Invoke-vRARestMethod -Method GET -URI $URI
            
            Write-Verbose -Message "Converting request template to JSON"     
                        
            $Response | ConvertTo-Json -Depth 100
                        
                                        
        }
        catch [Exception]{
            
            throw

        }
        
    }           
     
}