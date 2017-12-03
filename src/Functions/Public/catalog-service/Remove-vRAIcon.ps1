function Remove-vRAIcon {
<#
    .SYNOPSIS
    Remove a vRA Icon
    
    .DESCRIPTION
    Remove a vRA Icon from the service catalog. If the icon is one of the default system icons, it will be reverted to its default state instead of being deleted.

    .PARAMETER Id
    The id of the Icon

    .INPUTS
    System.String

    .OUTPUTS
    None

    .EXAMPLE
    Remove-vRAIcon -Id "cafe_default_icon_genericAllServices"

    Set the default All Services Icon back to the original icon. Note: admin permissions for the default vRA Tenant are required for this action.

    .EXAMPLE
    Get-vRAIcon -Id "cafe_icon_Service01" | Remove-vRAIcon -Confirm:$false

    Delete the Icon named cafe_icon_Service01
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