function Start-vRAVirtualDiskCreate {
    <#
        .SYNOPSIS
        Retrieve a vRA Machine's Disks

        .DESCRIPTION
        Retrieve the disks for a vRA Machine

        .PARAMETER Name
        The Name you would like to give the new disk/volume

        .PARAMETER Encrypted
        Switch indicating if the device will be encrypted during build

        .PARAMETER CapacityInGB
        Integer value indicating capacity of the disk in GB

        .PARAMETER DeviceDescription
        A description we can associate with the disk after creating it

        .PARAMETER Persistent
        Another switch indicating the disk to be a persistent disk

        .PARAMETER ProjectId
        The id of the project in which to build the disk/volume in

        .PARAMETER ProjectName
        As an alternate, a project name can be given for this operation

        .PARAMETER Force
        Force the creation

        .OUTPUTS
        System.Management.Automation.PSObject.

        .EXAMPLE
        Start-vRAVirtualDiskCreate -Name 'test_disk_1' -CapacityInGB 10 -ProjectId 'b1dd48e71d74267559bb930934470'

        .EXAMPLE
        Start-vRAVirtualDiskCreate -Name 'test_disk_1' -CapacityInGB 10 -ProjectName 'GOLD'

        .EXAMPLE
        Start-vRAVirtualDiskCreate -Name 'test_disk_1' -CapacityInGB 10 -ProjectId 'b1dd48e71d74267559bb930934470' -Persistent -Encrypted

    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="ByName")][OutputType('System.Management.Automation.PSObject')]

        Param (

            [Parameter(Mandatory=$true,ParameterSetName="ByName")]
            [Parameter(Mandatory=$true,ParameterSetName="ById")]
            [ValidateNotNullOrEmpty()]
            [String]$Name,

            [Parameter(Mandatory=$true,ParameterSetName="ByName")]
            [Parameter(Mandatory=$true,ParameterSetName="ById")]
            [ValidateNotNullOrEmpty()]
            [int]$CapacityInGB,

            [Parameter(Mandatory=$true,ParameterSetName="ById")]
            [ValidateNotNullOrEmpty()]
            [String[]]$ProjectId,

            [Parameter(Mandatory=$true,ParameterSetName="ByName")]
            [ValidateNotNullOrEmpty()]
            [String[]]$ProjectName,

            [Parameter(Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [String[]]$DeviceDescription,

            [Parameter()]
            [switch]$Persistent,

            [Parameter()]
            [switch]$Encrypted,

            [Parameter()]
            [switch]$Force

        )
        Begin {

            $APIUrl = "/iaas/api/block-devices"

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

                switch ($PsCmdlet.ParameterSetName) {

                    # --- Get Machine by its id
                    'ById' {

                        $Body = @"
                            {
                                "capacityInGB": $($CapacityInGB),
                                "encrypted": $($Encrypted),
                                "name": "$($Name)",
                                "description": "$($DeviceDescription)",
                                "persistent": $($Persistent),
                                "projectId": "$($ProjectId)"
                            }
"@
                        # --- Check to see if the DiskId's were optionally present
                        $Response = Invoke-vRARestMethod -URI "$APIUrl" -Method POST -Body $Body

                        CalculateOutput

                        break
                    }

                    # --- Get Machine by its name
                    # --- Will need to retrieve the machine first, then use ID to get final output
                    'ByName' {

                        $projResponse = Invoke-vRARestMethod -URI "/iaas/api/projects`?`$filter=name eq '$ProjectName'`&`$select=id" -Method GET
                        $projId = $projResponse.content[0].id

                        $Body = @"
                            {
                                "capacityInGB": $($CapacityInGB),
                                "encrypted": $($Encrypted),
                                "name": "$($Name)",
                                "description": "$($DeviceDescription)",
                                "persistent": $($Persistent),
                                "projectId": "$($projId)"
                            }
"@
                            Write-Verbose $Body
                        $Response = Invoke-vRARestMethod -URI "$APIUrl" -Method POST -Body $Body

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
