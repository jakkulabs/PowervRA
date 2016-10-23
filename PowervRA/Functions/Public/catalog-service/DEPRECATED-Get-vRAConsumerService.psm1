function Get-vRAConsumerService {
<#
    .SYNOPSIS
    Retrieve vRA services
    
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

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAConsumerService
    
    .EXAMPLE
    Get-vRAConsumerService -Id 332d38d5-c8db-4519-87a7-7ef9f358091a
    
    .EXAMPLE
    Get-vRAConsumerService -Name "Default Service"
    
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

    Write-Warning -Message "This command is deprecated and will be removed in a future release. Please use Get-vRAEntitledService instead."

    try {

        switch ($PsCmdlet.ParameterSetName) {

            # --- Get Service by id
            'ById' {
            
                foreach ($ServiceId in $Id) { 
            
                    $URI = "/catalog-service/api/consumer/services/$($ServiceId)"

                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    Write-Verbose -Message "SUCCESS"

                    [pscustomobject] @{

                        Id = $Response.id
                        Name = $Response.name
                        Description = $Response.description
                        Status = $Response.status
                        StatusName = $Response.statusName
                        Version = $Response.version
                        Organization = $Response.organization
                        Hours = $Response.hours
                        Owner = $Response.owner
                        SupportTeam = $Response.supportTeam
                        ChangeWindow = $Response.changeWindow
                        NewDuration = $Response.newDuration
                        LastUpdatedDate = $Response.lastUpdatedDate
                        LastUpdatedBy = $Response.lastUpdatedBy
                        IconId = $Response.iconId

                    }

                }

                break
            }        
            # --- Get Service by name
            'ByName' {

                foreach ($ServiceName in $Name) {
            
                    $URI = "/catalog-service/api/consumer/services?`$filter=name%20eq%20'$($ServiceName)'"

                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    Write-Verbose -Message "SUCCESS"
            
                    if ($Response.content.Length -eq 0) {

                        throw "Could not find service item with name: $($ServiceName)"

                    }        
            
                    [pscustomobject] @{

                        Id = $Response.content.id
                        Name = $Response.content.name
                        Description = $Response.content.description
                        Status = $Response.content.status
                        StatusName = $Response.content.statusName
                        Version = $Response.content.version
                        Organization = $Response.content.organization
                        Hours = $Response.content.hours
                        Owner = $Response.content.owner
                        SupportTeam = $Response.content.supportTeam
                        ChangeWindow = $Response.content.changeWindow
                        NewDuration = $Response.content.newDuration
                        LastUpdatedDate = $Response.content.lastUpdatedDate
                        LastUpdatedBy = $Response.content.lastUpdatedBy
                        IconId = $Response.content.iconId

                    }
                    
                }
                
                break                                
            
            }        
            # --- No parameters passed so return all services
            'Standard' {
            
                $URI = "/catalog-service/api/consumer/services?limit=$($Limit)&`$orderby=name%20asc"

                Write-Verbose -Message "Preparing GET to $($URI)"

                $Response = Invoke-vRARestMethod -Method GET -URI $URI

                Write-Verbose -Message "SUCCESS"

                Write-Verbose -Message "Response contains $($Response.content.Length) records"

                foreach ($Service in $Response.content) {

                    [pscustomobject] @{

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

        }
    }
    catch [Exception]{

        throw
    }
}