function Remove-vRAOnboardingDeployment {
    <#
        .SYNOPSIS
        Remove an Onboarding Deployment

        .DESCRIPTION
        Remove an Onboarding Deployment

        .PARAMETER Id
        The Id of the Onboarding Deployment

        .PARAMETER Name
        The name of the Onboarding Deployment

        .INPUTS
        System.String

        .EXAMPLE
        Remove-vRAOnboardingDeployment -Name OnboardingDeployment1

        .EXAMPLE
        Remove-vRAOnboardingDeployment -Id 'b210b3044578447559e3b3bad52de'

        .EXAMPLE
        Get-vRAOnboardingDeployment -Name OnboardingDeployment1 | Remove-vRAOnboardingDeployment

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

                    foreach ($OnboardingDeploymentId in $Id) {

                        if ($PSCmdlet.ShouldProcess($OnboardingDeploymentId)){

                            $URI = "/relocation/onboarding/deployment/$($OnboardingDeploymentId)"

                            Invoke-vRARestMethod -Method DELETE -URI "$($URI)" -Verbose:$VerbosePreference | Out-Null
                        }
                    }

                    break
                }

                'ByName' {

                    foreach ($OnboardingDeploymentName in $Name) {

                        if ($PSCmdlet.ShouldProcess($OnboardingDeploymentName)){

                            $OnboardingDeploymentId = (Get-vRAOnboardingDeployment -Name $OnboardingDeploymentName).id
                            $URI = "/relocation/onboarding/deployment/$($OnboardingDeploymentId)"

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