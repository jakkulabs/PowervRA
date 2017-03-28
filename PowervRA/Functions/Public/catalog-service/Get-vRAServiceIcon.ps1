function Get-vRAServiceIcon {
<#
    .SYNOPSIS
    Retrieve a vRA Service Icon
    
    .DESCRIPTION
    Retrieve a vRA Service Icon
    
    .PARAMETER Id
    Specify the ID of a Service Icon

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAServiceIcon -Id "cafe_default_icon_genericAllServices"

    Get the default All Services Service Icon. Note: admin permissions for the default vRA Tenant are required for this action.

    .EXAMPLE
    Get-vRAServiceIcon -Id "cafe_icon_Service01"

    Get the Service Icon named cafe_icon_Service01
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