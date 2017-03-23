function Remove-vRAPropertyDefinition {
<#
    .SYNOPSIS
    Removes a Property Definiton from the specified tenant
    
    .DESCRIPTION
    Uses the REST API to delete a property definiton based on the Id supplied. If the Tenant is supplied it will delete the property for that tenant only.

    .PARAMETER Id
    The id of the property definition to delete

    .PARAMETER Tenant
    The tenant of the property definition to delete

    .INPUTS
    System.String

    .OUTPUTS
    None

    .EXAMPLE
    # Remove the property "Hostname"
    Remove-vRAPropertyDefinition -Id Hostname
    
    .EXAMPLE
    # Remove the property "Hostname" from the tenant "Development" only
    Get-vRAPropertyDefinition -Id "Hostname" -Tenant Development

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

    }

    Process {

        try {
            # Get-vRAPropertyDefinition will throw a 404 error if it doesn't exist
            if(Get-vRAPropertyDefinition -Id $Id) {
                
                if ($PSCmdlet.ShouldProcess($Id)){

                    $URI = "/properties-service/api/propertydefinitions/$($Id)"

                    if($Tenant) { 
                        $URI += "?tenantId=$($Tenant)"
                    }

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    $Response = Invoke-vRARestMethod -Method DELETE -URI $EscapedURI -Verbose:$VerbosePreference
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