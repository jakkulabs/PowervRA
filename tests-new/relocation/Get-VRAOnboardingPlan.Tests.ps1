Describe "Get-vRAOnboardingPlan" {

    BeforeAll {
        Remove-Module -Name PowervRA -Force -ErrorAction SilentlyContinue
        Import-Module -Name $ENV:BHProjectPath/Release/PowervRA/PowervRA.psm1 -Force
        .$ENV:BHProjectPath/tests-new/Constants.ps1

        Mock Invoke-vRARestMethod {
            return @(
                [PSCustomObject]@{
                    name                   = "onboarding_deployment_1"
                    planLink               = "https://$Server/planLink"
                    consumerDeploymentLink = "https://$Server/consumerDeploymentLink"
                    documentSelfLink       = "https://$Server/documentSelfLink/29f15a5e-7ece-4522-aaf8-111111111111"
                },
                [PSCustomObject]@{
                    name                   = "onboarding_deployment_2"
                    planLink               = "https://$Server/planLink"
                    consumerDeploymentLink = "https://$Server/consumerDeploymentLink"
                    documentSelfLink       = "https://$Server/documentSelfLink/29f15a5e-7ece-4522-aaf8-222222222222"
                }
            )
        } -Verifiable -ModuleName PowervRA

        Mock Invoke-RestMethod {
            return [PSCustomObject]@{
                access_token  = $AccessToken
                refresh_token = $RefreshToken
            }
        } -Verifiable -ModuleName PowervRA

        Connect-vRAServer -Server $Server -ApiToken $ApiToken

    }

    It "Accepts an array of ids from parameter input" {

        # --- Act / Assert
        { Get-vRAOnboardingPlan -Id "29f15a5e-7ece-4522-aaf8-111111111111", "29f15a5e-7ece-4522-aaf8-222222222222" } |
        Should -Not -Throw
        Assert-MockCalled -CommandName Invoke-vRARestMethod -Times 2 -ModuleName PowervRA
    }

    It "Accepts an array of ids from the pipeline" {

        # --- Act / Assert
        { "29f15a5e-7ece-4522-aaf8-111111111111", "29f15a5e-7ece-4522-aaf8-222222222222" | Get-vRAOnboardingPlan } |
        Should -Not -Throw

        Assert-MockCalled -CommandName Invoke-vRARestMethod -Times 2 -ModuleName PowervRA
    }


    It "Accepts an array named ids from the pipeline" {

        $OnboardingPlans = @(
            @{
                Id = "29f15a5e-7ece-4522-aaf8-111111111111"
            },
            @{
                Id = "29f15a5e-7ece-4522-aaf8-222222222222"
            }
        )

        { $OnboardingPlans | Get-vRAOnboardingPlan } | Should -Not -Throw
        Assert-MockCalled -CommandName Invoke-vRARestMethod -Times 2 -ModuleName PowervRA
    }

    It "Accepts an array of names from parameter input" {
        # --- Need to see a response body to write tests
        throw [System.NotImplementedException]::new()
    }

    It "Returns a matched onboarding plan" {
        # --- Need to see a response body to write tests
        throw [System.NotImplementedException]::new()
    }

    It "Fails when a matched onboarding plan cannot be found" {

        # --- Arrange
        $IncorrecOnboardingPlan = "wrong-plan"

        # --- Act / Assert
        { Get-vRAOnboardingPlan -Name $IncorrecOnboardingPlan } | Should -Throw "Could not find Onboarding Plan with name: $($IncorrecOnboardingPlan)"
        Assert-MockCalled -CommandName Invoke-vRARestMethod -Times 1 -ModuleName PowervRA
    }
}
