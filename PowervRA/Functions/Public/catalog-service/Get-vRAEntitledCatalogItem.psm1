function Get-vRAEntitledCatalogItem {
<#
    .SYNOPSIS
    Get a catalog item that the user is entitled to see
    
    .DESCRIPTION
    Get catalog items that are entitled to. Consumer Entitled CatalogItem(s) are basically catalog items:
    - in an active state.
    - the current user has the right to consume.
    - the current user is entitled to consume.
    - associated to a service.
    
    .PARAMETER Name
    The name of the catalog item

    .PARAMETER Service
    Return catalog items in a specific service

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100

    .PARAMETER Page
    The index of the page to display

    .INPUTS
    System.String
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAEntitledCatalogItem
    
    .EXAMPLE
    Get-vRAEntitledCatalogItem -Limit 9999

    .EXAMPLE 
    Get-vRAEntitledCatalogItem -Service "Default Service"

    .EXAMPLE
    Get-vRAEntitledCatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e    

    .EXAMPLE
    Get-vRAEntitledCatalogItem -Name Centos_Template

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true,ParameterSetName="ByID")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name, 

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Service, 

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100 

    )

    Begin {

    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get catalog item by id
                'ById' {

                    foreach ($EntitledCatalogItemId in $Id) {

                        $URI = "/catalog-service/api/consumer/entitledCatalogItems/$($EntitledCatalogItemId)"

                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        $CatalogItem = $Response.catalogItem

                        [PSCustomObject] @{

                            Id = $CatalogItem.id
                            Name = $CatalogItem.name
                            Description = $CatalogItem.description
                            Service = $CatalogItem.serviceRef.label
                            Status = $CatalogItem.status
                            Quota = $CatalogItemquota
                            Version = $CatalogItem.version
                            DateCreated = $CatalogItem.dateCreated
                            LastUpdatedDate = $CatalogItem.lastUpdatedDate
                            Requestable = $CatalogItem.requestable
                            IsNoteworthy = $CatalogItem.isNoteworthy
                            Organization = $CatalogItem.organization
                            CatalogItemType = $CatalogItem.catalogitemTypeRef.label
                            OutputResourceType = $CatalogItem.outputResourceTypeRef.label
                            Callbacks = $CatalogItem.callbacks                        
                            Forms = $CatalogItem.forms
                            IconId = $CatalogItem.iconId
                            ProviderBinding = $CatalogItem.providerBinding
                            EntitledOrganizations = $Response.entitledOrganizations 

                        }

                    }

                    break

                }
                # --- Get catalog item by name
                'ByName' {

                    foreach ($EntitledCatalogItemName in $Name) { 

                        $URI = "/catalog-service/api/consumer/entitledCatalogItems?`$filter=name eq '$($EntitledCatalogItemName)'"            

                        $EscapedURI = [uri]::EscapeUriString($URI)

                        $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                        if ($Response.content.Count -eq 0) {

                            throw "Could not find catalog item with name: $($EntitledCatalogItemName)"

                        }

                        $CatalogItem = $Response.content.catalogItem

                        [PSCustomObject] @{

                            Id = $CatalogItem.id
                            Name = $CatalogItem.name
                            Description = $CatalogItem.description
                            Service = $CatalogItem.serviceRef.label
                            Status = $CatalogItem.status
                            Quota = $CatalogItemquota
                            Version = $CatalogItem.version
                            DateCreated = $CatalogItem.dateCreated
                            LastUpdatedDate = $CatalogItem.lastUpdatedDate
                            Requestable = $CatalogItem.requestable
                            IsNoteworthy = $CatalogItem.isNoteworthy
                            Organization = $CatalogItem.organization
                            CatalogItemType = $CatalogItem.catalogitemTypeRef.label
                            OutputResourceType = $CatalogItem.outputResourceTypeRef.label
                            Callbacks = $CatalogItem.callbacks                        
                            Forms = $CatalogItem.forms
                            IconId = $CatalogItem.iconId
                            ProviderBinding = $CatalogItem.providerBinding
                            EntitledOrganizations = $Response.content.entitledOrganizations

                        }

                    }

                    break

                }
                # --- No parameters passed so return all catalog items
                'Standard' {

                    $URI = "/catalog-service/api/consumer/entitledCatalogItems?limit=$($Limit)&`page=$($Page)&`$orderby=name asc"

                    if ($PSBoundParameters.ContainsKey("Service")) {

                        $ServiceId = (Get-vRAService -Name $Service).Id

                        $URI = "$($URI)&serviceId=$($ServiceId)"

                    }

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                    foreach ($Item in $Response.content) {

                        $CatalogItem = $Item.catalogItem

                        [PSCustomObject] @{

                            Id = $CatalogItem.id
                            Name = $CatalogItem.name
                            Description = $CatalogItem.description
                            Service = $CatalogItem.serviceRef.label
                            Status = $CatalogItem.status
                            Quota = $CatalogItemquota
                            Version = $CatalogItem.version
                            DateCreated = $CatalogItem.dateCreated
                            LastUpdatedDate = $CatalogItem.lastUpdatedDate
                            Requestable = $CatalogItem.requestable
                            IsNoteworthy = $CatalogItem.isNoteworthy
                            Organization = $CatalogItem.organization
                            CatalogItemType = $CatalogItem.catalogitemTypeRef.label
                            OutputResourceType = $CatalogItem.outputResourceTypeRef.label
                            Callbacks = $CatalogItem.callbacks                        
                            Forms = $CatalogItem.forms
                            IconId = $CatalogItem.iconId
                            ProviderBinding = $CatalogItem.providerBinding
                            EntitledOrganizations = $CatalogItem.entitledOrganizations

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
    
    End {

    }
    
}