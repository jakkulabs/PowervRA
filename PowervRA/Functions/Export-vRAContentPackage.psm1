function Export-vRAContentPackage {
<#
    .SYNOPSIS
    Export a vRA Content Package
    
    .DESCRIPTION
    Export a vRA Content Package
    
    .PARAMETER Id
    Specify the ID of a Content Package

    .PARAMETER Name
    Specify the Name of a Content Package

    .PARAMETER File
    Specify the Filename to export to

    .INPUTS
    System.String

    .OUTPUTS
    System.IO.FileInfo
    
    .EXAMPLE
    Export-vRAContentPackage -Id "b2d72c5d-775b-400c-8d79-b2483e321bae" -File C:\Packages\ContentPackage01.zip

    .EXAMPLE
    Export-vRAContentPackage -Name "ContentPackage01" -File C:\Packages\ContentPackage01.zip
#>
[CmdletBinding(DefaultParameterSetName="ById")][OutputType('System.IO.FileInfo')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String]$Id,         

    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,
    
    [parameter(Mandatory=$true,ValueFromPipeline=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$File 
    )

# --- Test for existing connection to vRA
if (-not $Global:vRAConnection){

    throw "vRA Connection variable does not exist. Please run Connect-vRAServer first to create it"
}
# --- Test for vRA API version
if ($Global:vRAConnection.APIVersion -lt 7){

    throw "$($MyInvocation.MyCommand) is not supported with vRA API version $($Global:vRAConnection.APIVersion)"
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

    try {    
  
        switch ($PsCmdlet.ParameterSetName) 
        { 
            "ById"  {           
                
                # --- Create Invoke-RestMethod Parameters
                $URI = "/content-management-service/api/packages/$($Id)"          
                 
                break
            }

            "ByName"  {                

                $ContentPackage = Get-vRAContentPackage -Name $Name

                # --- Create Invoke-RestMethod Parameters
                $URI = "/content-management-service/api/packages/$($ContentPackage.Id)"  
                
                break
            }
        }

        $FullURI = "$($Global:vRAConnection.Server)$($URI)"
        $Headers = @{

            "Accept"="application/zip";
            "Authorization" = "Bearer $($Global:vRAConnection.Token)";
        }

        # --- Run vRA REST Request
        $Response = Invoke-RestMethod -Method GET -Headers $Headers -URI $FullURI -OutFile $File
        
        # --- Output the result
        Get-ChildItem -Path $File  
    }
    catch [Exception]{

        throw
    }
}