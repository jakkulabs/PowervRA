function Get-vRACloudZone {
<#
    .SYNOPSIS
    Get a vRA Cloud Zone

    .DESCRIPTION
    Get a vRA Cloud Zone

    .PARAMETER Id
    The ID of the Cloud Zone

    .PARAMETER Name
    The Name of the Cloud Zone

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRACloudZone

    .EXAMPLE
    Get-vRACloudZone -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'

    .EXAMPLE
    Get-vRACloudZone -Name 'TestCloudZone'

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
        $APIUrl = '/iaas/api/zones'

        function CalculateOutput([PSCustomObject]$CloudZone) {

            [PSCustomObject] @{

                Name = $CloudZone.name
                Description = $CloudZone.description
                Id = $CloudZone.id
                PlacementPolicy = $CloudZone.placementPolicy
                Tags = $CloudZone.tags
                TagsToMatch = $CloudZone.tagsToMatch
                CustomProperties = $CloudZone.customProperties
                Folder = $CloudZone.folder
                OrganizationId = $CloudZone.organizationId
                Links = $CloudZone._links
                UpdatedAt = $CloudZone.updatedAt
            }
        }
    }

    process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Cloud Zone by Id
                'ById' {

                    foreach ($CloudZoneId in $Id){

                        $URI = "$($APIUrl)?`$filter=id eq '$($CloudZoneId)'"
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($CloudZone in $Response.content) {

                            CalculateOutput $CloudZone
                        }
                    }

                    break
                }
                # --- Get Cloud Zone by Name
                'ByName' {

                    foreach ($CloudZoneName in $Name){

                        $URI = "$($APIUrl)?`$filter=name eq '$($CloudZoneName)'"
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($CloudZone in $Response.content){

                            CalculateOutput $CloudZone
                        }
                    }

                    break
                }
                # --- No parameters passed so return all Cloud Zones
                'Standard' {

                    $URI = $APIUrl
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    foreach ($CloudZone in $Response.content){

                        CalculateOutput $CloudZone
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
