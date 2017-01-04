function Global:xRequiresVAMI {
<#
    .SYNOPSIS
    Checks the required VAMI API Version for the current function

    .DESCRIPTION
    Checks the required VAMI API Version for the current function

    .PARAMETER Version
    The VAMI API Version that the function supports.

    The version number passed to this parameter must be in the following format.. it can't be a single character.
    - 7.2

    .INPUTS
    System.Int
    System.Management.Automation.PSObject.

    .OUTPUTS
    None

    .EXAMPLE

    function Get-Example {

        # This function does not support VAMI API versions lower than Version 7.2
        xRequires -Version "7.2"

    }

#>

[CmdletBinding()]

    Param (

        [Parameter(Mandatory=$true)]
        [String]$Version

    )
        # --- Test for vRA VAMI API version
        if (-not $Global:vRAVAMIConnection){

            throw "vRA VAMI Connection variable does not exist. Please run Connect-vRAVAMI first to create it"
        }

        # --- Convert version strings to [version] objects
        $APIVersion = [version]$Global:vRAVAMIConnection.APIVersion 
        $RequiredVersion = [version]$Version

        if ($APIVersion -lt $RequiredVersion) {

            $PSCallStack = Get-PSCallStack

            throw "$($PSCallStack[1].Command) is not supported with vRA VAMI API version $($Global:vRAVAMIConnection.APIVersion)"

        }



}