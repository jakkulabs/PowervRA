function Import-vRAServiceIcon {
<#
    .SYNOPSIS
    Imports a vRA Service Icon   

    .DESCRIPTION
    Imports a vRA Service Icon

    .PARAMETER Id
    Specify the ID of a Service Icon

    .PARAMETER File
    The Service Icon file

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Import-vRAServiceIcon -Id "cafe_default_icon_genericAllServices" -File C:\Icons\NewIcon.png

    Update the default All Services Service Icon with a new image file. Note: admin permissions for the default vRA Tenant are required for this action.

    .EXAMPLE
    Get-ChildItem -Path C:\Icons\NewIcon.png | Import-vRAServiceIcon -Id "cafe_default_icon_genericAllServices" -Confirm:$false

    Update the default All Services Service Icon with a new image file via the pipeline. Note: admin permissions for the default vRA Tenant are required for this action.

    .EXAMPLE
    Import-vRAServiceIcon -Id "cafe_icon_Service01" -File C:\Icons\Service01Icon.png -Confirm:$false

    Create a new Service Icon named cafe_icon_Service01

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelinebyPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$File
    )

    begin {

        # --- Test for vRA API version
        xRequires -Version 7.1
    }

    process {

        foreach ($FilePath in $File){

            try {


                # --- Resolve the file path
                $FileInfo = [System.IO.FileInfo](Resolve-Path $FilePath).Path

                # --- Create the base64 string
                $Base64 = [convert]::ToBase64String((Get-Content $FileInfo.FullName -Encoding byte))

                # --- Set content type
                $Extension = $FileInfo.Extension.TrimStart('.')                
                $ContentType = "image/$($Extension)"              

                # --- Prepare payload        
                $Body = @"
                    {
                        "id": "$($Id)",
                        "fileName": "$($FileInfo.Name)",
                        "contentType": "$($ContentType)",
                        "image": "$($Base64)",
                        "organization": {}
                    }
"@

                $URI = "/catalog-service/api/icons"

                if ($PSCmdlet.ShouldProcess($FileInfo.FullName)){

                    # --- Run vRA REST request
                    Invoke-vRARestMethod -Method POST -Uri $URI -Body $Body -Verbose:$VerbosePreference

                    # --- Output the result
                    Get-vRAServiceIcon -Id $Id
                }
            }
            catch [Exception]{

                throw
            }
        }
    }
    end {

    }
}