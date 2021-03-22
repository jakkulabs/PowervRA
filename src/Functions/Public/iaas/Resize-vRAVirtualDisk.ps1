function Resize-vRAVirtualDisk {
<#
    .SYNOPSIS
    Resize a vRA Virtual Disk with the given capacity

    .DESCRIPTION
    Resize a vRA Virtual Disk with the given capacity

    .PARAMETER Id
    The ID of the vRA Virtual Disk

    .PARAMETER CapacityInGB
    The desired resulting capacity in GB

    .PARAMETER WaitForCompletion
    If this flag is added, this function will wait for the resize operation to complete

    .PARAMETER CompletionTimeout
    The default of this paramter is 2 minutes (120 seconds), but this parameter can be overriden here

    .PARAMETER Force
    Force this change

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Resize-vRAVirtualDisk -Id 'b1dd48e71d74267559bb930934470' -CapacityInGB 400

    .EXAMPLE
    Resize-vRAVirtualDisk -Id 'b1dd48e71d74267559bb930934470' -CapacityInGB 400 -WaitForCompletion

    .EXAMPLE
    Resize-vRAVirtualDisk -Id 'b1dd48e71d74267559bb930934470' -CapacityInGB 400 -WaitForCompletion -CompletionTimeout 300

#>
[CmdletBinding(DefaultParameterSetName="ResizeById", SupportsShouldProcess, ConfirmImpact='High')][OutputType('System.Management.Automation.PSObject')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'WaitForCompletion',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'CompletionTimeout',Justification = 'False positive as rule does not scan child scopes')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [int]$CapacityInGB,

        [Parameter()]
        [switch]$WaitForCompletion,

        [Parameter()]
        [int]$CompletionTimeout = 120,

        [Parameter()]
        [switch]$Force

    )
    Begin {

        $APIUrl = "/iaas/api/block-devices"

        function CalculateOutput([int]$Timeout,[switch]$WFC,[PSCustomObject]$RestResponse) {
            Write-Verbose "CompletionTimeout: $Timeout"
            Write-Verbose "WaitForCompletion: $($WFC.IsPresent)"
            Write-Verbose "RestResponse: $RestResponse"
            Write-Verbose "PSBoundParameters: $($PsBoundParameters.Values + $args)"
            if ($WFC.IsPresent) {
                # if the wait for completion flag is given, the output will be different, we will wait here
                # we will use the built-in function to check status
                Write-Verbose "WaitForCompletion"
                $ElapsedTime = 0
                do {
                    $RequestResponse = Get-vRARequest -RequestId $RestResponse.id
                    Write-Verbose $RequestResponse
                    if ($RequestResponse.Status -eq "FINISHED") {
                        foreach ($Resource in $RequestResponse.Resources) {
                            $Record = Invoke-vRARestMethod -URI "$Resource" -Method GET
                            Write-Verbose $Record
                            [PSCustomObject]@{
                                Name = $Record.name
                                capacityInGB = $Record.capacityInGB
                                type = $Record.type
                                ExternalRegionId = $Record.externalRegionId
                                CloudAccountIDs = $Record.cloudAccountIds
                                ExternalId = $Record.externalId
                                Id = $Record.id
                                DateCreated = $Record.createdAt
                                LastUpdated = $Record.updatedAt
                                OrganizationId = $Record.organizationId
                                Properties = $Record.customProperties
                                RequestId = $Response.id
                                RequestStatus = "FINISHED"
                            }
                        }
                        break # leave loop as we are done here
                    }
                    $ElapsedTime += 5
                    Start-Sleep -Seconds 5
                } while ($ElapsedTime -lt $Timeout)

                if ($ElapsedTime -gt $Timeout -or $ElapsedTime -eq $Timeout) {
                    # we have errored out
                    [PSCustomObject]@{
                        Name = $RestResponse.name
                        Progress = $RestResponse.progress
                        Resources = $RestResponse.resources
                        RequestId = $RestResponse.id
                        Message = "We waited for completion, but we hit a timeout at $Timeout seconds. You may use Get-vRARequest -RequestId $($RestResponse.id) to continue checking status. Here was the original response: $($RestResponse.message)"
                        RequestStatus = $RestResponse.status
                    }
                }
            } else {
                Write-Verbose "No Wait Time"
                [PSCustomObject]@{
                    Name = $RestResponse.name
                    Progress = $RestResponse.progress
                    RequestId = $RestResponse.id
                    RequestStatus = $RestResponse.status
                    selfLink = $RestResponse.selfLink
                }
            }
        }
    }
    Process {

        try {
            foreach ($BlockId in $Id) {
                if ($Force.IsPresent -or $PsCmdlet.ShouldProcess($MachineId)) {
                    $RestResponse = Invoke-vRARestMethod -URI "$APIUrl`/$BlockId`?capacityInGB=$CapacityInGB" -Method POST
                    CalculateOutput -Timeout $CompletionTimeout  -RestResponse $RestResponse -WFC $WaitForCompletion
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
