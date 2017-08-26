function Invoke-vRAWebMethod {
<#
    .SYNOPSIS
    Wrapper for Invoke-WebRequest with vRA specifics

    .DESCRIPTION
    Wrapper for Invoke-WebRequest with vRA specifics

    .PARAMETER Method
    REST Method: GET, POST, PUT or DELETE

    .PARAMETER URI
    API URI, e.g. /identity/api/tenants

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
    Invoke-vRAWebRequest -Method GET -URI '/identity/api/tenants'

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

    Invoke-vRAWebMethod -Method PUT -URI '/identity/api/tenants/Tenant02' -Body $JSON
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true)]
        [ValidateSet("GET","POST","PUT","DELETE")]
        [String]$Method,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$URI,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Body,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Collections.IDictionary]$Headers,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$OutFile

    )

    # --- Test for existing connection to vRA
    if (-not $Global:vRAConnection){

        throw "vRA Connection variable does not exist. Please run Connect-vRAServer first to create it"
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

        # --- Set up default parmaeters
        $Params = @{

            Method = $Method
            Headers = $Headers
            Uri = $FullURI

        }

        if ($PSBoundParameters.ContainsKey("Body")) {

            $Params.Add("Body", $Body)

            # --- Log the payload being sent to the server
            Write-Debug -Message $Body

        } elseif ($PSBoundParameters.ContainsKey("OutFile")) {

            $Params.Add("OutFile", $OutFile)

        }

        # --- Support for PowerShell Core certificate checking
        if (!($Global:vRAConnection.SignedCertificates) -and ($PSVersionTable.PSEdition -eq "Core")) {

            $Params.Add("SkipCertificateCheck", $true);

        }

        # --- Invoke native REST method
        $Response = Invoke-WebRequest @Params

    }
    catch {

        throw

    }
    finally {

        if ($PSVersionTable.PSEdition -eq "Desktop" -or !$PSVersionTable.PSEdition) {

            # Workaround for bug in Invoke-RestMethod. Thanks to the PowerNSX guys for pointing this one out
            # https://bitbucket.org/nbradford/powernsx/src

            $ServicePoint = [System.Net.ServicePointManager]::FindServicePoint($FullURI)
            $ServicePoint.CloseConnectionGroup("") | Out-Null

        }

    }

    Write-Output $Response
}
