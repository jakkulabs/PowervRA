function Get-vRARequest {
    <#
        .SYNOPSIS
        Retrieve a vRA Request

        .DESCRIPTION
        Retrieve a vRA Request or list of requests

        .PARAMETER RequestId
        Optional - the id of the request you would like to view the detials

        .OUTPUTS
        System.Management.Automation.PSObject.

        .EXAMPLE
        Get-vRARequest

        .EXAMPLE
        Get-vRARequest -RequestId '305337a3-bb92-4638-a618-bf31e8cd1785'

    #>
    [CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

        Param (

            [Parameter(Mandatory=$false, ParameterSetName="ById")]
            [ValidateNotNullOrEmpty()]
            [String[]]$RequestId

        )
        Begin {

            $APIUrl = "/iaas/api/request-tracker"

            function CalculateOutput {

                if ($Response.content) {
                    foreach ($Record in $Response.content) {
                        [PSCustomObject]@{
                            Name = $Record.name
                            Progress = $Record.progress
                            Id = $Record.id
                            Status = $Record.status
                            Message = $Record.message
                            Resources = $Record.resources
                        }
                    }
                } else {
                    [PSCustomObject]@{
                        Name = $Response.name
                        Progress = $Response.progress
                        Id = $Response.id
                        Status = $Response.status
                        Message = $Response.message
                        Resources = $Response.resources
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
                        $Response = Invoke-vRARestMethod -URI "$APIUrl/$RequestId" -Method GET

                        CalculateOutput

                        break
                    }

                    default {
                        # --- Check to see if the DiskId's were optionally present
                        $Response = Invoke-vRARestMethod -URI "$APIUrl" -Method GET

                        CalculateOutput

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
