function Invoke-vRARestMethod {
<#
    .SYNOPSIS
    Wrapper for Invoke-RestMethod/Invoke-WebRequest with vRA specifics

    .DESCRIPTION
    Wrapper for Invoke-RestMethod/Invoke-WebRequest with vRA specifics

    .PARAMETER Method
    REST Method:
    Supported Methods: GET, POST, PUT,DELETE

    .PARAMETER URI
    API URI, e.g. /identity/api/tenants

    .PARAMETER Headers
    Optionally supply custom headers

    .PARAMETER Body
    REST Body in JSON format

    .PARAMETER OutFile
    Save the results to a file

    .PARAMETER WebRequest
    Use Invoke-WebRequest rather than the default Invoke-RestMethod

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

    Invoke-vRARestMethod -Method PUT -URI '/identity/api/tenants/Tenant02' -Body $JSON -WebRequest
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true, ParameterSetName="Standard")]
        [Parameter(Mandatory=$true, ParameterSetName="Body")]
        [Parameter(Mandatory=$true, ParameterSetName="OutFile")]
        [ValidateSet("GET","POST","PUT","DELETE")]
        [String]$Method,

        [Parameter(Mandatory=$true, ParameterSetName="Standard")]
        [Parameter(Mandatory=$true, ParameterSetName="Body")]
        [Parameter(Mandatory=$true, ParameterSetName="OutFile")]
        [ValidateNotNullOrEmpty()]
        [String]$URI,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [Parameter(Mandatory=$false, ParameterSetName="Body")]
        [Parameter(Mandatory=$false, ParameterSetName="OutFile")]
        [ValidateNotNullOrEmpty()]
        [System.Collections.IDictionary]$Headers,

        [Parameter(Mandatory=$false, ParameterSetName="Body")]
        [ValidateNotNullOrEmpty()]
        [String]$Body,

        [Parameter(Mandatory=$false, ParameterSetName="OutFile")]
        [ValidateNotNullOrEmpty()]
        [String]$OutFile,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [Parameter(Mandatory=$false, ParameterSetName="Body")]
        [Parameter(Mandatory=$false, ParameterSetName="OutFile")]
        [Switch]$WebRequest
    )

    # --- Test for existing connection to vRA
    if (-not $Global:vRAConnection){

        throw "vRA Connection variable does not exist. Please run Connect-vRAServer first to create it"
    }

    # --- Create Invoke-RestMethod Parameters
    $FullURI = "$($Global:vRAConnection.Server)$($URI)"

    # --- Add default headers if not passed
    if (!$PSBoundParameters.ContainsKey("Headers")){

        $Headers = @{

            "Accept"="application/json";
            "Content-Type" = "application/json";
            "Authorization" = "Bearer $($Global:vRAConnection.Token)";
        }
    }

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

    try {

        # --- Use either Invoke-WebRequest or Invoke-RestMethod
        if ($PSBoundParameters.ContainsKey("WebRequest")) {

            Invoke-WebRequest @Params
        }
        else {

            Invoke-RestMethod @Params
        }
    }
    catch {

        throw $_
    }
    finally {

        if ($PSVersionTable.PSEdition -eq "Desktop" -or !$PSVersionTable.PSEdition) {

            <#
                Workaround for bug in Invoke-RestMethod. Thanks to the PowerNSX guys for pointing this one out
                https://bitbucket.org/nbradford/powernsx/src
            #>
            $ServicePoint = [System.Net.ServicePointManager]::FindServicePoint($FullURI)
            $ServicePoint.CloseConnectionGroup("") | Out-Null
        }
    }
}
