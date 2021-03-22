function New-vRAMachineAttachedDisk {
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

    .PARAMETER WaitForCompletion
    If this flag is added, this function will wait for the request to complete and will return the created Virtual Disk

    .PARAMETER CompletionTimeout
    The default of this paramter is 2 minutes (120 seconds), but this parameter can be overriden here

    .PARAMETER Force
    Force this change

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    New-vRAMachineAttachedDisk -Id 'b1dd48e71d74267559bb930934470' -BlockDeviceId'123456'

    .EXAMPLE
    New-vRAMachineAttachedDisk -Name 'iaas01' -BlockDeviceId'123456'

    .EXAMPLE
    New-vRAMachineAttachedDisk -Name 'iaas01' -BlockDeviceId'123456' -WaitForCompletion

    .EXAMPLE
    New-vRAMachineAttachedDisk -Name 'iaas01' -BlockDeviceId'123456' -WaitForCompletion -CompletionTimeout 300

    .EXAMPLE
    New-vRAMachineAttachedDisk -Name 'iaas01' -BlockDeviceId'123456' -DeviceName 'Disk 17' -DeviceDescription 'This is a disk attached from script'

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="ByName")][OutputType('System.Management.Automation.PSObject')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'WaitForCompletion',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'CompletionTimeout',Justification = 'False positive as rule does not scan child scopes')]

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
        [String[]]$BlockDeviceId,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]]$DeviceName,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]]$DeviceDescription,

        [Parameter()]
        [switch]$WaitForCompletion,

        [Parameter()]
        [int]$CompletionTimeout = 120,

        [Parameter()]
        [switch]$Force

    )
    Begin {

        $APIUrl = "/iaas/api/machines"

        function CalculateOutput([String[]]$BlockDeviceId,[int]$CompletionTimeout,[switch]$WaitForCompletion,[PSCustomObject]$RestResponse) {

            if ($WaitForCompletion.IsPresent) {
                # if the wait for completion flag is given, the output will be different, we will wait here
                # we will use the built-in function to check status
                $ElapsedTime = 0
                    do {
                        $RequestResponse = Get-vRARequest -RequestId $RestResponse.id
                        if ($RequestResponse.Status -eq "FINISHED") {
                            foreach ($Resource in $RequestResponse.Resources) {
                                $Response = Invoke-vRARestMethod -URI "$Resource/disks/$BlockDeviceId" -Method GET
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
                                    RequestId = $Response.id
                                    RequestStatus = "FINISHED"
                                }
                            }
                            break # leave loop as we are done here
                        }
                        $ElapsedTime += 5
                        Start-Sleep -Seconds 5
                    } while ($ElapsedTime -lt $CompletionTimeout)

                    if ($ElapsedTime -gt $CompletionTimeout -or $ElapsedTime -eq $CompletionTimeout) {
                        # we have errored out
                        [PSCustomObject]@{
                            Name = $RestResponse.name
                            Progress = $RestResponse.progress
                            Resources = $RestResponse.resources
                            RequestId = $RestResponse.id
                            Message = "We waited for completion, but we hit a timeout at $CompletionTimeout seconds. You may use Get-vRARequest -RequestId $($RestResponse.id) to continue checking status. Here was the original response: $($RestResponse.message)"
                            RequestStatus = $RestResponse.status
                        }
                    }
            } else {
                [PSCustomObject]@{
                    Name = $RestResponse.name
                    Progress = $RestResponse.progress
                    Resources = $RestResponse.resources
                    RequestId = $RestResponse.id
                    Message = $RestResponse.message
                    RequestStatus = $RestResponse.status
                }
            }
        }
    }
    Process {

        try {

            $Body = @"
                {
                    "blockDeviceId": "$($BlockDeviceId)",
                    "name": "$($DeviceName)",
                    "description": "$($DeviceDescription)"
                }
"@
            Write-Verbose -Message $Body

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Machine Attached Disk by its id
                'ById' {
                    if ($Force.IsPresent -or $PsCmdlet.ShouldProcess($Id)){
                        # --- Check to see if the DiskId's were optionally present
                        $RestResponse = Invoke-vRARestMethod -URI "$APIUrl`/$Id`/disks" -Method GET -Body $Body

                        CalculateOutput $BlockDeviceId $CompletionTimeout $WaitForCompletion $RestResponse
                    }
                    break
                }

                # --- Get Machine Attached Disk by its name
                # --- Will need to retrieve the machine first, then use ID to get final output
                'ByName' {
                    if ($Force.IsPresent -or $PsCmdlet.ShouldProcess($Name)){
                        $MachineResponse = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$Name'`&`$select=id" -Method GET
                        $MachineId = $MachineResponse.content[0].id

                        $RestResponse = Invoke-vRARestMethod -URI "$APIUrl`/$MachineId`/disks" -Method POST -Body $Body

                        CalculateOutput $BlockDeviceId $CompletionTimeout $WaitForCompletion $RestResponse
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
