Describe "Connect-vRAServer" {

    BeforeAll {
        Remove-Module -Name PowervRA -Force -ErrorAction SilentlyContinue
        Import-Module -Name $ENV:BHProjectPath/Release/PowervRA/PowervRA.psm1 -Force
        . "$ENV:BHProjectPath/tests-new/Constants.ps1"

    }

    It "Returns a valid connection object" {

        Mock Invoke-RestMethod {
            return [PSCustomObject]@{
                access_token  = $AccessToken
                refresh_token = $RefreshToken
            }
        } -Verifiable -ModuleName PowervRA

        # --- Arrange
        $ExpectedConnectionObject = [PSCustomObject]@{
            Server             = "https://$($Server)"
            Token              = $AccessToken
            RefreshToken       = $RefreshToken
            APIVersion         = $Null
            SignedCertificates = $true
            SslProtocol        = "Default"
        }

        # --- Act
        $Connection = Connect-vRAServer -Server $Server -APIToken $ApiToken

        # --- Assert
        Assert-Equivalent -Actual $Connection -Expected $ExpectedConnectionObject
        Assert-VerifiableMock
    }

    It "Returns a valid refresh token when the server response contains 'refresh_token'" {

        # --- Arrange
        Mock Invoke-RestMethod {
            return [PSCustomObject]@{
                access_token  = $AccessToken
                refresh_token = $RefreshToken
            }
        } -Verifiable -ModuleName PowervRA

        # --- Act
        $Connection = Connect-vRAServer -Server $Server -APIToken $ApiToken

        # --- Assert
        $Connection.Token | Should -Be $AccessToken
        $Connection.RefreshToken | Should -Be $RefreshToken

        Assert-VerifiableMock
    }

    It "Returns the API token as the refresh token when the server response contains 'token'" {

        # --- Arrange
        Mock Invoke-RestMethod {
            return [PSCustomObject]@{
                token         = $AccessToken
                refresh_token = $ApiToken
            }
        } -Verifiable -ModuleName PowervRA

        # --- Act
        $Connection = Connect-vRAServer -Server $Server -APIToken $ApiToken


        # --- Assert
        $Connection | Should -Not -BeNullOrEmpty
        $Connection.Token | Should -Be $AccessToken
        $Connection.RefreshToken | Should -Be $ApiToken

        Assert-VerifiableMock
    }

    It "Fails when the username contains a '\' character" {

        # --- Arrange
        $IncorrectUsername = "Domain\Tenant01"

        # --- Act / Assert
        { Connect-vRAServer -Server $Server -Username $IncorrectUsername -Password $SecurePassword } |
        Should -Throw "The Username format DOMAIN\Username is not supported by the vRA REST API. Please use username@domain instead"
    }

    It "Fails when an invalid ssl protocol is passed as a parameter" {
        $IncorrectSslProtocol = "wrong"
        { Connect-vRAServer -Server $Server -Username $Username -Password $SecurePassword -SSlProtocol $IncorrectSslProtocol } |
        Should -Throw
    }

}
