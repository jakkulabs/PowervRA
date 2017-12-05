function Get-vRAEntitlement {
<#
    .SYNOPSIS
    Retrieve vRA entitlements
    
    .DESCRIPTION
    Retrieve vRA entitlement either by id or name. Passing no parameters will return all entitlements
    
    .PARAMETER Id
    The id of the entitlement
    
    .PARAMETER Name
    The Name of the entitlement

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .PARAMETER Page
    The index of the page to display.

    .INPUTS
    System.String
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAEntitlement
    
    .EXAMPLE
    Get-vRAEntitlement -Id 332d38d5-c8db-4519-87a7-7ef9f358091a
    
    .EXAMPLE
    Get-vRAEntitlement -Name "Default Entitlement"
    
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,
        
        [Parameter(Mandatory=$true, ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100

    )

    Begin {

    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Entitlement by id
                'ById'{
            
                    foreach ($EntitlementId in $Id ) { 
                
                        $URI = "/catalog-service/api/entitlements/$($EntitlementId)"

                        $Entitlement = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        [PSCustomObject] @{

                            Id = $Entitlement.id
                            Name = $Entitlement.name
                            Description = $Entitlement.description
                            Status = $Entitlement.status
                            EntitledCatalogItems = $Entitlement.entitledCatalogItems
                            EntitledResourceOperations = $Entitlement.entitledResourceOperations
                            EntitledServices = $Entitlement.entitledServices
                            ExpiryDate = $Entitlement.expiryDate
                            LastUpdatedBy = $Entitlement.lastUpdatedBy
                            LastUpdatedDate = $Entitlement.lastUpdatedDate
                            Organization = $Entitlement.organization
                            Principals = $Entitlement.principals
                            PriorityOrder = $Entitlement.priorityOrder
                            StatusName = $Entitlement.statusName
                            LocalScopeForActions = $Entitlement.localScopeForActions
                            Version = $Entitlement.version

                        }

                    }

                    break

                }

                # --- Get entitlement by name
                'ByName' {

                    foreach ($EntitlementName in $Name) {

                        $URI = "/catalog-service/api/entitlements?`$filter=name eq '$($Name)'"

                        $EscapedURI = [uri]::EscapeUriString($URI)

                        $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                        if ($Response.content.Count -eq 0) {

                            throw "Could not find entitlement item with name: $($Name)"

                        }

                        $Entitlement = $Response.Content

                        [PSCustomObject] @{

                            Id = $Entitlement.id
                            Name = $Entitlement.name
                            Description = $Entitlement.description
                            Status = $Entitlement.status
                            EntitledCatalogItems = $Entitlement.entitledCatalogItems
                            EntitledResourceOperations = $Entitlement.entitledResourceOperations
                            EntitledServices = $Entitlement.entitledServices
                            ExpiryDate = $Entitlement.expiryDate
                            LastUpdatedBy = $Entitlement.lastUpdatedBy
                            LastUpdatedDate = $Entitlement.lastUpdatedDate
                            Organization = $Entitlement.organization
                            Principals = $Entitlement.principals
                            PriorityOrder = $Entitlement.priorityOrder
                            StatusName = $Entitlement.statusName
                            LocalScopeForActions = $Entitlement.localScopeForActions
                            Version = $Entitlement.version

                        }

                    }

                    break

                }

                # --- No parameters passed so return all entitlements
                'Standard' {

                    $URI = "/catalog-service/api/entitlements?limit=$($Limit)&page=$($Page)&`$orderby=name asc"

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                    foreach ($Entitlement in $Response.content) {

                        [PSCustomObject] @{

                            Id = $Entitlement.id
                            Name = $Entitlement.name
                            Description = $Entitlement.description
                            Status = $Entitlement.status
                            EntitledCatalogItems = $Entitlement.entitledCatalogItems
                            EntitledResourceOperations = $Entitlement.entitledResourceOperations
                            EntitledServices = $Entitlement.entitledServices
                            ExpiryDate = $Entitlement.expiryDate
                            LastUpdatedBy = $Entitlement.lastUpdatedBy
                            LastUpdatedDate = $Entitlement.lastUpdatedDate
                            Organization = $Entitlement.organization
                            Principals = $Entitlement.principals
                            PriorityOrder = $Entitlement.priorityOrder
                            StatusName = $Entitlement.statusName
                            LocalScopeForActions = $Entitlement.localScopeForActions
                            Version = $Entitlement.version

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