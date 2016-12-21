function Connect-vRAVAMI {
<#
    .SYNOPSIS
    Connect to a vRA Appliance
    
    .DESCRIPTION
    Connect to a vRA Appliance and generate a connection object with Servername, Token etc
    
    .PARAMETER Appliance
    vRA Appliance to connect to

    .PARAMETER Username
    Username to connect with

    .PARAMETER Password
    Password to connect with

    .PARAMETER Credential
    Credential object to connect with

    .PARAMETER IgnoreCertRequirements
    Ignore requirements to use fully signed certificates

    .INPUTS
    System.String
    Management.Automation.PSCredential
    Switch

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Connect-vRAAppliance -Appliance vraappliance01.domain.local -Username root -Password P@ssword -IgnoreCertRequirements

    .EXAMPLE
    Connect-vRAAppliance -Appliance vraappliance01.domain.local -Credential (Get-Credential)
#>
[CmdletBinding(DefaultParametersetName="Username")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Appliance,
    
    [parameter(Mandatory=$true,ParameterSetName="Username")]
    [ValidateNotNullOrEmpty()]
    [String]$Username,

    [parameter(Mandatory=$true,ParameterSetName="Username")]
    [ValidateNotNullOrEmpty()]
    [String]$Password,

    [Parameter(Mandatory=$true,ParameterSetName="Credential")]
	[ValidateNotNullOrEmpty()]
	[Management.Automation.PSCredential]$Credential,

    [parameter(Mandatory=$false)]
    [Switch]$IgnoreCertRequirements
    )       

# --- Work with Untrusted Certificates
if ($PSBoundParameters.ContainsKey("IgnoreCertRequirements")){

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
    $SignedCertificates = $false
}
else {

    $SignedCertificates = $true
}

if ($PSBoundParameters.ContainsKey("Credential")){

    $Username = $Credential.UserName
    $Password = $Credential.GetNetworkCredential().Password
}        
       
try {

    # --- Create Invoke-RestMethod Parameters
    $base64cred = [system.convert]::ToBase64String(
        [system.text.encoding]::UTF8.Getbytes(
            "$($Username):$($Password)"
        )
    )
    $Method = "GET"
    $URI = "https://$($Appliance):5480/config/version"
    $Headers = @{
        "Authorization"="Basic $($base64cred)";
        "Accept"="application/json";
        "Content-Type" = "application/json"
    }

 
    # --- Run vRA REST Request
    Write-Output $Method $URI $Headers
    $Response = Invoke-RestMethod -Method $Method -Uri $URI -Headers $Headers -ErrorAction Stop
    Write-Output $Response
      
    # --- Create Output Object
                
    $Global:vRAVAMIConnection = [pscustomobject]@{                        
        Token = $base64cred          
        Appliance = "https://$($Appliance):5480/config"
        Username = $Username
        APIVersion = $Response
        SignedCertificates = $SignedCertificates
    }
}
catch [Exception]{

    throw
}
    Write-Output $vRAVAMIConnection  
}
