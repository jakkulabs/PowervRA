function Invoke-vRAOnboardingPlan {
<#
    .SYNOPSIS
    Execute a vRA Onboarding Plan

    .DESCRIPTION
    Execute a vRA Onboarding Plan

    .PARAMETER Name
    The Name of the Onboarding Plan

    .PARAMETER Id
    The Id of the Onboarding Plan

    .PARAMETER PlanLink
    The Link of the Onboarding Plan

    .PARAMETER JSON
    A JSON string with the body payload

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Invoke-vRAOnboardingPlan -Name "TestOnboardingPlan"

    .EXAMPLE
    Invoke-vRAOnboardingPlan -Id "ecaa2cf0-2f8c-4a79-r4d7-27f13c7d3ee6"

    .EXAMPLE
    Invoke-vRAOnboardingPlan -PlanLink "/relocation/onboarding/plan/ecaa2cf0-2f8c-4a79-r4d7-27f13c7d3ee6"

    .EXAMPLE
    $JSON = @"

        {
            "planLink": "/relocation/onboarding/plan/ecaa2cf0-2f8c-4a79-r4d7-27f13c7d3ee6"
        }
"@

    $JSON | Invoke-vRAOnboardingPlan
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="ById")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [Parameter(Mandatory=$true,ParameterSetName="ByPlanLink")]
        [ValidateNotNullOrEmpty()]
        [String[]]$PlanLink,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

    )

    begin {

        $URI = "/relocation/api/wo/execute-plan"
        function CalculateOutput {

            [PSCustomObject] @{

                ExecutionId = $ExecuteOnboardingPlan.executionId
                DocumentSelfLink = $ExecuteOnboardingPlan.documentSelfLink
                PlanLink = $ExecuteOnboardingPlan.planLink
                TaskInfo = $ExecuteOnboardingPlan.taskInfo
                SubStage = $ExecuteOnboardingPlan.subStage
                PlanValidated = $ExecuteOnboardingPlan.planValidated
                BlueprintsValidated = $ExecuteOnboardingPlan.blueprintsValidated
                DeploymentsValidated = $ExecuteOnboardingPlan.deploymentsValidated
                MachinesValidated = $ExecuteOnboardingPlan.machinesValidated
                DeploymentCount = $ExecuteOnboardingPlan.deploymentCount
                RetryCount = $ExecuteOnboardingPlan.retryCount
                FailedDeploymentCount = $ExecuteOnboardingPlan.failedDeploymentCount
            }
        }
    }

    process {
        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Execute Onboarding Plan by Id
                'ById' {

                    foreach ($OnboardingPlanId in $Id){

                        if ($PSCmdlet.ShouldProcess($OnboardingPlanId)){

                            $Body = @"
                            {
                                "planLink": "/relocation/onboarding/plan/$($OnboardingPlanId)"
                            }
"@
                            $ExecuteOnboardingPlan= Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference

                            CalculateOutput
                        }
                    }

                    break
                }
                # --- Execute Onboarding Plan by Name
                'ByName' {

                    foreach ($OnboardingPlanName in $Name){

                        if ($PSCmdlet.ShouldProcess($OnboardingPlanName)){

                            $OnboardingPlanLink = (Get-vRAOnboardingPlan -Name $OnboardingPlanName).DocumentSelfLink
                            $Body = @"
                            {
                                "planLink": "$($OnboardingPlanLink)"
                            }
"@
                            $ExecuteOnboardingPlan= Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference

                            CalculateOutput
                        }
                    }
                }
                # --- Execute Onboarding Plan by PlanLink
                'ByPlanLink' {

                    foreach ($OnboardingPlanLink in $PlanLink){

                        if ($PSCmdlet.ShouldProcess($OnboardingPlanLink)){

                            $Body = @"
                            {
                                "planLink": "$($OnboardingPlanLink)"
                            }
"@
                            $ExecuteOnboardingPlan= Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference

                            CalculateOutput
                        }
                    }
                }
                # --- Execute Onboarding Plan by JSON
                'JSON' {

                    $Data = ($JSON | ConvertFrom-Json)
                    $Body = $JSON
                    $OnboardingPlanLink = $Data.planLink

                    if ($PSCmdlet.ShouldProcess($OnboardingPlanLink)){

                        $ExecuteOnboardingPlan= Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference

                        CalculateOutput
                    }
                }
            }
        }
        catch [Exception] {

            throw
        }
    }
    end {

    }
}