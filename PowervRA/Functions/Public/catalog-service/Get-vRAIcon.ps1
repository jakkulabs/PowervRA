function Get-vRAIcon {
<#
    .SYNOPSIS
    Retrieve a vRA Icon
    
    .DESCRIPTION
    Retrieve a vRA Icon
    
    .PARAMETER Id
    Specify the ID of an Icon

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAIcon -Id "cafe_default_icon_genericAllServices"

    Get the default All Services Icon. Note: admin permissions for the default vRA Tenant are required for this action.

    .EXAMPLE
    Get-vRAIcon -Id "cafe_icon_Service01"

    Get the vRA Icon named cafe_icon_Service01
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id
    )

    begin {

        # --- Test for vRA API version
        xRequires -Version 7.1
    }

    process {

        try {    

            foreach ($IconId in $Id){

                $URI = "/catalog-service/api/icons/$($IconId)"

                # --- Run vRA REST Request
                $Icon = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference    
                
                [PSCustomobject]@{

                    Id = $Icon.id                
                    FileName = $Icon.fileName
                    ContentType = $Icon.contentType
                    Image = $Icon.image
                    Organization = $Icon.organization
                }
            }
        }
        catch [Exception]{

            throw
        }
    }
    end {

    }
}