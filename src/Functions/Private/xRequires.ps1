function xRequires {
<#
    .SYNOPSIS
    Checks the required API Version for the current function

    .DESCRIPTION
    Checks the required API Version for the current function

    .PARAMETER Version
    The API Version that the function supports.

    The version number passed to this parameter must be in the following format.. it can't be a single character.

    - 6.2.4
    - 7.0
    - 7.0.1
    - 7.1
    - 7.2

    .INPUTS
    System.Int
    System.Management.Automation.PSObject.

    .OUTPUTS
    None

    .EXAMPLE

    function Get-Example {

        # This function does not support API versions lower than Version 7
        xRequires -Version "7.0"

    }

#>

[CmdletBinding()][Alias("FunctionRequires")]
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [String]$Version
    )

    # --- Test for vRA API version
    if (-not $Global:vRAConnection){
        throw "vRA Connection variable does not exist. Please run Connect-vRAServer first to create it"
    }

    # --- Convert version strings to [version] objects
    $APIVersion = [version]$Global:vRAConnection.APIVersion
    $RequiredVersion = [version]$Version

    if ($APIVersion -lt $RequiredVersion) {
        $PSCallStack = Get-PSCallStack
        Write-Error -Message "$($PSCallStack[1].Command) is not supported with vRA API version $($Global:vRAConnection.APIVersion)"
        break
    }
}