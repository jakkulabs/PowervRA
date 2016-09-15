function Get-vRAConsumerEntitledCatalogItem {
<#
    .SYNOPSIS
    Get the a catalog item that the user is entitled to see
    
    .DESCRIPTION
    Consumer API for entitled catalog items exposed for users. Consumer Entitled CatalogItem(s) are basically catalog items:
    - In an active state.
    - The current user has the right to consume.
    - The current user is entitled to consume.
    - Associated to a service.
    
    .PARAMETER Name
    The name of the catalog item

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAConsumerEntitledCatalogItem
    
    .EXAMPLE
    Get-vRAConsumerEntitledCatalogItem -Limit 9999
    
    .EXAMPLE
    Get-vRAConsumerEntitledCatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e    

    .EXAMPLE
    Get-vRAConsumerEntitledCatalogItem -Name Centos_Template
    
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (
        
    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ByID")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,         

    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name, 
    
    [parameter(Mandatory=$false,ValueFromPipeline=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100" 
    
    )
    
    Write-Warning -Message "This command is deprecated and will be removed in a future release. Please use Get-vRAEntitledCatalogItem instead."

    try {

        switch ($PsCmdlet.ParameterSetName) {

            # --- Get catalog item by id
            'ById' {
            
                foreach ($EntitledCatalogItemId in $Id) {

                    $URI = "/catalog-service/api/consumer/entitledCatalogItems/$($EntitledCatalogItemId)"

                    Write-Verbose -Message "Preparing GET to $($URI)"    
                
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    Write-Verbose -Message "SUCCESS"
                      
                    [pscustomobject] @{

                        Id = $Response.catalogItem.id
                        Name = $Response.catalogItem.name
                        Description = $Response.catalogItem.description
                        Status = $Response.catalogItem.status
                        IsNoteworthy = $Response.catalogItem.isNoteworthy
                        DateCreated = $Response.catalogItem.dateCreated
                        LastUpdatedDate = $Response.catalogItem.lastUpdatedDate
                        Organization = $Response.catalogItem.organization
                        OutputResourceTypeRef = $Response.catalogItem.outputResourceTypeRef
                        ProviderBinding = $Response.catalogItem.providerBinding
                        ServiceRef = $Response.catalogItem.serviceRef
                        Quota = $Response.catalogItemquota
                        Version = $Response.catalogItem.version
                        Requestable = $Response.catalogItem.requestable
                        Callbacks = $Response.catalogItem.callbacks
                        CatalogItemTypeRef = $Response.catalogItem.catalogitemTypeRef
                        Forms = $Response.catalogItem.forms
                        IconId = $Response.catalogItem.iconId
                        EntitledOrganizations = $Response.entitledOrganizations 
               
                    }
                }

                break
                             
            }       
            # --- Get catalog item by name
            'ByName' {
        
                foreach ($EntitledCatalogItemName in $Name) { 
            
                    $URI = "/catalog-service/api/consumer/entitledCatalogItems?`$filter=name%20eq%20'$($EntitledCatalogItemName)'"            
            
                    Write-Verbose -Message "Preparing GET to $($URI)"                

                    $Response = Invoke-vRARestMethod -Method GET -URI "$($URI)"

                    Write-Verbose -Message "SUCCESS"

                    if ($Response.content.Length -eq 0) {

                        throw "Could not find catalog item with name: $($EntitledCatalogItemName)"

                    }

                    [pscustomobject] @{

                        Id = $Response.content.catalogItem.id
                        Name = $Response.content.catalogItem.name
                        Description = $Response.content.catalogItem.description
                        Status = $Response.content.catalogItem.status
                        IsNoteworthy = $Response.content.catalogItem.isNoteworthy
                        DateCreated = $Response.content.catalogItem.dateCreated
                        LastUpdatedDate = $Response.content.catalogItem.lastUpdatedDate
                        Organization = $Response.content.catalogItem.organization
                        OutputResourceTypeRef = $Response.content.catalogItem.outputResourceTypeRef
                        ProviderBinding = $Response.content.catalogItem.providerBinding
                        ServiceRef = $Response.content.catalogItem.serviceRef
                        Quota = $Response.content.catalogItem.quota
                        Version = $Response.content.catalogItem.version
                        Requestable = $Response.content.catalogItem.requestable
                        Callbacks = $Response.content.catalogItem.callbacks
                        CatalogItemTypeRef = $Response.content.catalogItem.catalogitemTypeRef
                        Forms = $Response.content.catalogItem.forms
                        IconId = $Response.content.catalogItem.iconId
                        EntitledOrganizations = $Response.content.entitledOrganizations               
                    }
                }

                break

            }
            # --- No parameters passed so return all catalog items
            'Standard' {
            
                $URI = "/catalog-service/api/consumer/entitledCatalogItems?limit=$($Limit)"        
                
                Write-Verbose -Message "Preparing GET to $($URI)"   

                $Response = Invoke-vRARestMethod -Method GET -URI $URI

                Write-Verbose -Message "SUCCESS"

                Write-Verbose -Message "Response contains $($Response.content.Length) records"

                foreach ($CatalogItem in $Response.content) {

                    [pscustomobject] @{

                        Id = $CatalogItem.catalogItem.id
                        Name = $CatalogItem.catalogItem.name
                        Description = $CatalogItem.catalogItem.description
                        Status = $CatalogItem.catalogItem.status
                        IsNoteworthy = $CatalogItem.catalogItem.isNoteworthy
                        DateCreated = $CatalogItem.catalogItem.dateCreated
                        LastUpdatedDate = $CatalogItem.catalogItem.lastUpdatedDate
                        Organization = $CatalogItem.catalogItem.organization
                        OutputResourceTypeRef = $CatalogItem.catalogItem.outputResourceTypeRef
                        ProviderBinding = $CatalogItem.catalogItem.providerBinding
                        ServiceRef = $CatalogItem.catalogItem.serviceRef
                        Quota = $CatalogItem.catalogItem.quota
                        Version = $CatalogItem.catalogItem.version
                        Requestable = $CatalogItem.catalogItem.requestable
                        Callbacks = $CatalogItem.catalogItem.callbacks
                        CatalogItemTypeRef = $CatalogItem.catalogItem.catalogitemTypeRef
                        Forms = $CatalogItem.catalogItem.forms
                        IconId = $CatalogItem.catalogItem.iconId
                        EntitledOrganizations = $CatalogItem.entitledOrganizations
                
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