function Start-vRAMachineDiskAttach {
<#
    .SYNOPSIS
    Retrieve a vRA Machine's Disks

    .DESCRIPTION
    Retrieve the disks for a vRA Machine

    .PARAMETER Id
    The ID of the vRA Machine

    .PARAMETER Name
    The Name of the vRA Machine

    .PARAMETER blockDeviceId
    The Id of the individual Disk to attach (Block Device ID)

    .PARAMETER DeviceName
    The name we wish to give the device as we attach it to the machine

    .PARAMETER DeviceDescription
    A description we can associate with the disk after attaching it to the machine

    .PARAMETER Force
    Force this change

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Start-vRAMachineDiskAttach -Id 'b1dd48e71d74267559bb930934470' -blockDeviceId '123456'

    .EXAMPLE
    Start-vRAMachineDiskAttach -Name 'iaas01' -blockDeviceId '123456'

    .EXAMPLE
    Start-vRAMachineDiskAttach -Name 'iaas01' -blockDeviceId '123456' -DeviceName 'Disk 17' -DeviceDescription 'This is a disk attached from script'

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="ByName")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [Parameter(Mandatory=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$blockDeviceId,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]]$DeviceName,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]]$DeviceDescription,

        [Parameter()]
        [switch]$Force

    )
    Begin {

        $APIUrl = "/iaas/api/machines"

        function CalculateOutput {

            [PSCustomObject]@{
                Name = $Response.name
                Progress = $Response.progress
                Id = $Response.id
                Status = $Response.status
            }
        }
    }
    Process {

        try {
            if ($Force -or $PsCmdlet.ShouldProcess('ShouldProcess?')){
            $Body = @"
                {
                    "blockDeviceId": "$($blockDeviceId)",
                    "name": "$($DeviceName)",
                    "description": "$($DeviceDescription)"
                }
"@
            Write-Verbose -Message $Body

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Machine by its id
                'ById' {

                    # --- Check to see if the DiskId's were optionally present
                    $Response = Invoke-vRARestMethod -URI "$APIUrl`/$Id`/disks" -Method GET -Body $Body

                    CalculateOutput

                    break
                }

                # --- Get Machine by its name
                # --- Will need to retrieve the machine first, then use ID to get final output
                'ByName' {

                    $machineResponse = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$Name'`&`$select=id" -Method GET
                    $machineId = $machineResponse.content[0].id

                    $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId`/disks" -Method POST -Body $Body

                    CalculateOutput

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
