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
        function CalculateOutput($ResponseObject) {

            [PSCustomObject] @{

                ExecutionId = $ResponseObject.executionId
                DocumentSelfLink = $ResponseObject.documentSelfLink
                PlanLink = $ResponseObject.planLink
                TaskInfo = $ResponseObject.taskInfo
                SubStage = $ResponseObject.subStage
                PlanValidated = $ResponseObject.planValidated
                BlueprintsValidated = $ResponseObject.blueprintsValidated
                DeploymentsValidated = $ResponseObject.deploymentsValidated
                MachinesValidated = $ResponseObject.machinesValidated
                DeploymentCount = $ResponseObject.deploymentCount
                RetryCount = $ResponseObject.retryCount
                FailedDeploymentCount = $ResponseObject.failedDeploymentCount
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

                            CalculateOutput($ExecuteOnboardingPlan)
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

                            CalculateOutput($ExecuteOnboardingPlan)
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

                            CalculateOutput($ExecuteOnboardingPlan)
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

                        CalculateOutput($ExecuteOnboardingPlan)
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