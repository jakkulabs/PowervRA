function Start-vRAMachineReboot {
<#
    .SYNOPSIS
    Reboot a vRA Machine

    .DESCRIPTION
    Reboot a vRA Machine

    .PARAMETER Id
    The ID of the vRA Machine

    .PARAMETER Name
    The Name of the vRA Machine

    .PARAMETER Force
    Force this change

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Start-vRAMachineReboot -Id 'b1dd48e71d74267559bb930934470'

    .EXAMPLE
    Start-vRAMachineReboot -Name 'iaas01'

#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact="High", DefaultParameterSetName="RebootByName")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="RebootById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="RebootByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [Parameter()]
        [switch]$Force

    )
    Begin {

        $APIUrl = "/iaas/api/machines"

        function CalculateOutput {

            [PSCustomObject]@{
                Name = $Response.name
                Progress = $Response.progress
                Resources = $Response.resources
                Id = $Response.id
                Message = $Response.message
                Status = $Response.status
            }
        }
    }
    Process {

        try {
            if ($Force -or $PsCmdlet.ShouldProcess('ShouldProcess?')) {
                switch ($PsCmdlet.ParameterSetName) {

                    # --- Restart the given machine by its id
                    'RebootById' {
                        foreach ($machineId in $Id) {
                            $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/reboot" -Method POST
                            CalculateOutput
                        }

                        break
                    }

                    # --- Restart the given machine by its name
                    'RebootByName' {
                        foreach ($machine in $Name) {
                            $machineResponse = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$machine'`&`$select=id" -Method GET
                            $machineId = $machineResponse.content[0].Id

                            $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/reboot" -Method POST
                            CalculateOutput
                        }

                        break
                    }

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
