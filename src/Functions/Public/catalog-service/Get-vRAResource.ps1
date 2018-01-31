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

    .PARAMETER Type
    Show resources that match a certain type.

    Supported types ar:

        Deployment,
        Machine

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
    Get-vRAResource -WithExtendedData

    .EXAMPLE
    Get-vRAResource -WithOperations
    
    .EXAMPLE
    Get-vRAResource -Id "6195fd70-7243-4dc9-b4f3-4b2300e15ef8"

    .EXAMPLE
    Get-vRAResource -Name "CENTOS-555667"

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
        xRequires -Version 7.0

    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Resource by id
                'ById' {
                
                    foreach ($ResourceId in $Id) { 
                
                        $URI = "/catalog-service/api/consumer/resourceViews?`$filter=id eq '$($ResourceId)'&withExtendedData=true&withOperations=true"

                        $EscapedURI = [uri]::EscapeUriString($URI)

                        $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                        if ($Response.content.Count -ne 0) {
                            intNewvRAObjectResource $Response.content
                        }
                        else {
                            Write-Verbose -Message "Could not find resource item with id: $($ResourceId)"
                        }

                    }

                    break

                }        
                # --- Get Resource by name
                'ByName' {

                    foreach ($ResourceName in $Name) {
                
                        $URI = "/catalog-service/api/consumer/resourceViews?`$filter=tolower(name) eq '$($ResourceName.ToLower())'&withExtendedData=true&withOperations=true"

                        $EscapedURI = [uri]::EscapeUriString($URI)

                        $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                        if ($Response.content.Count -ne 0) {
                            intNewvRAObjectResource $Response.content
                        }
                        else {
                            Write-Verbose -Message "Could not find resource item with name: $($ResourceName)"
                        }
                        
                    }
                    
                    break
                
                }
                # --- No parameters passed so return all resources
                'Standard' {

                    # vRA REST query is limited to only 100 items per page when extended data is requested. So the script must parse all pages returned
                    $nbPage = 1
                    $TotalPages = 99999 #Total pages is known after the 1st vRA REST query
                    
                    For ($nbPage=1; $nbPage -le $TotalPages; $nbPage++) {
                        # --- Set the default URI with no filtering to return all resource types
                        $URI = "/catalog-service/api/consumer/resourceViews/?withExtendedData=$($WithExtendedData)&withOperations=$($WithOperations)&managedOnly=$($ManagedOnly)&`$orderby=name asc&limit=$($Limit)&page=$($nbPage)"

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

                        try {
                            $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference
                            
                            foreach ($Resource in $Response.content) {
                               intNewvRAObjectResource $Resource
                            }

                            $TotalPages = $Response.metadata.totalPages
                            Write-Verbose -Message "Total: $($Response.metadata.totalElements) | Page: $($nbPage) of $($TotalPages) | Size: $($Response.metadata.size)"
                        }
                        catch {
                            throw "An error occurred when getting vRA Resources! $($_.Exception.Message)"
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

    End {

    }

}

Function intNewvRAObjectResource {
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $Data
    )

    $props += [ordered]@{
        ResourceId = $Data.ResourceId
        BusinessGroupId = $Data.businessGroupId
        BusinessGroupName = $Data.data.MachineGroupName
        TenantId = $Data.tenantId
        CatalogItemLabel = $Data.data.Component
        ParentResourceId = $Data.parentResourceId
        HasChildren = $Data.hasChildren
        Data = $Data.data
        ResourceType = $Data.resourceType
        Name = $Data.name
        Description = $Data.description
        Status = $Data.status
        RequestId = $Data.requestId      
        Owners = $Data.owners
        DateCreated = $Data.dateCreated
        LastUpdated = $Data.lastUpdated
        Lease = $Data.lease
        Costs = $Data.costs
        CostToDate = $Data.costToDate
        TotalCost = $Data.totalCost
        Links = $Data.links
        IconId = $Data.iconId
    }

    New-Object -TypeName PSObject -Property $props
}
