function New-vRAOnboardingDeployment {
<#
    .SYNOPSIS
    Create a vRA Onboarding Deployment

    .DESCRIPTION
    Create a vRA Onboarding Deployment

    .PARAMETER Name
    The name of the Onboarding Deployment

    .PARAMETER OnboardingPlanLink
    Link for the Onboarding Plan to associate with

    .PARAMETER JSON
    A JSON string with the body payload

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRAOnboardingDeployment -Name "TestOnboardingDeployment" -OnboardingPlanLink "/relocation/onboarding/plan/282dd58e8dcfc7559a0d225680a7"

    .EXAMPLE
    $JSON = @"

        {
            "name": "TestOnboardingDeployment",
            "planLink": "/relocation/onboarding/plan/282dd58e8dcfc7559a0d225680a7"
        }
"@

    $JSON | New-vRAOnboardingDeployment


#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$OnboardingPlanLink,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

    )

    begin {
        function CalculateOutput($ResponseObject) {

            $DocumentSelfLink = $ResponseObject.documentSelfLink
            $OnboardingDeploymentId = ($DocumentSelfLink -split "/")[-1]

            [PSCustomObject] @{

                Name = $ResponseObject.name
                Id = $OnboardingDeploymentId
                PlanLink = $ResponseObject.planLink
                DocumentSelfLink = $DocumentSelfLink
            }
        }
    }

    process {

        if ($PSBoundParameters.ContainsKey("JSON")) {

            $Data = ($JSON | ConvertFrom-Json)

            $Body = $JSON
            $Name = $Data.name
        }
        else {

            $Body = @"
                {
                    "name": "$($Name)",
                    "planLink": "$($OnboardingPlanLink)"
                }
"@
        }

        # --- Create new Onboarding Deployment
        try {
            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/relocation/onboarding/deployment"
                $OnboardingDeployment = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference

                CalculateOutput $OnboardingDeployment
            }
        }
        catch [Exception] {

            throw
        }
    }

    end {

    }
}