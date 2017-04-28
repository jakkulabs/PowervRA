function Connect-vRAVAMI {
<#
    .SYNOPSIS
    Connect to a vRA Appliance
    
    .DESCRIPTION
    Connect to a vRA Appliance and generate a connection object.
    
    .PARAMETER Server
    vRA Appliance to connect to, does not need :5480 appended.

    .PARAMETER Password
    Root password to connect to the appliance with.

    .PARAMETER Credential
    Credential object to connect with.

    .PARAMETER IgnoreCertRequirements
    Ignore requirements to use trusted signed certificates.

    .INPUTS
    System.String
    Management.Automation.PSCredential

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    $SecurePassword = ConvertTo-SecureString "P@ssword" -AsPlainText -Force
    Connect-vRAVAMI -Server vra-01a.lab.local -Password $SecurePassword -IgnoreCertRequirements

    .EXAMPLE
    Connect-vRAVAMI -Server vra-01a.lab.local -Credential (Get-Credential)
#>
[CmdletBinding(DefaultParametersetName="Username")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Server,

    [parameter(Mandatory=$true,ParameterSetName="Username")]
    [ValidateNotNullOrEmpty()]
    [SecureString]$Password,

    [Parameter(Mandatory=$true,ParameterSetName="Credential")]
	[ValidateNotNullOrEmpty()]
	[Management.Automation.PSCredential]$Credential,

    [parameter(Mandatory=$false)]
    [Switch]$IgnoreCertRequirements
    )   

    # --- Check for PowerShell Core

    if ($PSVersionTable.PSEdition -eq "Core"){

        $ProgressPreference="SilentlyContinue"

    }

    # --- Default Signed Certificates to true
       
    $SignedCertificates = $true

    if ($PSBoundParameters.ContainsKey("IgnoreCertRequirements") ){

        if ($PSVersionTable.PSEdition -eq "Desktop" -or $PSVersionTable.PSEdition -eq $null) {

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

   # --- Convert Secure Credentials to a format for sending in the JSON payload
    if ($PSBoundParameters.ContainsKey("Credential")){

        $Username = $Credential.UserName
        $JSONPassword = $Credential.GetNetworkCredential().Password

    }

    if ($PSBoundParameters.ContainsKey("Password")){

        $JSONPassword = (New-Object System.Management.Automation.PSCredential("username", $Password)).GetNetworkCredential().Password

    }       
       
try {

    # --- Create Invoke-WebRequest Parameters

    $base64cred = [system.convert]::ToBase64String(
        [system.text.encoding]::UTF8.Getbytes(
            "root:$($JSONPassword)"
        )
    )

    $Params = @{

    Method = "GET"
    URI = "https://$($Server):5480/config/version"
    Headers = @{
        "Authorization"="Basic $($base64cred)";
        "Accept"="application/json";
        "Content-Type" = "application/json"
    }
    }
 
    # --- Run vRA REST Request

    if ((!$SignedCertificate) -and ($PSVersionTable.PSEdition -eq "Core")) {

        $Params.Add("SkipCertificateCheck", $true)

    }

    $Response = Invoke-WebRequest @Params
 
    # --- Create Output Object
                
    $Global:vRAVAMIConnection = [pscustomobject]@{                        
        Token = $base64cred          
        Appliance = "https://$($Server):5480"
        Username = $Username
        APIVersion = $Response
        SignedCertificates = $SignedCertificates
        Server = $Server
    }

}

catch [Exception]{ 

    Write-Host "The server provided returned a Status Code: $($_.Exception.Response.StatusCode.Value__)" -ForegroundColor Yellow
    if ($_.Exception.Response.StatusCode.Value__ -eq 404) {
        Write-Host "The server in question may be running a version lower than the configuration API supports (7.2)" -ForegroundColor Yellow

        }

    throw
}

    Write-Output $vRAVAMIConnection

}
