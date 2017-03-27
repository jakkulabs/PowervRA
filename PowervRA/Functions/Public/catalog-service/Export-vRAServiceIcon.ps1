function Export-vRAServiceIcon {
<#
    .SYNOPSIS
    Export a vRA Service Icon
    
    .DESCRIPTION
    Export a vRA Service Icon
    
    .PARAMETER Id
    Specify the ID of a Service Icon

    .INPUTS
    System.String

    .OUTPUTS
    System.IO.FileInfo

    .EXAMPLE
    Export-vRAServiceIcon -Id "cafe_default_icon_genericAllServices" -Path C:\Icons\AllServicesIcon.png
#>
[CmdletBinding()][OutputType('System.IO.FileInfo')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Path
    )

    # --- Test for vRA API version
    xRequires -Version 7.1

    try {    

        foreach ($IconId in $Id){

            $URI = "/catalog-service/api/icons/$($IconId)/download"

            # --- Run vRA REST Request
            Invoke-vRARestMethod -Method GET -URI $URI -OutFile $Path -Verbose:$VerbosePreference

            # --- Output the result
            Get-ChildItem -Path $Path
        }
    }
    catch [Exception]{

        throw
    }
}