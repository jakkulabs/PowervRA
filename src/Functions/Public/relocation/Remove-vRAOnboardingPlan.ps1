function Remove-vRAOnboardingPlan {
    <#
        .SYNOPSIS
        Remove an Onboarding Plan

        .DESCRIPTION
        Remove an Onboarding Plan

        .PARAMETER Id
        The id of the Onboarding Plan

        .PARAMETER Name
        The name of the Onboarding Plan

        .INPUTS
        System.String

        .EXAMPLE
        Remove-vRAOnboardingPlan -Name OnboardingPlan1

        .EXAMPLE
        Remove-vRAOnboardingPlan -Id 'b210b3044578447559e3b3bad52de'

        .EXAMPLE
        Get-vRAOnboardingPlan -Name OnboardingPlan1 | Remove-vRAOnboardingPlan

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

                    foreach ($OnboardingPlanId in $Id) {

                        if ($PSCmdlet.ShouldProcess($OnboardingPlanId)){

                            $URI = "/relocation/onboarding/plan/$($OnboardingPlanId)"

                            Invoke-vRARestMethod -Method DELETE -URI "$($URI)" -Verbose:$VerbosePreference | Out-Null
                        }
                    }

                    break
                }

                'ByName' {

                    foreach ($OnboardingPlanName in $Name) {

                        if ($PSCmdlet.ShouldProcess($OnboardingPlanName)){

                            $OnboardingPlanId = (Get-vRAOnboardingPlan -Name $OnboardingPlanName).id
                            $URI = "/relocation/onboarding/plan/$($OnboardingPlanId)"

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