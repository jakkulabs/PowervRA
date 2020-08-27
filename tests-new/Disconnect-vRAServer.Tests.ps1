Describe "Disconnect-vRAServer" {

    BeforeAll {
        Remove-Module -Name PowervRA -Force -ErrorAction SilentlyContinue
        Import-Module -Name $ENV:BHProjectPath/Release/PowervRA/PowervRA.psm1 -Force
        . "$ENV:BHProjectPath/tests-new/Constants.ps1"

                # --- Arrange
                Mock Invoke-RestMethod {
                    return [PSCustomObject]@{
                        access_token  = $AccessToken
                        refresh_token = $RefreshToken
                    }
                } -Verifiable -ModuleName PowervRA

               Connect-vRAServer -Server $Server -ApiToken $ApiToken

    }


    It "Succesfully removes the vRAConnection script scope variable" {



        # --- Act / Assert
        Assert-VerifiableMock
        { Disconnect-vRAServer -Confirm:$false } | Should -Not -Throw
        { Disconnect-vRAServer -Confirm:$false } | Should -Throw
    }

    It "Fails when there is no vRAConnection script scope variable" {

        # --- Act / Assert
        { Disconnect-vRAServer -Confirm:$false } | Should -Throw "vRA Connection variable does not exist. Please run Connect-vRAServer first to create it"
    }

}
