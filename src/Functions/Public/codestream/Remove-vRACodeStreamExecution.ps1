function Remove-vRACodeStreamExecution {
    <#
        .SYNOPSIS
        Remove a vRA Code Stream Execution

        .DESCRIPTION
        Remove a vRA Code Stream Execution

        .PARAMETER Id
        The Id of the vRA Code Stream Execution

        .INPUTS
        System.String

        .EXAMPLE
        ReRemove-vRACodeStreamExecution -Id '4b3bd194-9b5f-40fd-9ed0-58d997237999'

        .EXAMPLE
        Get-vRACodeStreamExecution -Pipeline 'My Pipeline' | ReRemove-vRACodeStreamExecution

    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="ById")]

    Param (

    [parameter(Mandatory=$true, ValueFromPipelineByPropertyName, ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id

    )

    begin {}

    process {

        try {

            switch ($PSCmdlet.ParameterSetName) {

                'ById' {

                    foreach ($ExecutionId in $Id) {

                        if ($PSCmdlet.ShouldProcess($ExecutionId)){

                            $URI = "/pipeline/api/executions/$($ExecutionId)"

                            Invoke-vRARestMethod -Method DELETE -URI "$($URI)" -Verbose:$VerbosePreference | Out-Null
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
}
