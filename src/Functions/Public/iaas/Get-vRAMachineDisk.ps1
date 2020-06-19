function Get-vRAMachineDisk {
<#
    .SYNOPSIS
    Retrieve a vRA Machine's Disks

    .DESCRIPTION
    Retrieve the disks for a vRA Machine

    .PARAMETER Id
    The ID of the vRA Machine

    .PARAMETER Name
    The Name of the vRA Machine

    .PARAMETER DiskId
    The Id of the individual Disk to retrieve

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAMachineDisk -Id 'b1dd48e71d74267559bb930934470'

    .EXAMPLE
    Get-vRAMachineDisk -Name 'iaas01'

    .EXAMPLE
    GET-vRAMachineDisk -Name 'iaas01' -DiskId b1dd48e71d74267559bb930919aa8,b1dd48e71d74267559bb930915840

#>
[CmdletBinding(DefaultParameterSetName="ByName")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]]$DiskId

    )
    Begin {

        $APIUrl = "/iaas/api/machines"

        function CalculateOutput([PSCustomObject]$Response) {

            # --- The output comes in two flavors, a list or a single item, we are checking for list here
            if ($Response.content) {
                foreach ($Record in $Response.content) {
                    [PSCustomObject]@{
                        Name = $Record.name
                        Status = $Record.status
                        Owner = $Record.owner
                        ExternalRegionId = $Record.externalRegionId
                        ExternalZoneId = $Record.externalZoneId
                        Description = $Record.description
                        Tags = $Record.tags
                        CapacityInGB = $Record.capacityInGB
                        CloudAccountIDs = $Record.cloudAccountIds
                        ExternalId = $Record.externalId
                        Id = $Record.id
                        DateCreated = $Record.createdAt
                        LastUpdated = $Record.updatedAt
                        OrganizationId = $Record.orgId
                        Properties = $Record.customProperties
                        ProjectId = $Record.projectId
                        Persistent = $Record.persistent
                    }
                }
            } else {
                [PSCustomObject]@{
                    Name = $Response.name
                    Status = $Response.status
                    Owner = $Response.owner
                    ExternalRegionId = $Response.externalRegionId
                    ExternalZoneId = $Response.externalZoneId
                    Description = $Response.description
                    Tags = $Response.tags
                    CapacityInGB = $Response.capacityInGB
                    CloudAccountIDs = $Response.cloudAccountIds
                    ExternalId = $Response.externalId
                    Id = $Response.id
                    DateCreated = $Response.createdAt
                    LastUpdated = $Response.updatedAt
                    OrganizationId = $Response.orgId
                    Properties = $Response.customProperties
                    ProjectId = $Response.projectId
                    Persistent = $Response.persistent
                }
            }

        }
    }
    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Machine by its id
                'ById' {

                    # --- Check to see if the DiskId's were optionally present
                    if ($DiskId) {

                        foreach($disk in $DiskId) {

                            $Response = Invoke-vRARestMethod -URI "$APIUrl`/$Id`/disks`/$disk" -Method GET

                            CalculateOutput $Response

                        }

                    } else {

                        $Response = Invoke-vRARestMethod -URI "$APIUrl`/$Id`/disks" -Method GET

                        CalculateOutput $Response

                    }

                    break
                }

                # --- Get Machine by its name
                # --- Will need to retrieve the machine first, then use ID to get final output
                'ByName' {

                    $machineResponse = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$Name'`&`$select=id" -Method GET
                    $machineId = $machineResponse.content[0].id

                    # --- Check to see if the DiskId's were optionally present
                    if ($DiskId) {

                        foreach($disk in $DiskId) {

                            $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId`/disks`/$disk" -Method GET

                            CalculateOutput $Response

                        }


                    } else {

                        $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId`/disks" -Method GET

                        CalculateOutput $Response

                    }


                    break
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
