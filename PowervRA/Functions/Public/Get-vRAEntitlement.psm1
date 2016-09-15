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

    .INPUTS
    System.String

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

    [parameter(Mandatory=$false, ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,
    
    [parameter(Mandatory=$false, ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name,         
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100"
    )
                
    try {

        switch ($PsCmdlet.ParameterSetName) {

            # --- Get Entitlement by id
            'ById'{
        
                foreach ($EntitlementId in $Id ) { 
            
                    $URI = "/catalog-service/api/entitlements/$($Id)"

                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    Write-Verbose -Message "SUCCESS"

                    [pscustomobject] @{

                        Description = $Response.description
                        EntitledCatalogItems = $Response.entitledCatalogItems
                        EntitledResourceOperations = $Response.entitledResourceOperations
                        EntitledServices = $Response.entitledServices
                        ExpiryDate = $Response.expiryDate
                        Id = $Response.id
                        LastUpdatedBy = $Response.lastUpdatedBy
                        LastUpdatedDate = $Response.lastUpdatedDate
                        Name = $Response.name
                        Organization = $Response.organization
                        Principals = $Response.principals
                        PriorityOrder = $Response.priorityOrder
                        Status = $Response.status
                        StatusName = $Response.statusName
                        LocalScopeForActions = $Response.localScopeForActions
                        Version = $Response.version
                    }

                }

                break

            }
                
            # --- Get entitlement by name
            'ByName' {

                foreach ($EntitlementName in $Name) {
            
                    $URI = "/catalog-service/api/entitlements?`$filter=name%20eq%20'$($Name)'"

                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    Write-Verbose -Message "SUCCESS"

                    Write-Verbose -Message "Response contains $($Response.content.Length) records"
            
                    if ($Response.content.Length -eq 0) {

                        throw "Could not find entitlement item with name: $($Name)"

                    }        
            
                    [pscustomobject] @{

                        Description = $Response.content.description
                        EntitledCatalogItems = $Response.content.entitledCatalogItems
                        EntitledResourceOperations = $Response.content.entitledResourceOperations
                        EntitledServices = $Response.content.entitledServices
                        ExpiryDate = $Response.content.expiryDate
                        Id = $Response.content.id
                        LastUpdatedBy = $Response.content.lastUpdatedBy
                        LastUpdatedDate = $Response.content.lastUpdatedDate
                        Name = $Response.content.name
                        Organization = $Response.content.organization
                        Principals = $Response.content.principals
                        PriorityOrder = $Response.content.priorityOrder
                        Status = $Response.content.status
                        StatusName = $Response.content.statusName
                        LocalScopeForActions = $Response.content.localScopeForActions
                        Version = $Response.content.version
                    }             
                }

                break

            }
                
            # --- No parameters passed so return all entitlements
            'Standard' {
            
                $URI = "/catalog-service/api/entitlements?limit=$($Limit)&`$orderby=name%20asc"

                Write-Verbose -Message "Preparing GET to $($URI)"

                $Response = Invoke-vRARestMethod -Method GET -URI $URI

                Write-Verbose -Message "SUCCESS"

                foreach ($Entitlement in $Response.content) {

                    [pscustomobject] @{

                        Description = $Entitlement.description
                        EntitledCatalogItems = $Entitlement.entitledCatalogItems
                        EntitledResourceOperations = $Entitlement.entitledResourceOperations
                        EntitledServices = $Entitlement.entitledServices
                        ExpiryDate = $Entitlement.expiryDate
                        Id = $Entitlement.id
                        LastUpdatedBy = $Entitlement.lastUpdatedBy
                        LastUpdatedDate = $Entitlement.lastUpdatedDate
                        Name = $Entitlement.name
                        Organization = $Entitlement.organization
                        Principals = $Entitlement.principals
                        PriorityOrder = $Entitlement.priorityOrder
                        Status = $Entitlement.status
                        StatusName = $Entitlement.statusName
                        LocalScopeForActions = $Entitlement.localScopeForActions
                        Version = $Entitlement.version
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