function Connect-vRAServer {
<#
    .SYNOPSIS
    Connect to a vRA Server

    .DESCRIPTION
    Connect to a vRA Server and generate a connection object with Servername, Token etc

    .PARAMETER Server
    vRA Server to connect to

    .PARAMETER APIToken
    API Token to connect with

    .PARAMETER IgnoreCertRequirements
    Ignore requirements to use fully signed certificates

    .PARAMETER SslProtocol
    Alternative Ssl protocol to use from the default
    Requires vRA 7.x and above
    Windows PowerShell: Ssl3, Tls, Tls11, Tls12
    PowerShell Core: Tls, Tls11, Tls12

    .INPUTS
    System.String
    Switch

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Connect-vRAServer -Server api.mgmt.cloud.vmware.com -APIToken 'CuIKrjQgI6htiyRgIyd0ZtQM91fqg6AQyQhwPFJYgzBsaIKxKcWHLAGk81kknulQ'

    .EXAMPLE
    Connect-vRAServer -Server vraappliance01.domain.local -APIToken 'CuIKrjQgI6htiyRgIyd0ZtQM91fqg6AQyQhwPFJYgzBsaIKxKcWHLAGk81kknulQ' -IgnoreCertRequirements
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Server,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$APIToken,

        [parameter(Mandatory=$false)]
        [Switch]$IgnoreCertRequirements,

        [parameter(Mandatory=$false)]
        [ValidateSet('Ssl3', 'Tls', 'Tls11', 'Tls12')]
        [String]$SslProtocol
    )

    # --- Handle untrusted certificates if necessary
    $SignedCertificates = $true

    if ($PSBoundParameters.ContainsKey("IgnoreCertRequirements") ){

        if (!$IsCoreCLR) {

            if ( -not ("TrustAllCertsPolicy" -as [type])) {

                Add-Type @"
                using System.Net;
                using System.Security.Cryptography.X509Certificates;
                public class TrustAllCertsPolicy : ICertificatePolicy {
                    public bool CheckValidationResult(
                        ServicePoint srvPoint, X509Certificate certificate,
                        WebRequest request, int certificateProblem) {
                        return true;
                    }
                }
"@
            }
            [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

        }

        $SignedCertificates = $false

    }

    # --- Security Protocol
    $SslProtocolResult = 'Default'

    if ($PSBoundParameters.ContainsKey("SslProtocol") ){

        if (!$IsCoreCLR) {

            $CurrentProtocols = ([System.Net.ServicePointManager]::SecurityProtocol).toString() -split ', '
            if (!($SslProtocol -in $CurrentProtocols)){

                [System.Net.ServicePointManager]::SecurityProtocol += [System.Net.SecurityProtocolType]::$($SslProtocol)
            }
        }
        $SslProtocolResult = $SslProtocol
    }

    try {

        # --- Create Invoke-RestMethod Parameters
        $JSON = @{
            refreshToken = $APIToken
        } | ConvertTo-Json

        $Params = @{

            Method = "POST"
            URI = "https://$($Server)/iaas/login"
            Headers = @{
                "Accept"="application/json";
                "Content-Type" = "application/json";
            }
            Body = $JSON
        }

        if ((!$SignedCertificates) -and ($IsCoreCLR)) {

            $Params.Add("SkipCertificateCheck", $true)

        }

        if (($SslProtocolResult -ne 'Default') -and ($IsCoreCLR)) {

            $Params.Add("SslProtocol", $SslProtocol)

        }

        $Response = Invoke-RestMethod @Params

        # --- Create Output Object
        $Global:vRAConnection = [PSCustomObject] @{

            Server = "https://$($Server)"
            Token = $Response.token
            APIVersion = $Null
            SignedCertificates = $SignedCertificates
            SslProtocol = $SslProtocolResult
        }

        # --- Update vRAConnection with API version
        $Global:vRAConnection.APIVersion = (Get-vRAAPIVersion).APIVersion

    }
    catch [Exception]{

        throw

    }

    Write-Output $vRAConnection
}