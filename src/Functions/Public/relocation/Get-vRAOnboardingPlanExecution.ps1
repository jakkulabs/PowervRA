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

                # --- Get Onboarding Plan Execution by Id
                'ById' {

                    foreach ($OnboardingPlanExecutionId in $Id){

                        $URI = "/relocation/api/wo/execute-plan/$($OnboardingPlanExecutionId)"

                        $ExecuteOnboardingPlan = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        CalculateOutput($ExecuteOnboardingPlan)
                    }

                    break
                }
                # --- Get Onboarding Plan Execution by Name
                'ByExecutionPlanLink' {

                    foreach ($OnboardingPlanExecutionLink in $ExecutionPlanLink){

                        $ExecuteOnboardingPlan = Invoke-vRARestMethod -Method GET -URI $OnboardingPlanExecutionLink -Verbose:$VerbosePreference

                        CalculateOutput($ExecuteOnboardingPlan)
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