function Get-vRAConsumerResource {
<#
    .SYNOPSIS
    Get a provisioned resource
    
    .DESCRIPTION
    A Resource represents a deployed artifact that has been provisioned by a provider.

    .PARAMETER Id
    The id of the resource
    
    .PARAMETER Name
    The Name of the resource

    .PARAMETER WithExtendedData
    Populate resources' extended data by calling their provider

    .PARAMETER WithOperations
    Populate resources' operations attribute by calling the provider. This will force withExtendedData to true.
        
    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAConsumerResource

    .EXAMPLE
    Get-vRAConsumerResource -WithExtendedData

    .EXAMPLE
    Get-vRAConsumerResource -WithOperations
    
    .EXAMPLE
    Get-vRAConsumerResource -Id "6195fd70-7243-4dc9-b4f3-4b2300e15ef8"
    
    .EXAMPLE
    Get-vRAConsumerResource -Name "vm-01"
    
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$false, ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,
    
    [parameter(Mandatory=$false, ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name, 

    [parameter(Mandatory=$false, ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Switch]$WithExtendedData,
    
    [parameter(Mandatory=$false, ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Switch]$WithOperations,                
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100"
    )
# --- Test for vRA API version
if ($Global:vRAConnection.APIVersion -lt 7){

    throw "$($MyInvocation.MyCommand) is not supported with vRA API version $($Global:vRAConnection.APIVersion)"
}
                
    try {

        switch ($PsCmdlet.ParameterSetName) {

            # --- Get Resource by id
            'ById' {
            
                foreach ($ResourceId in $Id) { 
            
                    $URI = "/catalog-service/api/consumer/resourceViews/$($ResourceId)"

                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    Write-Verbose -Message "SUCCESS"

                    [pscustomobject] @{

                        ResourceId = $Response.resourceId
                        IconId = $Response.iconId
                        Name = $Response.name
                        Description = $Response.description
                        Status = $Response.status
                        CatalogItemId = $Response.catalogItemId
                        CatalogItemLabel = $Response.catalogItemLabel
                        RequestId = $Response.requestId
                        ResourceType = $Response.resourceType
                        Owners = $Response.owners
                        BusinessGroupId = $Response.businessGroupId
                        TenantId = $Response.tenantId
                        DateCreated = $Response.dateCreated
                        LastUpdated = $Response.lastUpdated
                        Lease = $Response.lease
                        Costs = $Response.costs
                        CostToDate = $Response.costToDate
                        TotalCost = $Response.totalCost
                        ParentResourceId = $Response.parentResourceId
                        HasChildren = $Response.hasChildren
                        Data = $Response.data
                        Links = $Response.links
                        
                    }

                }

                break
            }        
            # --- Get Resource by name
            'ByName' {

                foreach ($ResourceName in $Name) {
            
                    $URI = "/catalog-service/api/consumer/resourceViews?`$filter=name%20eq%20'$($ResourceName)'&withExtendedData=true&withOperations=true"

                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    Write-Verbose -Message "SUCCESS"
            
                    if ($Response.content.Length -eq 0) {

                        throw "Could not find resource item with name: $($ResourceName)"

                    }        
            
                    [pscustomobject] @{

                        ResourceId = $Response.content.resourceId
                        IconId = $Response.content.iconId
                        Name = $Response.content.name
                        Description = $Response.content.description
                        Status = $Response.content.status
                        CatalogItemId = $Response.content.catalogItemId
                        CatalogItemLabel = $Response.content.catalogItemLabel
                        RequestId = $Response.content.requestId
                        ResourceType = $Response.content.resourceType
                        Owners = $Response.content.owners
                        BusinessGroupId = $Response.content.businessGroupId
                        TenantId = $Response.content.tenantId
                        DateCreated = $Response.content.dateCreated
                        LastUpdated = $Response.content.lastUpdated
                        Lease = $Response.content.lease
                        Costs = $Response.content.costs
                        CostToDate = $Response.content.costToDate
                        TotalCost = $Response.content.totalCost
                        ParentResourceId = $Response.content.parentResourceId
                        HasChildren = $Response.content.hasChildren
                        Data = $Response.content.data
                        Links = $Response.content.links
                        
                    }
                    
                }
                
                break                                
            
            }        
            # --- No parameters passed so return all resources
            'Standard' {                

            
                $URI = "/catalog-service/api/consumer/resourceViews?limit=$($Limit)&`$orderby=name%20asc"

                if ($PSBoundParameters.ContainsKey('WithExtendedData')){

                    $URI = $URI + "&withExtendedData=true"

                    Write-Verbose -Message "WithExtendedData switch passed. New request uri is: $($URI)"

                }

                if ($PSBoundParameters.ContainsKey('WithOperations')){

                    $URI = $URI + "&withOperations=true"

                    Write-Verbose -Message "WithOperations switch passed. New request uri is: $($URI)"

                }


                Write-Verbose -Message "Preparing GET to $($URI)"

                $Response = Invoke-vRARestMethod -Method GET -URI $URI

                Write-Verbose -Message "SUCCESS"

                Write-Verbose -Message "Response contains $($Response.content.Length) records"

                foreach ($Resource in $Response.content) {

                      [pscustomobject] @{

                        ResourceId = $Resource.resourceId
                        IconId = $Resource.iconId
                        Name = $Resource.name
                        Description = $Resource.description
                        Status = $Resource.status
                        CatalogItemId = $Resource.catalogItemId
                        CatalogItemLabel = $Resource.catalogItemLabel
                        RequestId = $Resource.requestId
                        ResourceType = $Resource.resourceType
                        Owners = $Resource.owners
                        BusinessGroupId = $Resource.businessGroupId
                        TenantId = $Resource.tenantId
                        DateCreated = $Resource.dateCreated
                        LastUpdated = $Resource.lastUpdated
                        Lease = $Resource.lease
                        Costs = $Resource.costs
                        CostToDate = $Resource.costToDate
                        TotalCost = $Resource.totalCost
                        ParentResourceId = $Resource.parentResourceId
                        HasChildren = $Resource.hasChildren
                        Data = $Resource.data
                        Links = $Resource.links
                        
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