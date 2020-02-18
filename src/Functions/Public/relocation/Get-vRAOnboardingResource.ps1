function Get-vRAOnboardingResource {
<#
    .SYNOPSIS
    Get a vRA Onboarding Resource

    .DESCRIPTION
    Get a vRA Onboarding Resource

    .PARAMETER Id
    The ID of the Onboarding Resource

    .PARAMETER Name
    The Name of the Onboarding Resource

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAOnboardingResource

    .EXAMPLE
    Get-vRAOnboardingResource -Id '0b8c2def-b2bc-3fb1-a88f-0621dacdab71'

    .EXAMPLE
    Get-vRAOnboardingResource -Name 'Test OnboardingResource'

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

    begin {
        $APIUrl = '/relocation/onboarding/resource'

        function CalculateOutput {

            $DocumentSelfLink = $OnboardingResource.documentSelfLink
            $OnboardingResourceId = ($DocumentSelfLink -split "/")[-1]

            [PSCustomObject] @{

                Name = $OnboardingResource.resourceName
                Id = $OnboardingResourceId
                PlanLink = $OnboardingResource.planLink
                ResourceLink = $OnboardingResource.resourceLink
                DeploymentLink = $OnboardingResource.deploymentLink
                TagLinks = $OnboardingResource.tagLinks
                RuleLinks = $OnboardingResource.ruleLinks
                CreatedTimeMicros = $OnboardingResource.createdTimeMicros
                DocumentSelfLink = $DocumentSelfLink
            }
        }
    }

    process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Onboarding Resource by Id
                'ById' {

                    foreach ($OnboardingResourceId in $Id){

                        $URI = "$($APIUrl)/$($OnboardingResourceId)"
                        $OnboardingResource= Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        CalculateOutput
                    }

                    break
                }
                # --- Get Onboarding Resource by Name
                'ByName' {

                    $URI = "$($APIUrl)?`$expand=true"
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    foreach ($OnboardingResourceName in $Name){

                        $MatchedOnboardingResource = $false

                        foreach ($Document in $Response.documentLinks){

                            $OnboardingResource = $Response.documents.$document

                            if ($OnboardingResource.resourceName -eq $OnboardingResourceName){

                                $MatchedOnboardingResource = $true
                                CalculateOutput
                            }
                        }

                        if (!$MatchedOnboardingResource) {

                            throw "Could not find Onboarding Resource with name: $($OnboardingResourceName)"
                        }
                    }

                    break
                }
                # --- No parameters passed so return all Onboarding Resources
                'Standard' {

                    $URI = "$($APIUrl)?`$expand=true"
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    foreach ($Document in $Response.documentLinks){

                        $OnboardingResource = $Response.documents.$document

                        CalculateOutput
                    }
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