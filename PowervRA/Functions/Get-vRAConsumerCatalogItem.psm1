function Get-vRAConsumerCatalogItem {
<#
    .SYNOPSIS
    Get a consumer catalog item that the user is allowed to review.
    
    .DESCRIPTION
    Consumer REST API for Catalog Items. This API does not take entitlements into account but only global user permissions.
    However, if a request is submitted for a catalogitem without the appropriate entitlement it will be rejected.

    .PARAMETER Id
    The id of the catalog item
    
    .PARAMETER Name
    The name of the catalog item

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAConsumerCatalogItem
    
    .EXAMPLE
    Get-vRAConsumerCatalogItem -Limit 9999

    .EXAMPLE
    Get-vRAConsumerCatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e

    .EXAMPLE
    Get-vRAConsumerCatalogItem -Name Centos_Template
    
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

        switch ($PsCmdlet.ParameterSetName) {

            # --- Get catalog item by id
            'ById' {

                foreach ($CatalogItemId in $Id) {
            
                    $URI = "/catalog-service/api/consumer/catalogItems/$($CatalogItemId)"

                    Write-Verbose -Message "Preparing GET to $($URI)"
            
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    Write-Verbose -Message "SUCCESS"
                      
                    [pscustomobject] @{

                        Callbacks = $Response.callbacks
                        CatalogItemTypeRef = $Response.catalogItemTypeRef
                        DateCreated = $Response.dateCreated
                        Description = $Response.description
                        Forms = $Response.forms
                        IconId = $Response.iconId
                        Id = $Response.id
                        IsNoteworthy = $Response.isNoteworthy
                        LastUpdatedDate = $Response.lastUpdatedDate
                        Name = $Response.name
                        Organization = $Response.organization
                        OutputResourceTypeRef = $Response.outputResourceTypeRef
                        ProviderBinding = $Response.providerBinding
                        ServiceRef = $Response.serviceRef
                        Status = $Response.status
                        StatusName = $Response.statusName
                        Quota = $Response.quota
                        Version = $Response.version
                        Requestable = $Response.requestable

                    }
                }

                break
             
            }       
            # --- Get catalog item by name
            'ByName' {
        
                foreach ($CatalogItemName in $Name) { 
            
                    $URI = "/catalog-service/api/consumer/catalogItems?`$filter=name%20eq%20'$($CatalogItemName)'"            
            
                    Write-Verbose -Message "Preparing GET to $($URI)"                

                    $Response = Invoke-vRARestMethod -Method GET -URI "$($URI)"

                    Write-Verbose -Message "SUCCESS"

                    if ($Response.content.Length -eq 0) {

                        throw "Could not find catalog item with name: $($CatalogItemName)"

                    }

                    [pscustomobject] @{

                        Callbacks = $Response.content.callbacks
                        CatalogItemTypeRef = $Response.content.catalogItemTypeRef
                        DateCreated = $Response.content.dateCreated
                        Description = $Response.content.description
                        Forms = $Response.content.forms
                        IconId = $Response.content.iconId
                        Id = $Response.content.id
                        IsNoteworthy = $Response.content.isNoteworthy
                        LastUpdatedDate = $Response.content.lastUpdatedDate
                        Name = $Response.content.name
                        Organization = $Response.content.organization
                        OutputResourceTypeRef = $Response.content.outputResourceTypeRef
                        ProviderBinding = $Response.content.providerBinding
                        ServiceRef = $Response.content.serviceRef
                        Status = $Response.content.status
                        StatusName = $Response.content.statusName
                        Quota = $Response.content.quota
                        Version = $Response.content.version
                        Requestable = $Response.content.requestable

                    }

                }

                break

            }
            # --- No parameters passed so return all catalog items
            'Standard' {
            
                $URI = "/catalog-service/api/consumer/catalogItems?limit=$($Limit)&`$orderby=name%20asc"        
                
                Write-Verbose -Message "Preparing GET to $($URI)"   

                $Response = Invoke-vRARestMethod -Method GET -URI $URI

                Write-Verbose -Message "SUCCESS"

                Write-Verbose -Message "Response contains $($Response.content.Length) records"

                foreach ($CatalogItem in $Response.content) {

                    [pscustomobject] @{

                        Callbacks = $CatalogItem.callbacks
                        CatalogItemTypeRef = $CatalogItem.catalogItemTypeRef
                        DateCreated = $CatalogItem.dateCreated
                        Description = $CatalogItem.description
                        Forms = $CatalogItem.forms
                        IconId = $CatalogItem.iconId
                        Id = $CatalogItem.id
                        IsNoteworthy = $CatalogItem.isNoteworthy
                        LastUpdatedDate = $CatalogItem.lastUpdatedDate
                        Name = $CatalogItem.name
                        Organization = $CatalogItem.organization
                        OutputResourceTypeRef = $CatalogItem.outputResourceTypeRef
                        ProviderBinding = $CatalogItem.providerBinding
                        ServiceRef = $CatalogItem.serviceRef
                        Status = $CatalogItem.status
                        StatusName = $CatalogItem.statusName
                        Quota = $CatalogItem.quota
                        Version = $CatalogItem.version
                        Requestable = $CatalogItem.requestable

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