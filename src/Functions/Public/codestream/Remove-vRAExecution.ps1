function Remove-vRAExecution {
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
        Remove-vRAExecution -Id '4b3bd194-9b5f-40fd-9ed0-58d997237999'

        .EXAMPLE
        Get-vRAExecution -Pipeline 'My Pipeline' | Remove-vRAExecution

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

                    foreach ($executionId in $Id) {

                        if ($PSCmdlet.ShouldProcess($executionId)){

                            $URI = "/pipeline/api/executions/$($executionId)"

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