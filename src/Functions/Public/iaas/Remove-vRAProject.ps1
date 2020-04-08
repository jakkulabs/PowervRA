function Remove-vRAProject {
    <#
        .SYNOPSIS
        Remove a Cloud Project

        .DESCRIPTION
        Remove a Cloud Project

        .PARAMETER Id
        The Id of the Cloud Project

        .PARAMETER Name
        The Name of the Cloud Project

        .INPUTS
        System.String

        .EXAMPLE
        Remove-vRAProject -Name Project1

        .EXAMPLE
        Remove-vRAProject -Id '4b3bd194-9b5f-40fd-9ed0-58d997237999'

        .EXAMPLE
        Get-vRAProject -Name Project1 | Remove-vRAProject

    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="ById")]

    Param (

    [parameter(Mandatory=$true, ValueFromPipelineByPropertyName, ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,

    [parameter(Mandatory=$true, ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name

    )

    begin {}

    process {

        try {

            switch ($PSCmdlet.ParameterSetName) {

                'ById' {

                    foreach ($ProjectId in $Id) {

                        if ($PSCmdlet.ShouldProcess($ProjectId)){

                            $URI = "/iaas/api/projects/$($ProjectId)"

                            Invoke-vRARestMethod -Method DELETE -URI "$($URI)" -Verbose:$VerbosePreference | Out-Null
                        }
                    }

                    break
                }

                'ByName' {

                    foreach ($ProjectName in $Name) {

                        if ($PSCmdlet.ShouldProcess($ProjectName)){

                            $ProjectId = (Get-vRAProject -Name $ProjectName).id
                            $URI = "/iaas/api/projects/$($ProjectId)"

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