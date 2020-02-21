function Start-vRAMachinePowerOff {
<#
    .SYNOPSIS
    Power-Off a vRA Machine

    .DESCRIPTION
    Power-Off a vRA Machine

    .PARAMETER Id
    The ID of the vRA Machine

    .PARAMETER Name
    The Name of the vRA Machine

    .PARAMETER Force
    Force this change

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Start-vRAMachinePowerOff -Id 'b1dd48e71d74267559bb930934470'

    .EXAMPLE
    Start-vRAMachinePowerOff -Name 'iaas01'

#>
[CmdletBinding(DefaultParameterSetName="PowerOffByName", SupportsShouldProcess, ConfirmImpact='High')][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="PowerOffById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="PowerOffByName")]
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
            if ($Force -or $PsCmdlet.ShouldProcess('ShouldProcess?')){
                switch ($PsCmdlet.ParameterSetName) {

                    # --- Restart the given machine by its id
                    'PowerOffById' {
                        foreach ($machineId in $Id) {
                            $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/power-off" -Method POST
                            CalculateOutput
                        }

                        break
                    }

                    # --- Restart the given machine by its name
                    'PowerOffByName' {
                        foreach ($machine in $Name) {
                            $machineResponse = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$machine'`&`$select=id" -Method GET
                            $machineId = $machineResponse.content[0].Id

                            $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/power-off" -Method POST
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
