function Get-vRACatalogItemRequestTemplate {
<#
    .SYNOPSIS
    Get the request template of a catalog item that the user is entitled to see
    
    .DESCRIPTION
    Get the request template of a catalog item that the user is entitled to see and return a JSON payload to reuse in a request
    
    .PARAMETER Id
    The id of the catalog item

    .PARAMETER Name
    The name of the catalog item

    .INPUTS
    System.String

    .OUTPUTS
    System.String

    .EXAMPLE
    Get-vRAConsumerCatalogItemRequestTemplate -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e
    
    .EXAMPLE
    Get-vRAConsumerCatalogItemRequestTemplate -Name Centos_Template
    
    .EXAMPLE
    Get-vRAConsumerEntitledCatalogItem | Get-vRACatalogItemRequestTemplate
    
    .EXAMPLE
    Get-vRAConsumerEntitledCatalogItem -Name Centos_Template | Get-vRACatalogItemRequestTemplate   
 
    .EXAMPLE
    Get-vRAConsumerEntitledCatalogItem -Name Centos_Template | Get-vRACatalogItemRequestTemplate | ConvertFrom-Json        
    
#>
[CmdletBinding(DefaultParameterSetName="ById")][OutputType('System.String')]

    Param (
 
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String]$Id,        
            
        [Parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String]$Name
    
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

                $URI = "/catalog-service/api/consumer/entitledCatalogItems?&`$filter=name eq '$($Name)'"               

                $EscapedURI = [uri]::EscapeUriString($URI)

                $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                if ($Response.content.Count -eq 0) {

                    throw "Could not find entitled catalog item with name: $($Name)"

                }
                
                $Id = $Response.content.catalogitem.id
                
                Write-Verbose -Message "Got catalog item id: $($Id)"            

            }

            # --- Build base URI for the request template 
            $URI = "/catalog-service/api/consumer/entitledCatalogItems/$($Id)/requests/template"

            # --- Grab the request template and convert to JSON
            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
            
            Write-Verbose -Message "Converting request template to JSON"     
                        
            $Response | ConvertTo-Json -Depth 100

        }
        catch [Exception]{

            throw

        }

    }

}