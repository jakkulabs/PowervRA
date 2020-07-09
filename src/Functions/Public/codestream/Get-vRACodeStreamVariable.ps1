function Get-vRACodeStreamVariable {
<#
    .SYNOPSIS
    Retrieve vRA Code Stream Variable depending on input

    .DESCRIPTION
    Retrieve a list of vRA Code Stream Variables or a single Variable depending on input

    .PARAMETER Id
    The ID of the vRA Code Stream Variable

    .PARAMETER Variable
    The name of the Variable of the vRA Code Stream Variable

    .PARAMETER Project
    The name of the Project of the vRA Code Stream Variable

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRACodeStreamVariable

    .EXAMPLE
    Get-vRACodeStreamVariable -Id '96afe0f9-a2ac-4468-8671-a2ca6fdbca37'

    .EXAMPLE
    Get-vRACodeStreamVariable -Variable 'My Variable'

    .EXAMPLE
    Get-vRACodeStreamVariable -Project 'My Project'

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Variable,

        [Parameter(Mandatory=$true,ParameterSetName="ByProject")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Project

    )
    Begin {

        $APIUrl = "/pipeline/api/variables"

        function CalculateOutput($ResponseObject) {
            foreach ($Record in $ResponseObject.documents.PsObject.Properties) {
                [PSCustomObject]@{
                    Name = $Record.value.name
                    Project = $Record.value.project
                    Id = $Record.value.id
                    Type = $Record.value.type
                    LastUpdated = $Record.value.updatedAt
                    CreatedBy = $Record.value._createdBy
                    Value = $Record.value.value
                }
            }
        }
    }
    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Variable by its id
                'ById' {
                    foreach ($VariableId in $Id) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=id eq '$VariableId'" -Method GET
                        CalculateOutput $Response
                    }

                    break
                }

                # --- Get Variable by its name
                'ByName' {
                    foreach ($VariableName in $Variable) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$VariableName'" -Method GET
                        CalculateOutput $Response
                    }

                    break
                }

                # --- Get Variable by its project name
                'ByProject' {
                    foreach ($ProjectName in $Project) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=project eq '$ProjectName'" -Method GET
                        CalculateOutput $Response
                    }

                    break
                }

                # --- No parameters passed so return all Variables
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
