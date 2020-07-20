function Get-vRAOnboardingDeployment {
<#
    .SYNOPSIS
    Get a vRA OnboardingDeployment.

    .DESCRIPTION
    Get a vRA OnboardingDeployment.

    .PARAMETER Id
    The ID of the OnboardingDeployment

    .PARAMETER Name
    The Name of the OnboardingDeployment

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAOnboardingDeployment

    .EXAMPLE
    Get-vRAOnboardingDeployment -Id '247d9305a4231275581a098553c26'

    .EXAMPLE
    Get-vRAOnboardingDeployment -Name 'Test OnboardingDeployment'

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name
    )

    Begin {
        $APIUrl = '/relocation/onboarding/deployment'

        function CalculateOutput($ResponseObject) {

            $DocumentSelfLink = $ResponseObject.documentSelfLink
            $OnboardingDeploymentId = ($DocumentSelfLink -split "/")[-1]

            [PSCustomObject] @{

                Name = $ResponseObject.name
                Id = $OnboardingDeploymentId
                PlanLink = $ResponseObject.planLink
                ConsumerDeploymentLink = $ResponseObject.consumerDeploymentLink
                DocumentSelfLink = $DocumentSelfLink
            }
        }
    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Onboarding Deployment by id
                'ById' {

                    foreach ($OnboardingDeploymentId in $Id){

                        $URI = "$($APIUrl)/$($OnboardingDeploymentId)"

                        $OnboardingDeployment= Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        CalculateOutput $OnboardingDeployment
                    }

                    break
                }
                # --- Get Onboarding Deployment by name
                'ByName' {

                    $URI = "$($APIUrl)?`$expand=true"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    foreach ($OnboardingDeploymentName in $Name){

                        $MatchedOnboardingDeployment = $false

                        foreach ($Document in $Response.documentLinks){

                            $OnboardingDeployment = $Response.documents.$document

                            if ($OnboardingDeployment.name -eq $OnboardingDeploymentName){

                                $MatchedOnboardingDeployment = $true
                                CalculateOutput $OnboardingDeployment
                            }
                        }

                        if (!$MatchedOnboardingDeployment) {

                            throw "Could not find Onboarding Deployment with name: $($OnboardingDeploymentName)"
                        }
                    }

                    break
                }
                # --- No parameters passed so return all Onboarding Deployments
                'Standard' {

                    $URI = "$($APIUrl)?`$expand=true"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    foreach ($Document in $Response.documentLinks){

                        $OnboardingDeployment = $Response.documents.$document

                        CalculateOutput $OnboardingDeployment
                    }
                }
            }
        }
        catch [Exception]{

            throw
        }
    }

    End {

    }
}