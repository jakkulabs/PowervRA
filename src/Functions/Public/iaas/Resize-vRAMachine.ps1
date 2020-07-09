function Resize-vRAMachine {
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

    .PARAMETER WaitForCompletion
    If this flag is added, this function will wait for the resize operation to complete

    .PARAMETER CompletionTimeout
    The default of this paramter is 2 minutes (120 seconds), but this parameter can be overriden here

    .PARAMETER Force
    Force this change

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Resize-vRAMachine -Id 'b1dd48e71d74267559bb930934470' -CPU 4 -Memory 8192

    .EXAMPLE
    Resize-vRAMachine -Name 'iaas01' -CPU 4 -Memory 8192

    .EXAMPLE
    Resize-vRAMachine -Id 'b1dd48e71d74267559bb930934470' -Flavor Small

    .EXAMPLE
    Resize-vRAMachine -Name 'iaas01' -Flavor Small

    .EXAMPLE
    Resize-vRAMachine -Name 'iaas01' -Flavor Small -WaitForCompletion

    .EXAMPLE
    Resize-vRAMachine -Name 'iaas01' -Flavor Small -WaitForCompletion -CompletionTimeout 300

#>
[CmdletBinding(DefaultParameterSetName="ResizeByName", SupportsShouldProcess, ConfirmImpact='High')][OutputType('System.Management.Automation.PSObject')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'WaitForCompletion',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'CompletionTimeout',Justification = 'False positive as rule does not scan child scopes')]

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
        [switch]$WaitForCompletion,

        [Parameter()]
        [int]$CompletionTimeout = 120,

        [Parameter()]
        [switch]$Force

    )
    Begin {

        $APIUrl = "/iaas/api/machines"

        function CalculateOutput([int]$CompletionTimeout,[switch]$WaitForCompletion,[PSCustomObject]$RestResponse) {
            if ($WaitForCompletion.IsPresent) {
                # if the wait for completion flag is given, the output will be different, we will wait here
                # we will use the built-in function to check status
                $ElapsedTime = 0
                do {
                    $RequestResponse = Get-vRARequest -RequestId $RestResponse.id
                    if ($RequestResponse.Status -eq "FINISHED") {
                        foreach ($Resource in $RequestResponse.Resources) {
                            $Record = Invoke-vRARestMethod -URI "$Resource" -Method GET
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


                switch ($PsCmdlet.ParameterSetName) {

                    # --- Resize by Flavor, do not need cpu and memory
                    'ResizeFlavorById' {

                        foreach ($MachineId in $Id) {
                            if ($Force.IsPresent -or $PsCmdlet.ShouldProcess($MachineId)) {
                                $RestResponse = Invoke-vRARestMethod -URI "$APIUrl`/$MachineId/operations/resize?name=$Flavor" -Method POST
                                CalculateOutput $CompletionTimeout $WaitForCompletion $RestResponse
                            }
                        }
                        break
                    }

                    # --- Resize by Flavor, do not need cpu and memory
                    'ResizeFlavorByName' {

                        foreach ($Machine in $Name) {
                            if ($Force.IsPresent -or $PsCmdlet.ShouldProcess($Machine)) {
                            $MachineResponse = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$Machine'`&`$select=id" -Method GET
                            $MachineId = $MachineResponse.content[0].Id

                            $RestResponse = Invoke-vRARestMethod -URI "$APIUrl`/$MachineId/operations/resize?name=$Flavor" -Method POST
                            CalculateOutput $CompletionTimeout $WaitForCompletion $RestResponse
                            }
                        }
                        break
                    }

                    # --- Resize with cpu and memory for given machine by its id
                    'ResizeById' {

                        foreach ($MachineId in $Id) {
                            if ($Force.IsPresent -or $PsCmdlet.ShouldProcess($MachineId)) {
                                $RestResponse = Invoke-vRARestMethod -URI "$APIUrl`/$MachineId/operations/resize?memoryInMB=$Memory`&cpuCount=$CPU" -Method POST
                                CalculateOutput $CompletionTimeout $WaitForCompletion $RestResponse
                            }
                        }
                        break
                    }

                    # --- Resize with cpu and memory for given machine by its name
                    'ResizeByName' {

                        foreach ($Machine in $Name) {
                            if ($Force.IsPresent -or $PsCmdlet.ShouldProcess($Machine)) {
                                $MachineResponse = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$Machine'`&`$select=id" -Method GET
                                $MachineId = $MachineResponse.content[0].Id

                                $RestResponse = Invoke-vRARestMethod -URI "$APIUrl`/$MachineId/operations/resize?memoryInMB=$Memory`&cpuCount=$CPU" -Method POST
                                CalculateOutput $CompletionTimeout $WaitForCompletion $RestResponse
                            }
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
