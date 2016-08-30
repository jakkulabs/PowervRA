function Get-vRACatalogItem {
<#
    .SYNOPSIS
    Get a catalog item that the user is allowed to review.
    
    .DESCRIPTION
    API for catalog items that a system administrator can interact with. It allows the user to interact 
    with catalog items that the user is permitted to review, even if they were not published or entitled to them.

    .PARAMETER Id
    The id of the catalog item
    
    .PARAMETER Name
    The name of the catalog item

    .PARAMETER ListAvailable
    Show catalog items that are not assigned to a service

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100

    .PARAMETER Page
    The index of the page to display.

    .INPUTS
    System.String
    System.Int
    Switch

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRACatalogItem
    
    .EXAMPLE
    Get-vRACatalogItem -Limit 9999

    .EXAMPLE
    Get-vRACatalogItem -ListAvailable

    .EXAMPLE
    Get-vRACatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e

    .EXAMPLE
    Get-vRACatalogItem -Name Centos_Template
    
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (
    
        [Parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,         

        [Parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [Parameter(Mandatory=$false,ValueFromPipeline=$false,ParameterSetName="Standard")]
        [Switch]$ListAvailable, 

        [Parameter(Mandatory=$false,ValueFromPipeline=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1,

        [Parameter(Mandatory=$false,ValueFromPipeline=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100

    )      

    try {

        switch ($PsCmdlet.ParameterSetName) {

            # --- Get catalog item by id
            'ById' {

                foreach ($CatalogItemId in $Id) {
            
                    $URI = "/catalog-service/api/catalogItems/$($CatalogItemId)"

                    $EncodedURI = [uri]::EscapeUriString($URI)

                    $CatalogItem = Invoke-vRARestMethod -Method GET -URI $EncodedURI -Verbose:$VerbosePreference

                    [PSCustomObject] @{

                        Id = $CatalogItem.id
                        Name = $CatalogItem.name
                        Description = $CatalogItem.description
                        Service = $CatalogItem.serviceRef.label
                        Status = $CatalogItem.status
                        Quota = $CatalogItem.quota
                        Version = $CatalogItem.version
                        DateCreated = $CatalogItem.dateCreated
                        LastUpdatedDate = $CatalogItem.lastUpdatedDate                        
                        Requestable = $CatalogItem.requestable
                        IsNoteworthy = $CatalogItem.isNoteworthy
                        Organization = $CatalogItem.organization
                        CatalogItemType = $CatalogItem.catalogItemTypeRef.label                                            
                        OutputResourceType = $CatalogItem.outputResourceTypeRef.label
                        Callbacks = $CatalogItem.callbacks
                        Forms = $CatalogItem.forms
                        IconId = $CatalogItem.iconId
                        ProviderBinding = $CatalogItem.providerBinding

                    }

                }

                break
             
            }       
            # --- Get catalog item by name
            'ByName' {

                foreach ($CatalogItemName in $Name) { 

                    $URI = "/catalog-service/api/catalogItems?`$filter=name eq '$($CatalogItemName)'"            

                    $EncodedURI = [uri]::EscapeUriString($URI)

                    $Response = Invoke-vRARestMethod -Method GET -URI $EncodedURI -Verbose:$VerbosePreference

                    if ($Response.content.Count -eq 0) {

                        throw "Could not find catalog item with name: $($CatalogItemName)"

                    }

                    $CatalogItem = $Response.content

                    [PSCustomObject] @{

                        Id = $CatalogItem.id
                        Name = $CatalogItem.name
                        Description = $CatalogItem.description
                        Service = $CatalogItem.serviceRef.label
                        Status = $CatalogItem.status
                        Quota = $CatalogItem.quota
                        Version = $CatalogItem.version
                        DateCreated = $CatalogItem.dateCreated
                        LastUpdatedDate = $CatalogItem.lastUpdatedDate                        
                        Requestable = $CatalogItem.requestable
                        IsNoteworthy = $CatalogItem.isNoteworthy
                        Organization = $CatalogItem.organization
                        CatalogItemType = $CatalogItem.catalogItemTypeRef.label                                            
                        OutputResourceType = $CatalogItem.outputResourceTypeRef.label
                        Callbacks = $CatalogItem.callbacks
                        Forms = $CatalogItem.forms
                        IconId = $CatalogItem.iconId
                        ProviderBinding = $CatalogItem.providerBinding

                    }

                }

                break

            }
            # --- No parameters passed so return all catalog items
            'Standard' {

                $URI = "/catalog-service/api/catalogItems?limit=$($Limit)&page=$($Page)&`$orderby=name asc"

                if ($PSBoundParameters.ContainsKey("ListAvailable")) {

                    $URI = "/catalog-service/api/catalogItems/available?limit=$($Limit)&page=$($Page)&`$orderby=name asc"

                }

                $EncodedURI = [uri]::EscapeUriString($URI)

                $Response = Invoke-vRARestMethod -Method GET -URI $EncodedURI -Verbose:$VerbosePreference

                foreach ($CatalogItem in $Response.content) {

                    [PSCustomObject] @{

                        Id = $CatalogItem.id
                        Name = $CatalogItem.name
                        Description = $CatalogItem.description
                        Service = $CatalogItem.serviceRef.label
                        Status = $CatalogItem.status
                        Quota = $CatalogItem.quota
                        Version = $CatalogItem.version
                        DateCreated = $CatalogItem.dateCreated
                        LastUpdatedDate = $CatalogItem.lastUpdatedDate                        
                        Requestable = $CatalogItem.requestable
                        IsNoteworthy = $CatalogItem.isNoteworthy
                        Organization = $CatalogItem.organization
                        CatalogItemType = $CatalogItem.catalogItemTypeRef.label                                            
                        OutputResourceType = $CatalogItem.outputResourceTypeRef.label
                        Callbacks = $CatalogItem.callbacks
                        Forms = $CatalogItem.forms
                        IconId = $CatalogItem.iconId
                        ProviderBinding = $CatalogItem.providerBinding

                    }

                }

                Write-Verbose -Message "Total: $($Response.metadata.totalElements) | Page: $($Response.metadata.number) of $($Response.metadata.totalPages) | Size: $($Response.metadata.size)"

                break

            }

        }

    }
    catch [Exception]{

        throw

     }

}