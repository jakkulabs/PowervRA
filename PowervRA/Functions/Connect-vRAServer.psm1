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

    .INPUTS
    System.String
    Management.Automation.PSCredential
    Switch

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Connect-vRAServer -Server vraappliance01.domain.local -Tenant Tenant01 -Username TenantAdmin01 -Password P@ssword -IgnoreCertRequirements

    .EXAMPLE
    Connect-vRAServer -Server vraappliance01.domain.local -Tenant Tenant01 -Credential (Get-Credential)
#>
[CmdletBinding(DefaultParametersetName="Username")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Server,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Tenant = "vsphere.local",  
    
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
    $JSON = @"
    {
        "username":"$($Username)",
        "password":"$($Password)",
        "tenant":"$($Tenant)"
    }
"@
    $Method = "POST"
    $URI = "https://$($Server)/identity/api/tokens"
    $Headers = @{

        "Accept"="application/json";
        "Content-Type" = "application/json";
    }
    $Body = $JSON

    # --- Run vRA REST Request
    $Response = Invoke-RestMethod -Method $Method -Uri $URI -Headers $Headers -Body $Body -ErrorAction Stop
        
    # --- Create Output Object
                
    $Global:vRAConnection = [pscustomobject]@{                        
                    
        Server = "https://$($Server)"
        Token = $Response.id
        Tenant = $Null
        Username = $Username
        APIVersion = $Null
        SignedCertificates = $SignedCertificates
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