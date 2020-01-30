﻿function Get-vRAMachine {
<#
    .SYNOPSIS
    Retrieve vRA Machine(s) depending on input

    .DESCRIPTION
    Retrieve a list of vRA Machines or a single machine depending on input

    .PARAMETER Id
    The ID of the vRA Machine

    .PARAMETER Name
    The Name of the vRA Machine

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAMachine

    .EXAMPLE
    Get-vRAMachine -Id 'b1dd48e71d74267559bb930934470'

    .EXAMPLE
    Get-vRAMachine -Name 'iaas01'

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
    Begin {

        $APIUrl = "/iaas/api/machines"

        function CalculateOutput {

            foreach ($Record in $Response.content) {
                [PSCustomObject]@{
                    Name = $Record.name
                    PowerState = $Record.powerState
                    IPAddress = $Record.address
                    ExternalRegionId = $Record.externalRegionId
                    CloudAccountIDs = $Record.cloudAccountIds
                    ExternalId = $Record.externalId
                    Id = $Record.id
                    DateCreated = $Record.createdAt
                    LastUpdated = $Record.updatedAt
                    OrganizationId = $Record.organizationId
                    Properties = $Record.customProperties
                }
            }
        }
    }
    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Machine by its id
                'ById' {
                    foreach ($machineId in $Id) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=id eq '$machineId'" -Method GET
                        CalculateOutput
                    }

                    break
                }

                # --- Get Machine by its name
                'ByName' {
                    foreach ($machineName in $Name) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$machineName'" -Method GET
                        CalculateOutput
                    }

                    break
                }

                # --- No parameters passed so return all machines
                'Standard' {
                    $Response = Invoke-vRARestMethod -URI $APIUrl -Method GET
                    CalculateOutput
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
