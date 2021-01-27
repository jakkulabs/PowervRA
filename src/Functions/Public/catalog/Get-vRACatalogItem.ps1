function Get-vRACatalogItem {
    <#
        .SYNOPSIS
        Get a vRA Catalog Item
    
        .DESCRIPTION
        Get a vRA Catalog Item
    
        .PARAMETER Id
        The ID of the Catalog Item
    
        .PARAMETER Name
        The Name of the Catalog Item
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRACatalogItem
    
        .EXAMPLE
        Get-vRACatalogItem -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRACatalogItem -Name 'TestCatalogItem'
    
    #>
    [CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]
    
        Param (
    
            [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
            [ValidateNotNullOrEmpty()]
            [String[]]$Id,
    
            [Parameter(Mandatory=$true,ParameterSetName="ByName")]
            [ValidateNotNullOrEmpty()]
            [String[]]$Name
        )
    
        begin {
            $APIUrl = '/catalog/api/items'
    
            function CalculateOutput([PSCustomObject]$CatalogItem) {
    
                [PSCustomObject] @{
                    Id = $CatalogItem.id
                    Name = $CatalogItem.name
                    Description = $CatalogItem.description
                    Type = $CatalogItem.type
                    ProjectIds = $CatalogItem.projectIds
                    CreatedAt = $CatalogItem.createdAt
                    CreatedBy = $CatalogItem.createdBy
                    LastUpdatedAt = $CatalogItem.lastUpdatedAt
                    LastUpdatedBy = $CatalogItem.lastUpdatedBy
                    IconId = $CatalogItem.iconId
                    BulkRequestLimit = $CatalogItem.bulkRequestLimit
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Catalog Item by Id
                    'ById' {
    
                        foreach ($CatalogItemId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($CatalogItemId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($CatalogItem in $Response.content) {
    
                                CalculateOutput $CatalogItem
                            }
                        }
    
                        break
                    }
                    # --- Get Catalog Item by Name
                    'ByName' {
    
                        foreach ($CatalogItemName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($CatalogItemName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($CatalogItem in $Response.content){
    
                                CalculateOutput $CatalogItem
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Catalog Items
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                        foreach ($CatalogItem in $Response.content){
    
                            CalculateOutput $CatalogItem
                        }
                    }
                }
            }
            catch [Exception]{
    
                throw
            }
        }
    
        end {
    
        }
    }
    