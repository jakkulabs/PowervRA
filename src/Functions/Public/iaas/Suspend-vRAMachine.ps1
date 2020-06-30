function Suspend-vRAMachine {
    <#
        .SYNOPSIS
        Suspend a vRA Machine

        .DESCRIPTION
        Suspend a vRA Machine

        .PARAMETER Id
        The ID of the vRA Machine

        .PARAMETER Name
        The Name of the vRA Machine

        .PARAMETER WaitForCompletion
        If this flag is added, this function will wait for the suspend operation to complete

        .PARAMETER CompletionTimeout
        The default of this paramter is 2 minutes (120 seconds), but this parameter can be overriden here

        .PARAMETER Force
        Force this change

        .OUTPUTS
        System.Management.Automation.PSObject.

        .EXAMPLE
        Suspend-vRAMachine -Id 'b1dd48e71d74267559bb930934470'

        .EXAMPLE
        Suspend-vRAMachine -Name 'iaas01'

        .EXAMPLE
        Suspend-vRAMachine -Name 'iaas01' -WaitForCompletion

        .EXAMPLE
        Suspend-vRAMachine -Name 'iaas01' -WaitForCompletion -CompletionTimeout 300

    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High', DefaultParameterSetName="SuspendByName")][OutputType('System.Management.Automation.PSObject')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'WaitForCompletion',Justification = 'False positive as rule does not scan child scopes')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'CompletionTimeout',Justification = 'False positive as rule does not scan child scopes')]

        Param (

            [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="SuspendById")]
            [ValidateNotNullOrEmpty()]
            [String[]]$Id,

            [Parameter(Mandatory=$true,ParameterSetName="SuspendByName")]
            [ValidateNotNullOrEmpty()]
            [String[]]$Name,

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
                    $elapsedTime = 0
                    do {
                        $RequestResponse = Get-vRARequest -RequestId $RestResponse.id
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

                        # --- Suspend the given machine by its id
                        'SuspendById' {

                            foreach ($machineId in $Id) {
                                if ($Force.IsPresent -or $PsCmdlet.ShouldProcess($machineid)) {
                                    $RestResponse = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/suspend" -Method POST
                                    CalculateOutput $CompletionTimeout $WaitForCompletion $RestResponse
                                }
                            }
                            break
                        }

                        # --- Suspend the given machine by its name
                        'SuspendByName' {

                            foreach ($machine in $Name) {
                                if ($Force.IsPresent -or $PsCmdlet.ShouldProcess($machine)) {
                                    $machineResponse = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$machine'`&`$select=id" -Method GET
                                    $machineId = $machineResponse.content[0].Id

                                    $RestResponse = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/suspend" -Method POST
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
