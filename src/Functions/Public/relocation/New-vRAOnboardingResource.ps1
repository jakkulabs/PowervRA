function New-vRAOnboardingResource {
<#
    .SYNOPSIS
    Create a vRA Onboarding Resource

    .DESCRIPTION
    Create a vRA Onboarding Resource

    .PARAMETER Name
    The name of the Onboarding Resource

    .PARAMETER VMId
    The Id of the IaaS VM to associate the Onboarding Resource with

    .PARAMETER DeploymentLink
    Link to the Onboarding Deployment to associate the Onboarding Resource with

    .PARAMETER PlanLink
    Link to the Onboarding Plan to associate the Onboarding Resource with

    .PARAMETER RuleLinks
    Link(s) to the Onboarding Rule(s) to associate the Onboarding Resource with

    .PARAMETER JSON
    A JSON string with the body payload

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    $OnboardingResourceArguments = @{

        Name = 'TestOnboardingResource'
        VMId = 'ee7eeed1-b4e4-4143-a437-d3c0622bf9df'
        DeploymentLink = '/relocation/onboarding/deployment/5bc7eb75-r2d2-4c24-93ac-8c3p0d02f7f1'
        PlanLink = '/relocation/onboarding/plan/ecaak2s0-r5d4-4a79-b17b-27f13c7d3ff7'
        RuleLinks = '/relocation/onboarding/rule/include'
    }

    New-vRAOnboardingResource @OnboardingResourceArguments

    .EXAMPLE
    $JSON = @"

        {
            "deploymentLink": "/relocation/onboarding/deployment/5bc7eb75-r2d2-4c24-93ac-8c3p0d02f7f1",
            "planLink": "/relocation/onboarding/plan/ecaak2s0-r5d4-4a79-b17b-27f13c7d3ff7",
            "resourceLink": "/resources/compute/ee7eeed1-b4e4-4143-a437-d3c0622bf9df",
            "resourceName": "TestOnboardingResource",
            "ruleLinks": [
                "/relocation/onboarding/rule/include"
            ]
        }
"@

    $JSON | New-vRAOnboardingResource
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$VMId,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$DeploymentLink,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$PlanLink,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$RuleLinks,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

    )

    begin {
        function CalculateOutput {

            $DocumentSelfLink = $OnboardingResource.documentSelfLink
            $OnboardingResourceId = ($DocumentSelfLink -split "/")[-1]

            [PSCustomObject] @{

                Name = $OnboardingResource.resourceName
                Id = $OnboardingResourceId
                PlanLink = $OnboardingResource.planLink
                ResourceLink = $OnboardingResource.resourceLink
                DeploymentLink = $OnboardingResource.deploymentLink
                RuleLinks = $OnboardingResource.ruleLinks
                CreatedTimeMicros = $OnboardingResource.createdTimeMicros
                DocumentSelfLink = $DocumentSelfLink
            }
        }
    }

    process {

        if ($PSBoundParameters.ContainsKey("JSON")) {

            $Data = ($JSON | ConvertFrom-Json)

            $Body = $JSON
            $Name = $Data.resourceName
        }
        else {

            # Format RuleLinks with surrounding quotes and join into single string
            $RuleLinksAddQuotes = $RuleLinks | ForEach-Object {"`"$_`""}
            $RuleLinksFormatForBodyText = $RuleLinksAddQuotes -join ","

            $Body = @"
                {
                    "deploymentLink": "$($DeploymentLink)",
                    "planLink": "$($PlanLink)",
                    "resourceLink": "/resources/compute/$($VMId)",
                    "resourceName": "$($Name)",
                    "ruleLinks": [ $($RuleLinksFormatForBodyText) ]
                }
"@
        }

        # --- Create new Onboarding Resource
        try {
            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/relocation/onboarding/resource"
                $OnboardingResource = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference

                CalculateOutput
            }
        }
        catch [Exception] {

            throw
        }
    }
    end {

    }
}