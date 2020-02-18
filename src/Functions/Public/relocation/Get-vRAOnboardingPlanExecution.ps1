function Get-vRAOnboardingPlanExecution {
<#
    .SYNOPSIS
    Get a vRA OnboardingPlanExecution

    .DESCRIPTION
    Get a vRA OnboardingPlanExecution

    .PARAMETER Id
    The ID of the OnboardingPlanExecution

    .PARAMETER ExecutionPlanLink
    The Execution Plan Link

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAOnboardingPlanExecution -Id 'ig885f86-0e2d-4157-r5d4-8cb42ce6dd84'

    .EXAMPLE
    Get-vRAOnboardingPlanExecution -ExecutionPlanLink '/relocation/api/wo/execute-plan/ig885f86-0e2d-4157-r5d4-8cb42ce6dd8'

#>
[CmdletBinding(DefaultParameterSetName="ById")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ByExecutionPlanLink")]
        [ValidateNotNullOrEmpty()]
        [String[]]$ExecutionPlanLink
    )

    begin {

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

                # --- Get Onboarding Plan Execution by Id
                'ById' {

                    foreach ($OnboardingPlanExecutionId in $Id){

                        $URI = "/relocation/api/wo/execute-plan/$($OnboardingPlanExecutionId)"

                        $ExecuteOnboardingPlan = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        CalculateOutput
                    }

                    break
                }
                # --- Get Onboarding Plan Execution by Name
                'ByExecutionPlanLink' {

                    foreach ($OnboardingPlanExecutionLink in $ExecutionPlanLink){

                        $ExecuteOnboardingPlan = Invoke-vRARestMethod -Method GET -URI $OnboardingPlanExecutionLink -Verbose:$VerbosePreference

                        CalculateOutput
                    }

                    break
                }
            }
        }
        catch [Exception]{

            throw
        }
    }
    end {

    }
}