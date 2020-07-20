function Get-vRAMachine {
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

        function CalculateOutput([PSCustomObject]$Response) {

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
                    Tags = $Record.tags
                }
            }
        }
    }
    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Machine by its id
                'ById' {
                    foreach ($MachineId in $Id) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=id eq '$MachineId'" -Method GET
                        CalculateOutput $Response
                    }

                    break
                }

                # --- Get Machine by its name
                'ByName' {
                    foreach ($MachineName in $Name) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$MachineName'" -Method GET
                        CalculateOutput $Response
                    }

                    break
                }

                # --- No parameters passed so return all machines
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
