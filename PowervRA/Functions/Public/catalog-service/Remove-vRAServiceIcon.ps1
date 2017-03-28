function Remove-vRAServiceIcon {
<#
    .SYNOPSIS
    Remove a vRA Service Icon
    
    .DESCRIPTION
    Remove a vRA Service Icon Icon from the service catalog. If the icon is one of the default system icons, it will be reverted to its default state instead of being deleted.

    .PARAMETER Id
    The id of the Service Icon

    .INPUTS
    System.String

    .OUTPUTS
    None

    .EXAMPLE
    Remove-vRAServiceIcon -Id "cafe_default_icon_genericAllServices"

    Set the default All Services Service Icon back to the original icon. Note: admin permissions for the default vRA Tenant are required for this action.

    .EXAMPLE
    Get-vRAServiceIcon -Id "cafe_icon_Service01" | Remove-vRAServiceIcon -Confirm:$false

    Delete the Service Icon named cafe_icon_Service01
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param (
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id
          
    )    

    begin {

        # --- Test for vRA API version
        xRequires -Version 7.1
    }
    
    process {

        foreach ($IconId in $Id) {

            # --- Remove the service
            try {

                if ($PSCmdlet.ShouldProcess($IconId)){                
       
                    $URI = "/catalog-service/api/icons/$($IconId)"
                
                    Invoke-vRARestMethod -Method DELETE -URI $URI -Verbose:$VerbosePreference              
                }
            }
            catch [Exception] {
            
                throw            
            }
        }
    }

    end {

    }
}