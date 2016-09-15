function Global:xRequires {
<#
    .SYNOPSIS
    Checks the required API Version for the current function

    .DESCRIPTION
    Checks the required API Version for the current function

    .PARAMETER Version
    The API Version that the function supports 

    .PARAMETER Context
    The functions execution context. This should always be $MyInvocation

    .INPUTS
    System.Int
    System.Management.Automation.PSObject.

    .OUTPUTS
    None

    .EXAMPLE

    function Get-Example {

        # This function does not support API versions lower than Version 7
        xRequires -Version 7 -Context $MyInvocation

    }

#>

[CmdletBinding()]

    Param (

        [Parameter(Mandatory=$true)]
        [Int]$Version,

        [Parameter(Mandatory=$true)]
        [PSCustomobject]$Context

    )
        # --- Test for vRA API version
        if (-not $Global:vRAConnection){

            throw "vRA Connection variable does not exist. Please run Connect-vRAServer first to create it"
        }

        elseif ($Global:vRAConnection.APIVersion -lt $Version) {

            throw "$($Context.MyCommand) is not supported with vRA API version $($Global:vRAConnection.APIVersion)"
        }
}