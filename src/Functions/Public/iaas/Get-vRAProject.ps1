function Get-vRAProject {
<#
    .SYNOPSIS
    Get a vRA Project

    .DESCRIPTION
    Get a vRA Project

    .PARAMETER Id
    The ID of the Project

    .PARAMETER Name
    The Name of the Project

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAProject

    .EXAMPLE
    Get-vRAProject -Id '3492a6e8-4e70-1293-b6c4-39037ba693f9'

    .EXAMPLE
    Get-vRAProject -Name 'Test Project'

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
        $APIUrl = '/iaas/projects'

        function CalculateOutput {

            [PSCustomObject] @{

                Name = $Project.name
                Description = $Project.description
                Id = $Project.id
                Administrators = $Project.administrators
                Members = $Project.members
                Viewers = $Project.viewers
                Zones = $Project.zones
                SharedResources = $Project.sharedResources
                OperationTimeout = $Project.operationTimeout
                OrganizationId = $Project.organizationId
                Links = $Project._links
            }
        }
    }

    process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Project by id
                'ById' {

                    foreach ($ProjectId in $Id){

                        $URI = "$($APIUrl)?`$filter=id eq '$($ProjectId)'"
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($Project in $Response.content) {

                            CalculateOutput
                        }
                    }

                    break
                }
                # --- Get Project by name
                'ByName' {

                    foreach ($ProjectName in $Name){

                        $URI = "$($APIUrl)?`$filter=name eq '$($ProjectName)'"
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($Project in $Response.content){

                            CalculateOutput
                        }
                    }

                    break
                }
                # --- No parameters passed so return all Projects
                'Standard' {

                    $URI = $APIUrl
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    foreach ($Project in $Response.content){

                        CalculateOutput
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