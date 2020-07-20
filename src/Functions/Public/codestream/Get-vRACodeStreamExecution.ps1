function Get-vRACodeStreamExecution {
<#
    .SYNOPSIS
    Retrieve vRA Code Stream Execution depending on input

    .DESCRIPTION
    Retrieve a list of vRA Code Stream Executions or a single Execution depending on input

    .PARAMETER Id
    The ID of the vRA Code Stream Execution

    .PARAMETER Pipeline
    The name of the Pipeline of the vRA Code Stream Execution

    .PARAMETER Project
    The name of the Project of the vRA Code Stream Execution

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRACodeStreamExecution

    .EXAMPLE
    Get-vRACodeStreamExecution -Id '96afe0f9-a2ac-4468-8671-a2ca6fdbca37'

    .EXAMPLE
    Get-vRACodeStreamExecution -Pipeline 'My Pipeline'

    .EXAMPLE
    Get-vRACodeStreamExecution -Project 'My Project'

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

        $APIUrl = "/pipeline/api/executions"

        function CalculateOutput($ResponseObject) {
            foreach ($Record in $ResponseObject.documents.PsObject.Properties) {
                [PSCustomObject]@{
                    Name = $Record.value.name+" #"+$Record.value.index
                    Project = $Record.value.project
                    Id = $Record.value.id
                    LastUpdated = $Record.value.updatedAt
                    Status = $Record.value.status
                    StatusMessage = $Record.value.statusMessage
                    ExecutedBy = $Record.value._executedBy
                }
            }
        }
    }
    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Execution by its id
                'ById' {
                    foreach ($ExecutionId in $Id) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=id eq '$ExecutionId'" -Method GET
                        CalculateOutput $Response
                    }

                    break
                }

                # --- Get Execution by its pipeline name
                'ByName' {
                    foreach ($PipelineName in $Pipeline) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$PipelineName'" -Method GET
                        CalculateOutput $Response
                    }

                    break
                }

                # --- Get Execution by its project name
                'ByProject' {
                    foreach ($ProjectName in $Project) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=project eq '$ProjectName'" -Method GET
                        CalculateOutput $Response
                    }

                    break
                }

                # --- No parameters passed so return all executions
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
