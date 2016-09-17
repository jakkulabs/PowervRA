function Get-vRAResource {
<#
    .SYNOPSIS
    Get a deployed resource
    
    .DESCRIPTION
    A deployment represents a collection of deployed artifacts that have been provisioned by a provider.

    .PARAMETER Id
    The id of the resource
    
    .PARAMETER Name
    The Name of the resource

    .PARAMETER WithExtendedData
    Populate the resources extended data by calling their provider

    .PARAMETER WithOperations
    Populate the resources operations attribute by calling the provider. This will force withExtendedData to true.

    .PARAMETER ManagedOnly
    Show resources owned by the users managed business groups, excluding any machines owned by the user in a non-managed
    business group
        
    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100

    .PARAMETER Page
    The index of the page to display

    .INPUTS
    System.String
    System.Int
    Switch

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAResource

    .EXAMPLE
    Get-vRADeployment -WithExtendedData

    .EXAMPLE
    Get-vRADeployment -WithOperations
    
    .EXAMPLE
    Get-vRADeployment -Id "6195fd70-7243-4dc9-b4f3-4b2300e15ef8"

    .EXAMPLE
    Get-vRADeployment -Name "CENTOS-555667"

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,
        
        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateSet("Deployment","Machine")]
        [String]$Type,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Switch]$WithExtendedData,
        
        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Switch]$WithOperations,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Switch]$ManagedOnly, 
        
        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1

    )

    Begin {

        # --- Test for vRA API version
        xRequires -Version 7 -Context $MyInvocation

    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Resource by id
                'ById' {
                
                    foreach ($ResourceId in $Id) { 
                
                        $URI = "/catalog-service/api/consumer/resourceViews/$($ResourceId)?withExtendedData=true&withOperations=true"

                        $EscapedURI = [uri]::EscapeUriString($URI)

                        $Resource = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                        [PSCustomObject] @{

                            ResourceId = $Resource.resourceId
                            Name = $Resource.name
                            Description = $Resource.description
                            Status = $Resource.status
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
                            IconId = $Resource.iconId
                            
                        }

                    }

                    break

                }        
                # --- Get Resource by name
                'ByName' {

                    foreach ($ResourceName in $Name) {
                
                        $URI = "/catalog-service/api/consumer/resourceViews?`$filter=name eq '$($ResourceName)'&withExtendedData=true&withOperations=true"

                        $EscapedURI = [uri]::EscapeUriString($URI)

                        $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                        if ($Response.content.Count -eq 0) {

                            throw "Could not find resource item with name: $($ResourceName)"

                        }

                        $Resource = $Response.content

                        [PSCustomObject] @{

                            ResourceId = $Resource.resourceId
                            Name = $Resource.name
                            Description = $Resource.description
                            Status = $Resource.status
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
                            IconId = $Resource.iconId
                            
                        }
                        
                    }
                    
                    break
                
                }
                # --- No parameters passed so return all resources
                'Standard' {

                    # --- Set the default URI with no filtering to return all resource types
                    $URI = "/catalog-service/api/consumer/resourceViews/?withExtendedData=$($WithExtendedData)&withOperations=$($WithOperations)&managedOnly=$($ManagedOnly)&`$orderby=name asc&limit=$($Limit)&page=$($page)"

                    # --- If type is passed set the filter
                    if ($PSBoundParameters.ContainsKey("Type")){

                        switch ($Type) {

                            'Deployment' {

                                $Filter = "resourceType/id eq 'composition.resource.type.deployment'"
                                $URI = "$($URI)&`$filter=$($filter)"

                                break

                            }

                            'Machine' {

                                $Filter = "resourceType/id eq 'Infrastructure.Machine' or `
                                resourceType/id eq 'Infrastructure.Virtual' or `
                                resourceType/id eq 'Infrastructure.Cloud' or `
                                resourceType/id eq 'Infrastructure.Physical'"

                                $URI = "$($URI)&`$filter=$($filter)"

                                break

                            }

                        }

                        Write-Verbose -Message "Type $($Type) selected"

                    }

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                    foreach ($Resource in $Response.content) {

                        [PSCustomObject] @{

                            ResourceId = $Resource.resourceId
                            Name = $Resource.name
                            Description = $Resource.description
                            Status = $Resource.status
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
                            IconId = $Resource.iconId

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