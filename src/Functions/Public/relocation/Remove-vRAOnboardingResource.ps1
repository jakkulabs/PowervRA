function Remove-vRAOnboardingResource {
    <#
        .SYNOPSIS
        Remove a Onboarding Resource

        .DESCRIPTION
        Remove a Onboarding Resource

        .PARAMETER Id
        The Id of the Onboarding Resource

        .PARAMETER Name
        The Name of the Onboarding Resource

        .INPUTS
        System.String

        .EXAMPLE
        Remove-vRAOnboardingResource -Name OnboardingResource1

        .EXAMPLE
        Remove-vRAOnboardingResource -Id '81289f15-89e4-3580-k2s0-86cd3af25257'

        .EXAMPLE
        Get-vRAOnboardingResource -Name OnboardingResource1 | Remove-vRAOnboardingResource

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

                    foreach ($OnboardingResourceId in $Id) {

                        if ($PSCmdlet.ShouldProcess($OnboardingResourceId)){

                            $URI = "/relocation/onboarding/resource/$($OnboardingResourceId)"

                            Invoke-vRARestMethod -Method DELETE -URI "$($URI)" -Verbose:$VerbosePreference | Out-Null
                        }
                    }

                    break
                }

                'ByName' {

                    foreach ($OnboardingResourceName in $Name) {

                        if ($PSCmdlet.ShouldProcess($OnboardingResourceName)){

                            $OnboardingResourceId = (Get-vRAOnboardingResource -Name $OnboardingResourceName).id
                            $URI = "/relocation/onboarding/resource/$($OnboardingResourceId)"

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