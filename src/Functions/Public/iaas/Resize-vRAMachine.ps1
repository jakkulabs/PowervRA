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

        function CalculateOutput {
            if ($WaitForCompletion) {
                # if the wait for completion flag is given, the output will be different, we will wait here
                # we will use the built-in function to check status
                $elapsedTime = 0
                do {
                    $RequestResponse = Get-vRARequest -RequestId $Response.id
                    if ($RequestResponse.Status -eq "FINISHED") {
                        foreach ($resource in $RequestResponse.Resources) {
                            $Record = Invoke-vRARestMethod -URI "$resource" -Method GET
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
                    $elapsedTime += 5
                    Start-Sleep -Seconds 5
                } while ($elapsedTime -lt $CompletionTimeout)

                if ($elapsedTime -gt $CompletionTimeout -or $elapsedTime -eq $CompletionTimeout) {
                    # we have errored out
                    [PSCustomObject]@{
                        Name = $Response.name
                        Progress = $Response.progress
                        Resources = $Response.resources
                        RequestId = $Response.id
                        Message = "We waited for completion, but we hit a timeout at $CompletionTimeout seconds. You may use Get-vRARequest -RequestId $($Response.id) to continue checking status. Here was the original response: $($Response.message)"
                        RequestStatus = $Response.status
                    }
                }
            } else {
                [PSCustomObject]@{
                    Name = $Response.name
                    Progress = $Response.progress
                    Resources = $Response.resources
                    RequestId = $Response.id
                    Message = $Response.message
                    RequestStatus = $Response.status
                }
            }
        }
    }
    Process {

        try {


                switch ($PsCmdlet.ParameterSetName) {

                    # --- Resize by Flavor, do not need cpu and memory
                    'ResizeFlavorById' {

                        foreach ($machineId in $Id) {
                            if ($Force -or $PsCmdlet.ShouldProcess($machineId)) {
                                $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/resize?name=$Flavor" -Method POST
                                CalculateOutput
                            }
                        }
                        break
                    }

                    # --- Resize by Flavor, do not need cpu and memory
                    'ResizeFlavorByName' {

                        foreach ($machine in $Name) {
                            if ($Force -or $PsCmdlet.ShouldProcess($machine)) {
                            $machineResponse = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$machine'`&`$select=id" -Method GET
                            $machineId = $machineResponse.content[0].Id

                            $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/resize?name=$Flavor" -Method POST
                            CalculateOutput
                            }
                        }
                        break
                    }

                    # --- Resize with cpu and memory for given machine by its id
                    'ResizeById' {

                        foreach ($machineId in $Id) {
                            if ($Force -or $PsCmdlet.ShouldProcess($machineId)) {
                                $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/resize?memoryInMB=$Memory`&cpuCount=$CPU" -Method POST
                                CalculateOutput
                            }
                        }
                        break
                    }

                    # --- Resize with cpu and memory for given machine by its name
                    'ResizeByName' {

                        foreach ($machine in $Name) {
                            if ($Force -or $PsCmdlet.ShouldProcess($machine)) {
                                $machineResponse = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$machine'`&`$select=id" -Method GET
                                $machineId = $machineResponse.content[0].Id

                                $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/resize?memoryInMB=$Memory`&cpuCount=$CPU" -Method POST
                                CalculateOutput
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
