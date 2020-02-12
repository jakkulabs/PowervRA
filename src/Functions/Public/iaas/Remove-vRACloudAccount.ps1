function Remove-vRACloudAccount {
    <#
        .SYNOPSIS
        Remove a Cloud Account

        .DESCRIPTION
        Remove a Cloud Account

        .PARAMETER Id
        The Id of the Cloud Account

        .PARAMETER Name
        The name of the Cloud Account

        .INPUTS
        System.String

        .EXAMPLE
        Remove-vRACloudAccount -Name CloudAccount1

        .EXAMPLE
        Remove-vRACloudAccount -Id '4b3bd194-9b5f-40fd-9ed0-58d997237999'

        .EXAMPLE
        Get-vRACloudAccount -Name CloudAccount1 | Remove-vRACloudAccount

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

                    foreach ($CloudAccountId in $Id) {

                        if ($PSCmdlet.ShouldProcess($CloudAccountId)){

                            $URI = "/iaas/api/cloud-accounts/$($CloudAccountId)"

                            Invoke-vRARestMethod -Method DELETE -URI "$($URI)" -Verbose:$VerbosePreference | Out-Null
                        }
                    }

                    break
                }

                'ByName' {

                    foreach ($CloudAccountName in $Name) {

                        if ($PSCmdlet.ShouldProcess($CloudAccountName)){

                            $CloudAccountId = (Get-vRACloudAccount -Name $CloudAccountName).id
                            $URI = "/iaas/api/cloud-accounts/$($CloudAccountId)"

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