function Start-vRAMachineResize {
<#
    .SYNOPSIS
    Resize a vRA Machine with the given CPU and Memory inputs

    .DESCRIPTION
    Resize a vRA Machine with the given CPU and Memory inputs

    .PARAMETER Id
    The ID of the vRA Machine

    .PARAMETER Name
    The Name of the vRA Machine

    .PARAMETER CPU
    The desired resulting cpu count for the machine

    .PARAMETER Memory
    The desired resulting memory in MB for the machine

    .PARAMETER Flavor
    As an alternative, you can provide a flavor instead of a cpu or memory option

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Start-vRAMachineResize -Id 'b1dd48e71d74267559bb930934470' -CPU 4 -Memory 8192

    .EXAMPLE
    Start-vRAMachineResize -Name 'iaas01' -CPU 4 -Memory 8192

    .EXAMPLE
    Start-vRAMachineResize -Id 'b1dd48e71d74267559bb930934470' -Flavor Small

    .EXAMPLE
    Start-vRAMachineResize -Name 'iaas01' -Flavor Small

#>
[CmdletBinding(DefaultParameterSetName="ResizeByName", SupportsShouldProcess, ConfirmImpact='High')][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ResizeById")]
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ResizeFlavorById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ResizeByName")]
        [Parameter(Mandatory=$true,ParameterSetName="ResizeFlavorByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [Parameter(Mandatory=$true,ParameterSetName="ResizeFlavorById")]
        [Parameter(Mandatory=$true,ParameterSetName="ResizeFlavorByName")]
        [ValidateNotNullOrEmpty()]
        [String]$Flavor,

        [Parameter(Mandatory=$true,ParameterSetName="ResizeByName")]
        [Parameter(Mandatory=$true,ParameterSetName="ResizeById")]
        [ValidateNotNullOrEmpty()]
        [int]$CPU,

        [Parameter(Mandatory=$true,ParameterSetName="ResizeByName")]
        [Parameter(Mandatory=$true,ParameterSetName="ResizeById")]
        [ValidateNotNullOrEmpty()]
        [int]$Memory,

        [Parameter()]
        [switch]
        $Force

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

            if ($Force -or $PsCmdlet.ShouldProcess("ShouldProcess?")) {
                switch ($PsCmdlet.ParameterSetName) {

                    # --- Resize by Flavor, do not need cpu and memory
                    'ResizeFlavorById' {
                        foreach ($machineId in $Id) {
                            $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/resize?name=$Flavor" -Method POST
                            CalculateOutput
                        }

                        break
                    }

                    # --- Resize by Flavor, do not need cpu and memory
                    'ResizeFlavorByName' {
                        foreach ($machine in $Name) {
                            $machineResponse = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$machine'`&`$select=id" -Method GET
                            $machineId = $machineResponse.content[0].Id

                            $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/resize?name=$Flavor" -Method POST
                            CalculateOutput
                        }

                        break
                    }

                    # --- Resize with cpu and memory for given machine by its id
                    'ResizeById' {
                        foreach ($machineId in $Id) {
                            $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/resize?memoryInMB=$Memory`&cpuCount=$CPU" -Method POST
                            CalculateOutput
                        }

                        break
                    }

                    # --- Resize with cpu and memory for given machine by its name
                    'ResizeByName' {
                        foreach ($machine in $Name) {
                            $machineResponse = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$machine'`&`$select=id" -Method GET
                            $machineId = $machineResponse.content[0].Id

                            $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/resize?memoryInMB=$Memory`&cpuCount=$CPU" -Method POST
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
