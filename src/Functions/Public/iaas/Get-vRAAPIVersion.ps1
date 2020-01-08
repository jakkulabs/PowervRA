function Get-vRAAPIVersion {
<#
    .SYNOPSIS
    Retrieve vRA API version information

    .DESCRIPTION
    Retrieve vRA API version information

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAAPIVersion

#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param ()

    try {

        $URI = "/iaas/api/about"
        $Response = Invoke-vRARestMethod -URI $URI -Method GET

        [pscustomobject] @{

            APIVersion = $Response.latestApiVersion
            SupportedAPIs = $Response.supportedApis.apiversion
        }
    }
    catch [Exception]{

        throw
    }
}