﻿function Connect-vRAServer {
    <#
        .SYNOPSIS
        Connect to a vRA Server

        .DESCRIPTION
        Connect to a vRA Server and generate a connection object with Servername, Token etc

        .PARAMETER Server
        vRA Server to connect to

        .PARAMETER Username
        Username to connect with
        For domain accounts ensure to specify the Username in the format username@domain, not Domain\Username

        .PARAMETER Password
        Password to connect with

        .PARAMETER Credential
        Credential object to connect with
        For domain accounts ensure to specify the Username in the format username@domain, not Domain\Username

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
        $cred = Get-Credential
        Connect-vRAServer -Server vraappliance01.domain.local -Credential $cred

        .EXAMPLE
        $SecurePassword = ConvertTo-SecureString “P@ssword” -AsPlainText -Force
        Connect-vRAServer -Server vraappliance01.domain.local -Username TenantAdmin01 -Password $SecurePassword -IgnoreCertRequirements

        .EXAMPLE
        Connect-vRAServer -Server api.mgmt.cloud.vmware.com -APIToken 'CuIKrjQgI6htiyRgIyd0ZtQM91fqg6AQyQhwPFJYgzBsaIKxKcWHLAGk81kknulQ'

        .EXAMPLE
        Connect-vRAServer -Server vraappliance01.domain.local -APIToken 'CuIKrjQgI6htiyRgIyd0ZtQM91fqg6AQyQhwPFJYgzBsaIKxKcWHLAGk81kknulQ' -IgnoreCertRequirements
    #>
    [CmdletBinding(DefaultParameterSetName="Username")][OutputType('System.Management.Automation.PSObject')]

        Param (

            [parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [String]$Server,

            [parameter(Mandatory=$true,ParameterSetName="Username")]
            [ValidateNotNullOrEmpty()]
            [String]$Username,

            [parameter(Mandatory=$true,ParameterSetName="Username")]
            [ValidateNotNullOrEmpty()]
            [SecureString]$Password,

            [Parameter(Mandatory=$true,ParameterSetName="Credential")]
            [ValidateNotNullOrEmpty()]
            [Management.Automation.PSCredential]$Credential,

            [parameter(Mandatory=$true,ParameterSetName="APIToken")]
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

            # --- if a refresh token is supplied, we use iaas login
            if ($PSBoundParameters.ContainsKey("APIToken")){
                # -- iaas login with refresh token
                $URI = "https://$($Server)/iaas/login"

                # --- Create Invoke-RestMethod Parameters
                $JSON = @{
                    refreshToken = $APIToken
                } | ConvertTo-Json
            } else {
                # --- Convert Secure Credentials to a format for sending in the JSON payload
                if ($PSBoundParameters.ContainsKey("Credential")){

                    $Username = $Credential.UserName
                    $JSONPassword = $Credential.GetNetworkCredential().Password
                }

                if ($PSBoundParameters.ContainsKey("Password")){

                    $JSONPassword = (New-Object System.Management.Automation.PSCredential("username", $Password)).GetNetworkCredential().Password
                }

                # --- Test for a '\' in the username, e.g. DOMAIN\Username, not supported by the API
                if ($Username -match '\\'){

                    throw "The Username format DOMAIN\Username is not supported by the vRA REST API. Please use username@domain instead"
                }

                # --- Logging in with a domain
                if ($Username -match '@') {
                    # Log in using the advanced authentication API
                    $URI = "https://$($Server)/csp/gateway/am/idp/auth/login?access_token"
                    $User = $Username.split('@')[0]
                    $Domain = $Username.split('@')[1]
                    $JSON = @{
                        username = $User
                        password = $JSONPassword
                        domain = $Domain
                    } | ConvertTo-Json
                } else {
                    # -- Login with the basic authentication API
                    $URI = "https://$($Server)/csp/gateway/am/api/login?access_token"

                    # --- Create Invoke-RestMethod Parameters
                    $JSON = @{
                        username = $Username
                        password = $JSONPassword
                    } | ConvertTo-Json
                }
            }



            $Params = @{

                Method = "POST"
                URI = $URI
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

            if ('refresh_token' -in $Response.PSobject.Properties.Name) {
                $token = $Response.access_token
                $refreshToken = $Response.refresh_token
            }

            if ('token' -in $Response.PSobject.Properties.Name) {
                $token = $Response.token
                $refreshToken = $APIToken
            }

            # --- Create Output Object
            $Global:vRAConnection = [PSCustomObject] @{

                Server = "https://$($Server)"
                Token = $token
                RefreshToken = $refreshToken
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

