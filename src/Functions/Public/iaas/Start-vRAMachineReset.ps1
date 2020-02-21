function Start-vRAMachineReset {
<#
    .SYNOPSIS
    Reset a vRA Machine

    .DESCRIPTION
    Reset a vRA Machine

    .PARAMETER Id
    The ID of the vRA Machine

    .PARAMETER Name
    The Name of the vRA Machine

    .PARAMETER Force
    Force this change

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Start-vRAMachineReset -Id 'b1dd48e71d74267559bb930934470'

    .EXAMPLE
    Start-vRAMachineReset -Name 'iaas01'

#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact="High", DefaultParameterSetName="ResetByName")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ResetById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ResetByName")]
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
                    'ResetById' {
                        foreach ($machineId in $Id) {
                            $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/reset" -Method POST
                            CalculateOutput
                        }

                        break
                    }

                    # --- Restart the given machine by its name
                    'ResetByName' {
                        foreach ($machine in $Name) {
                            $machineResponse = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$machine'`&`$select=id" -Method GET
                            $machineId = $machineResponse.content[0].Id

                            $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/reset" -Method POST
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
