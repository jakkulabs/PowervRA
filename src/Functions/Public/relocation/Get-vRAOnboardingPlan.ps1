﻿function Get-vRAOnboardingPlan {
<#
    .SYNOPSIS
    Get a vRA OnboardingPlan.

    .DESCRIPTION
    Get a vRA OnboardingPlan.

    .PARAMETER Id
    The ID of the OnboardingPlan

    .PARAMETER Name
    The Name of the OnboardingPlan

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAOnboardingPlan

    .EXAMPLE
    Get-vRAOnboardingPlan -Id '247d9305a4231275581a098553c26'

    .EXAMPLE
    Get-vRAOnboardingPlan -Name 'Test OnboardingPlan'

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
        $APIUrl = '/relocation/onboarding/plan'

        function CalculateOutput($ResponseObject) {

            $DocumentSelfLink = $ResponseObject.documentSelfLink
            $OnboardingPlanId = ($DocumentSelfLink -split "/")[-1]

            [PSCustomObject] @{

                Name = $ResponseObject.name
                Id = $OnboardingPlanId
                Status = $ResponseObject.status
                EndpointName = $ResponseObject.endpointName
                EndpointId = $ResponseObject.endpointId
                EndpointIds = $ResponseObject.endpointIds
                ProjectName = $ResponseObject.projectName
                ProjectId = $ResponseObject.projectId
                CreatedBy = $ResponseObject.createdBy
                EnableExtensibilityEvents = $ResponseObject.enableExtensibilityEvents
                OrganizationId = $ResponseObject.organizationId
                LastRunTimeMicros = $ResponseObject.lastRunTimeMicros
                NextRefreshTimeMicros = $ResponseObject.nextRefreshTimeMicros
                RefreshIntervalMicros = $ResponseObject.refreshIntervalMicros
                DocumentSelfLink = $DocumentSelfLink
            }
        }
    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Onboarding Plan by id
                'ById' {

                    foreach ($OnboardingPlanId in $Id){

                        $URI = "$($APIUrl)/$($OnboardingPlanId)"

                        $OnboardingPlan= Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        CalculateOutput $OnboardingPlan
                    }

                    break
                }
                # --- Get Onboarding Plan by name
                'ByName' {

                    $URI = "$($APIUrl)?`$expand=true"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    foreach ($OnboardingPlanName in $Name){

                        $MatchedOnboardingPlan = $false

                        foreach ($Document in $Response.documentLinks){

                            $OnboardingPlan = $Response.documents.$document

                            if ($OnboardingPlan.name -eq $OnboardingPlanName){

                                $MatchedOnboardingPlan = $true
                                CalculateOutput $OnboardingPlan
                            }
                        }

                        if (!$MatchedOnboardingPlan) {

                            throw "Could not find Onboarding Plan with name: $($OnboardingPlanName)"
                        }
                    }

                    break
                }
                # --- No parameters passed so return all Onboarding Plans
                'Standard' {

                    $URI = "$($APIUrl)?`$expand=true"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    foreach ($Document in $Response.documentLinks){

                        $OnboardingPlan = $Response.documents.$document

                        CalculateOutput $OnboardingPlan
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