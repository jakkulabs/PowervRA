function New-vRAOnboardingPlan {
<#
    .SYNOPSIS
    Create a vRA Onboarding Plan

    .DESCRIPTION
    Create a vRA Onboarding Plan

    .PARAMETER Name
    The name of the Onboarding Plan

    .PARAMETER CloudAccountId
    Cloud Account Id for the Onboarding Plan (Note: vRA Cloud API refers to it as endpointId)

    .PARAMETER ProjectId
    Project Id for the Onboarding Plan

    .PARAMETER JSON
    A JSON string with the body payload

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRAOnboardingPlan -Name "TestOnboardingPlan" -CloudAccountId "42fe38765a63bd755921a88814a14" -ProjectId "9f732951-2279-422a-8045-9b254d427100"

    .EXAMPLE
    $JSON = @"

        {
            "name": "TestOnboardingPlan",
            "endpointId": "42fe38765a63bd755921a88814a14",
            "projectId": "9f732951-2279-422a-8045-9b254d427100"
        }
"@

    $JSON | New-vRAOnboardingPlan


#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$CloudAccountId,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$ProjectId,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

    )

    Begin {
        function CalculateOutput($ResponseObject) {

            $DocumentSelfLink = $ResponseObject.documentSelfLink
            $OnboardingPlanId = ($DocumentSelfLink -split "/")[-1]

            [PSCustomObject] @{

                Name = $ResponseObject.name
                Id = $OnboardingPlanId
                Status = $ResponseObject.status
                EndpointId = $ResponseObject.endpointId
                EndpointIds = $ResponseObject.endpointIds
                ProjectId = $ResponseObject.projectId
                CreatedBy = $ResponseObject.createdBy
                EnableExtensibilityEvents = $ResponseObject.enableExtensibilityEvents
                OrganizationId = $ResponseObject.organizationId
                DocumentSelfLink = $DocumentSelfLink
            }
        }
    }

    Process {

        if ($PSBoundParameters.ContainsKey("JSON")) {

            $Data = ($JSON | ConvertFrom-Json)

            $Body = $JSON
            $Name = $Data.name
        }
        else {

            $Body = @"
                {
                    "name": "$($Name)",
                    "endpointId": "$($CloudAccountId)",
                    "projectId": "$($ProjectId)"
                }
"@
        }

        # --- Create new Onboarding Plan
        try {
            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/relocation/onboarding/plan"
                $OnboardingPlan = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference

                CalculateOutput $OnboardingPlan
            }
        }
        catch [Exception] {

            throw
        }
    }

    End {

    }
}