function Remove-vRAPropertyGroup {
<#
    .SYNOPSIS
    Removes a Property Group from the specified tenant
    
    .DESCRIPTION
    Uses the REST API to delete a property Group based on the Id supplied. If the Tenant is supplied it will delete the property group for that tenant only.

    .PARAMETER Id
    The id of the property Group to delete

    .PARAMETER Tenant
    The tenant of the property Group to delete

    .INPUTS
    System.String

    .OUTPUTS
    None

    .EXAMPLE
    # Remove the property group "Hostname"
    Remove-vRAPropertyGroup -Id Hostname

    .EXAMPLE
    # Remove the property group "Hostname" using the pipeline
    Get-vRAPropertyGroup -Id Hostname | Remove-vRAPropertyGroup -Confirm:$false
    
    .EXAMPLE
    # Remove the property group "Hostname" from the tenant "Development"
    Remove-vRAPropertyGroup -Id "Hostname" -Tenant Development

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Id,

        [parameter(Mandatory=$false)]    
        [ValidateNotNullOrEmpty()]
        [String]$Tenant

    )

    Begin {
        # --- Test for vRA API version
        xRequires -Version 7.0
    }

    Process {

        try {
            # Get-vRAPropertyGroup will throw a 404 error if it doesn't exist
            if(Get-vRAPropertyGroup -Id $Id) {
                
                if ($PSCmdlet.ShouldProcess($Id)){

                    $URI = "/properties-service/api/propertygroups/$($Id)"

                    if($Tenant) { 
                        $URI += "?tenantId=$($Tenant)"
                    }

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    Invoke-vRARestMethod -Method DELETE -URI $EscapedURI -Verbose:$VerbosePreference
                }

            }

        }
        catch [Exception]{

            throw

        }
    }

    End {

    }
}