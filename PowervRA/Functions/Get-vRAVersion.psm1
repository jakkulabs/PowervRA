function Get-vRAVersion {
<#
    .SYNOPSIS
    Retrieve vRA version information
    
    .DESCRIPTION
    Retrieve vRA version information

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAVersion
    
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param ()
                
    try {
    
        $URI = "/identity/api/about"
        $Response = Invoke-vRARestMethod -URI $URI -Method GET

        [pscustomobject] @{

            BuildNumber = $Response.buildNumber
            BuildDate = $Response.buildDate
            ProductVersion = $Response.productVersion
            APIVersion = $Response.apiVersion
            ProductBuildNumber = $Response.productBuildNumber

        }

    }
    catch [Exception]{

        throw
    }
}