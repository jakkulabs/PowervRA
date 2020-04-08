function Restart-vRAMachine {
<#
    .SYNOPSIS
    Restart a vRA Machine

    .DESCRIPTION
    Restart a vRA Machine

    .PARAMETER Id
    The ID of the vRA Machine

    .PARAMETER Name
    The Name of the vRA Machine

    .PARAMETER WaitForCompletion
    If this flag is added, this function will wait for the power state of the machine to = ON. (note: machine may still be completing OS boot procedure when this function is complete)

    .PARAMETER CompletionTimeout
    The default of this paramter is 2 minutes (120 seconds), but this parameter can be overriden here

    .PARAMETER Force
    Force this change

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Restart-vRAMachine -Id 'b1dd48e71d74267559bb930934470'

    .EXAMPLE
    Restart-vRAMachine -Name 'iaas01'

    .EXAMPLE
    Restart-vRAMachine -Name 'iaas01' -WaitForCompletion

    .EXAMPLE
    Restart-vRAMachine -Name 'iaas01' -WaitForCompletion -CompletionTimeout 300

#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact="High", DefaultParameterSetName="ResetByName")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ResetById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ResetByName")]
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

                    # --- Restart the given machine by its id
                    'ResetById' {

                        foreach ($machineId in $Id) {
                                if ($Force -or $PsCmdlet.ShouldProcess($machineId)) {
                                $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/reset" -Method POST
                                CalculateOutput
                            }
                        }
                        break
                    }

                    # --- Restart the given machine by its name
                    'ResetByName' {

                        foreach ($machine in $Name) {
                            if ($Force -or $PsCmdlet.ShouldProcess($machine)) {
                                $machineResponse = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$machine'`&`$select=id" -Method GET
                                $machineId = $machineResponse.content[0].Id

                                $Response = Invoke-vRARestMethod -URI "$APIUrl`/$machineId/operations/reset" -Method POST
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
