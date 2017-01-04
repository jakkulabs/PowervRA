function Invoke-vRAVAMIRestMethod {
<#
    .SYNOPSIS
    Wrapper for Invoke-RestMethod with vRA VAMI specifics
    
    .DESCRIPTION
    Wrapper for Invoke-RestMethod with vRA VAMI specifics

    .PARAMETER Method
    REST Method: GET or PUT

    .PARAMETER URI
    API URI, e.g. /nodes/list

    .PARAMETER Body
    REST Body in JSON format

    .PARAMETER Headers
    Optionally supply custom headers

    .PARAMETER OutFile
    Save the results to a file

    .INPUTS
    System.String
    Switch

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Invoke-vRARestMethod -Method GET -URI '/execute/command/run-prereq/node{nodeId}'

    .EXAMPLE
    $JSON = @"
        {
          "ValidationMode": "true",
          "Components": "Website",
          "ApplyFixes": "true"
        }
    "@

    Invoke-vRARestMethod -Method PUT -URI '/execute/command/run-prereq/node{nodeId}' -Body $JSON
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateSet("GET","PUT")]
    [String]$Method,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$URI,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Body,  
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [System.Collections.IDictionary]$Headers,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$OutFile
    
    )   

# --- Test for existing connection to vRA VAMI
if (-not $Global:vRAVAMIConnection){

    throw "vRA VAMI Connection variable does not exist. Please run Connect-vRAVAMI first to create it"
}

# --- Work with Untrusted Certificates
if (-not ($Global:vRAVAMIConnection.SignedCertificates)){

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
    $FullURI = "$($Global:vRAVAMIConnection.Appliance)$($URI)"

    if (!$PSBoundParameters.ContainsKey("Headers")){

        $Headers = @{

            "Accept"="application/json";
            "Content-Type" = "application/json";
            "Authorization" = "Basic $($Global:vRAVAMIConnection.Token)";
        }
    }
    
    try { 
        if ($PSBoundParameters.ContainsKey("Body")) {
            
            $Response = Invoke-WebRequest -Method $Method -Headers $Headers -Uri $FullURI -Body $Body
        }
        elseif ($PSBoundParameters.ContainsKey("OutFile")) {

            $Response = Invoke-WebRequest -Method $Method -Headers $Headers -Uri $FullURI -OutFile $OutFile

        }
        else {

            $Response = Invoke-WebRequest -Method $Method -Headers $Headers -Uri $FullURI
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