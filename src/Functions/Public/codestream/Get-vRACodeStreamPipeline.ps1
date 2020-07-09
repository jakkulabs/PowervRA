function Get-vRACodeStreamPipeline {
<#
    .SYNOPSIS
    Retrieve vRA Code Stream Pipeline depending on input

    .DESCRIPTION
    Retrieve a list of vRA Code Stream Pipelines or a single Pipeline depending on input

    .PARAMETER Id
    The ID of the vRA Code Stream Pipeline

    .PARAMETER Pipeline
    The name of the Pipeline of the vRA Code Stream Pipeline

    .PARAMETER Project
    The name of the Project of the vRA Code Stream Pipeline

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRACodeStreamPipeline

    .EXAMPLE
    Get-vRACodeStreamPipeline -Id '96afe0f9-a2ac-4468-8671-a2ca6fdbca37'

    .EXAMPLE
    Get-vRACodeStreamPipeline -Pipeline 'My Pipeline'

    .EXAMPLE
    Get-vRACodeStreamPipeline -Project 'My Project'

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Pipeline,

        [Parameter(Mandatory=$true,ParameterSetName="ByProject")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Project

    )
    Begin {

        $APIUrl = "/pipeline/api/pipelines"

        function CalculateOutput($ResponseObject) {
            foreach ($Record in $ResponseObject.documents.PsObject.Properties) {
                [PSCustomObject]@{
                    Name = $Record.value.name
                    Project = $Record.value.project
                    Id = $Record.value.id
                    LastUpdated = $Record.value.updatedAt
                    UpdatedBy = $Record.value._updatedBy
                    State = $Record.value.state
                }
            }
        }
    }
    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Pipeline by its id
                'ById' {
                    foreach ($PipelineId in $Id) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=id eq '$PipelineId'" -Method GET
                        CalculateOutput $Response
                    }

                    break
                }

                # --- Get Pipeline by its pipeline name
                'ByName' {
                    foreach ($PipelineName in $Pipeline) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$PipelineName'" -Method GET
                        CalculateOutput $Response
                    }

                    break
                }

                # --- Get Pipeline by its project name
                'ByProject' {
                    foreach ($ProjectName in $Project) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=project eq '$ProjectName'" -Method GET
                        CalculateOutput $Response
                    }

                    break
                }

                # --- No parameters passed so return all Pipelines
                'Standard' {
                    $Response = Invoke-vRARestMethod -URI $APIUrl -Method GET
                    CalculateOutput $Response
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
