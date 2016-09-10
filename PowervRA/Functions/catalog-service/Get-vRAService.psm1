function Get-vRAEntitledService {
<#
    .SYNOPSIS
    Retrieve vRA services that the user is has access to

    .DESCRIPTION
    A service represents a customer-facing/user friendly set of activities. In the context of this Service Catalog, 
    these activities are the catalog items and resource actions. 
    A service must be owned by a specific organization and all the activities it contains should belongs to the same organization.
    
    .PARAMETER Id
    The id of the service
    
    .PARAMETER Name
    The Name of the service

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
    Get-vRAService
    
    .EXAMPLE
    Get-vRAService -Id 332d38d5-c8db-4519-87a7-7ef9f358091a
    
    .EXAMPLE
    Get-vRAService -Name "Default Service"
    
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$false, ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,
        
        [Parameter(Mandatory=$false, ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100

    )

    try {

        switch ($PsCmdlet.ParameterSetName) {

            # --- Get Service by id
            'ById' {

                foreach ($ServiceId in $Id) { 

                    $URI = "/catalog-service/api/services/$($ServiceId)"

                    $Service = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    [PSCustomObject] @{

                        Id = $Service.id
                        Name = $Service.name
                        Description = $Service.description
                        Status = $Service.status
                        StatusName = $Service.statusName
                        Version = $Service.version
                        Organization = $Service.organization
                        Hours = $Service.hours
                        Owner = $Service.owner
                        SupportTeam = $Service.supportTeam
                        ChangeWindow = $Service.changeWindow
                        NewDuration = $Service.newDuration
                        LastUpdatedDate = $Service.lastUpdatedDate
                        LastUpdatedBy = $Service.lastUpdatedBy
                        IconId = $Service.iconId

                    }

                }

                break

            }
            # --- Get Service by name
            'ByName' {

                foreach ($ServiceName in $Name) {

                    $URI = "/catalog-service/api/services?`$filter=name eq '$($ServiceName)'"

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                    if ($Response.content.Count -eq 0) {

                        throw "Could not find service with name: $($ServiceName)"

                    }

                    $Service = $Response.Content

                    [PSCustomObject] @{

                        Id = $Service.id
                        Name = $Service.name
                        Description = $Service.description
                        Status = $Service.status
                        StatusName = $Service.statusName
                        Version = $Service.version
                        Organization = $Service.organization
                        Hours = $Service.hours
                        Owner = $Service.owner
                        SupportTeam = $Service.supportTeam
                        ChangeWindow = $Service.changeWindow
                        NewDuration = $Service.newDuration
                        LastUpdatedDate = $Service.lastUpdatedDate
                        LastUpdatedBy = $Service.lastUpdatedBy
                        IconId = $Service.iconId

                    }

                }

                break

            }
            # --- No parameters passed so return all services
            'Standard' {

                $URI = "/catalog-service/api/services?limit=$($Limit)&page=$($Page)&`$orderby=name asc"

                $EscapedURI = [uri]::EscapeUriString($URI)

                $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                foreach ($Service in $Response.content) {

                    [PSCustomObject] @{

                        Id = $Service.id
                        Name = $Service.name
                        Description = $Service.description
                        Status = $Service.status
                        StatusName = $Service.statusName
                        Version = $Service.version
                        Organization = $Service.organization
                        Hours = $Service.hours
                        Owner = $Service.owner
                        SupportTeam = $Service.supportTeam
                        ChangeWindow = $Service.changeWindow
                        NewDuration = $Service.newDuration
                        LastUpdatedDate = $Service.lastUpdatedDate
                        LastUpdatedBy = $Service.lastUpdatedBy
                        IconId = $Service.iconId

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