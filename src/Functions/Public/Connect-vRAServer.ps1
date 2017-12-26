function Connect-vRAServer {
<#
    .SYNOPSIS
    Connect to a vRA Server

    .DESCRIPTION
    Connect to a vRA Server and generate a connection object with Servername, Token etc

    .PARAMETER Server
    vRA Server to connect to

    .PARAMETER Tenant
    Tenant to connect to

    .PARAMETER Username
    Username to connect with

    .PARAMETER Password
    Password to connect with

    .PARAMETER Credential
    Credential object to connect with

    .PARAMETER IgnoreCertRequirements
    Ignore requirements to use fully signed certificates

    .PARAMETER SslProtocol
    Alternative Ssl protocol to use from the default
    Requires vRA 7.x and above
    Windows PowerShell: Ssl3, Tls, Tls11, Tls12
    PowerShell Core: Tls, Tls11, Tls12

    .INPUTS
    System.String
    System.SecureString
    Management.Automation.PSCredential
    Switch

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Connect-vRAServer -Server vraappliance01.domain.local -Tenant Tenant01 -Credential (Get-Credential)

    .EXAMPLE
    $SecurePassword = ConvertTo-SecureString “P@ssword” -AsPlainText -Force
    Connect-vRAServer -Server vraappliance01.domain.local -Tenant Tenant01 -Username TenantAdmin01 -Password $SecurePassword -IgnoreCertRequirements
#>
[CmdletBinding(DefaultParametersetName="Username")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory=$true,ParameterSetName="Username")]
        [Parameter(Mandatory=$true,ParameterSetName="Credential")]        
        [ValidateNotNullOrEmpty()]
        [String]$Server,

        [parameter(Mandatory=$true,ParameterSetName="Username")]
        [Parameter(Mandatory=$true,ParameterSetName="Credential")]   
        [ValidateNotNullOrEmpty()]
        [String]$Tenant = "vsphere.local",

        [parameter(Mandatory=$true,ParameterSetName="Username")]
        [Parameter(Mandatory=$true,ParameterSetName="Credential")]   
        [ValidateNotNullOrEmpty()]
        [String]$Username,

        [parameter(Mandatory=$true,ParameterSetName="Username")]
        [ValidateNotNullOrEmpty()]
        [SecureString]$Password,

        [Parameter(Mandatory=$true,ParameterSetName="Credential")]
        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]$Credential,

        [parameter(Mandatory=$true,ParameterSetName="Username")]
        [Parameter(Mandatory=$true,ParameterSetName="Credential")]   
        [Switch]$IgnoreCertRequirements,

        [parameter(Mandatory=$true,ParameterSetName="Username")]
        [Parameter(Mandatory=$true,ParameterSetName="Credential")]   
        [ValidateSet('Ssl3', 'Tls', 'Tls11', 'Tls12')]
        [String]$SslProtocol,

        [Parameter(Mandatory=$true,ParameterSetName="Profile")]
        [ValidateNotNullOrEmpty()]
        [String]$Profile
    )

    if ($PSCmdlet.ParameterSetName -eq "Profile"){

        # --- Root is always going to be in the users profile
        $ProfilePath = "$ENV:USERPROFILE\.PowervRA"
        $ProfileConfigurationPath = "$ProfilePath\$($Profile)_profile.json"

        # --- If profile exists, direct user to New-vRAConectionProfile
        if (!(Test-Path -Path $ProfileConfigurationPath)) {
            throw "A profile called $Profile does not exist. Try creating it first with New-vRAConnectionProfile"
        }

        $ProfileObject = Get-Content -Path $ProfileConfigurationPath | ConvertFrom-Json

        $PSBoundParameters.Add("Server", $ProfileObject.Server)
        $PSBoundParameters.Add("Tenant", $ProfileObject.Tenant)
        $PSBoundParameters.Add("Credential", (Get-Credential -Message "Connect to $($ProfileObject.Server)" -UserName $ProfileObject.Username))
        $PSBoundParameters.Add("IgnoreCertRequirements", $ProfileObject.IgnoreCertRequirements)
        $PSBoundParameters.Add("SslProtocol", $ProfileObject.SslProtocol)        
    }


    # --- Default Signed Certificates to true
    # --- Handle untrusted certificates if necessary
    $SignedCertificates = $true

    if ($PSBoundParameters.ContainsKey("IgnoreCertRequirements") ){

        if ($PSVersionTable.PSEdition -eq "Desktop" -or !$PSVersionTable.PSEdition) {

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
        
        if ($PSVersionTable.PSEdition -eq "Desktop" -or !$PSVersionTable.PSEdition) {

            $CurrentProtocols = ([System.Net.ServicePointManager]::SecurityProtocol).toString() -split ', '
            if (!($SslProtocol -in $CurrentProtocols)){
            
                [System.Net.ServicePointManager]::SecurityProtocol += [System.Net.SecurityProtocolType]::$($SslProtocol)
            }
        }
        $SslProtocolResult = $SslProtocol
    }

    # --- Convert Secure Credentials to a format for sending in the JSON payload
    if ($PSBoundParameters.ContainsKey("Credential")){

        $Username = $Credential.UserName
        $JSONPassword = $Credential.GetNetworkCredential().Password
    }

    if ($PSBoundParameters.ContainsKey("Password")){

        $JSONPassword = (New-Object System.Management.Automation.PSCredential("username", $Password)).GetNetworkCredential().Password
    }

    try {

        # --- Create Invoke-RestMethod Parameters
        $JSON = @"
        {
            "username":"$($Username)",
            "password":"$($JSONPassword)",
            "tenant":"$($Tenant)"
        }
"@

        $Params = @{

            Method = "POST"
            URI = "https://$($Server)/identity/api/tokens"
            Headers = @{
                "Accept"="application/json";
                "Content-Type" = "application/json";
            }
            Body = $JSON

        }

        if ((!$SignedCertificate) -and ($PSVersionTable.PSEdition -eq "Core")) {

            $Params.Add("SkipCertificateCheck", $true)

        }

        if (($SslProtocolResult -ne 'Default') -and ($PSVersionTable.PSEdition -eq "Core")) {
            
            $Params.Add("SslProtocol", $SslProtocol)

        }

        $Response = Invoke-RestMethod @Params

        # --- Create Output Object
        $Global:vRAConnection = [PSCustomObject] @{

            Server = "https://$($Server)"
            Token = $Response.id
            Tenant = $Null
            Username = $Username
            APIVersion = $Null
            SignedCertificates = $SignedCertificates
            SslProtocol = $SslProtocolResult
        }

        # --- Update vRAConnection with tenant and api version
        $Global:vRAConnection.Tenant = (Get-vRATenant -Id $Tenant).id
        $Global:vRAConnection.APIVersion = (Get-vRAVersion).APIVersion

    }
    catch [Exception]{

        throw

    }

    Write-Output $vRAConnection

}