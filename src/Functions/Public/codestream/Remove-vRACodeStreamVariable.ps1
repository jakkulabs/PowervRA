function Remove-vRACodeStreamVariable {
    <#
        .SYNOPSIS
        Remove a vRA Code Stream Variable

        .DESCRIPTION
        Remove a vRA Code Stream Variable

        .PARAMETER Id
        The Id of the vRA Code Stream Variable

        .INPUTS
        System.String

        .EXAMPLE
        Remove-vRACodeStreamVariable -Id '4b3bd194-9b5f-40fd-9ed0-58d997237999'

        .EXAMPLE
         -Variable 'My Variable' | Remove-vRACodeStreamVariable

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

                    foreach ($variableId in $Id) {

                        if ($PSCmdlet.ShouldProcess($variableId)){

                            $URI = "/pipeline/api/variables/$($variableId)"

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