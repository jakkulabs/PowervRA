function Export-vRAIcon {
<#
    .SYNOPSIS
    Export a vRA Icon
    
    .DESCRIPTION
    Export a vRA Icon
    
    .PARAMETER Id
    Specify the ID of an Icon

    .PARAMETER File
    Specify the file to output the icon to

    .INPUTS
    System.String

    .OUTPUTS
    System.IO.FileInfo

    .EXAMPLE
    Export-vRAIcon -Id "cafe_default_icon_genericAllServices" -File C:\Icons\AllServicesIcon.png

    Export the default All Services Icon to a local file. Note: admin permissions for the default vRA Tenant are required for this action.
#>
[CmdletBinding()][OutputType('System.IO.FileInfo')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$File
    )

    # --- Test for vRA API version
    xRequires -Version 7.1

    try {    

        foreach ($IconId in $Id){

            $URI = "/catalog-service/api/icons/$($IconId)/download"

            # --- Run vRA REST Request
            Invoke-vRARestMethod -Method GET -URI $URI -OutFile $File -Verbose:$VerbosePreference

            # --- Output the result
            Get-ChildItem -Path $File
        }
    }
    catch [Exception]{

        throw
    }
}