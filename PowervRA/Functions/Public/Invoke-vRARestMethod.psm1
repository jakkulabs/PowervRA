function Invoke-vRARestMethod {
<#
    .SYNOPSIS
    Wrapper for Invoke-RestMethod with vRA specifics
    
    .DESCRIPTION
    Wrapper for Invoke-RestMethod with vRA specifics

    .PARAMETER Method
    REST Method: GET, POST, PUT or DELETE

    .PARAMETER URI
    API URI, e.g. /identity/api/tenants

    .PARAMETER Body
    REST Body in JSON format

    .PARAMETER Headers
    Optionally supply custom headers

    .INPUTS
    System.String
    Switch

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Invoke-vRARestMethod -Method GET -URI '/identity/api/tenants'

    .EXAMPLE
    $JSON = @"
        {
          "name" : "Tenant02",
          "description" : "This is Tenant02",
          "urlName" : "Tenant02",
          "contactEmail" : "test.user@tenant02.local",
          "id" : "Tenant02",
          "defaultTenant" : false,
          "password" : ""
        }
    "@

    Invoke-vRARestMethod -Method PUT -URI '/identity/api/tenants/Tenant02' -Body $JSON
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateSet("GET","POST","PUT","DELETE")]
    [String]$Method,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$URI,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Body,  
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [System.Collections.IDictionary]$Headers
    )   

# --- Test for existing connection to vRA
if (-not $Global:vRAConnection){

    throw "vRA Connection variable does not exist. Please run Connect-vRAServer first to create it"
}

# --- Work with Untrusted Certificates
if (-not ($Global:vRAConnection.SignedCertificates)){

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

    # --- Create Invoke-RestMethod Parameters
    $FullURI = "$($Global:vRAConnection.Server)$($URI)"

    if (!$PSBoundParameters.ContainsKey("Headers")){

        $Headers = @{

            "Accept"="application/json";
            "Content-Type" = "application/json";
            "Authorization" = "Bearer $($Global:vRAConnection.Token)";
        }
    }
    
    try { 
        if ($PSBoundParameters.ContainsKey("Body")) {
            
            $Response = Invoke-RestMethod -Method $Method -Headers $Headers -Uri $FullURI -Body $Body
        }
        else {

            $Response = Invoke-RestMethod -Method $Method -Headers $Headers -Uri $FullURI
        }
    }
    catch {
        
        throw
    }
    finally {

        # Workaround for bug in Invoke-RestMethod. Thanks to the PowerNSX guys for pointing this one out
        # https://bitbucket.org/nbradford/powernsx/src

        $ServicePoint = [System.Net.ServicePointManager]::FindServicePoint($FullURI)
        $ServicePoint.CloseConnectionGroup("") | Out-Null
    }

    Write-Output $Response
}