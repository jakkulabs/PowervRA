. $PSScriptRoot/../Constants.ps1

function Connect-MockvRAServer {



    Mock Connect-vRAServer {
        $Script:vRAConnection = [PSCustomObject]@{
            Server             = "https://$($Server)"
            Token              = $AccessToken
            RefreshToken       = $RefreshToken
            APIVersion         = $Null
            SignedCertificates = $true
            SslProtocol        = "Default"
        }
    }

}
