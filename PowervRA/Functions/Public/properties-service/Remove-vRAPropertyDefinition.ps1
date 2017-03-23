function Remove-vRAPropertyDefinition {
<#
    .SYNOPSIS
    Get a property that the user is allowed to review.
    
    .DESCRIPTION
    API for property definitions that a system administrator can interact with. It allows the user to interact 
    with property definitions that the user is permitted to review.

    .PARAMETER Id
    The id of the property definition

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100

    .PARAMETER Page
    The index of the page to display.

    .INPUTS
    System.String
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAPropertyDefinition
    
    .EXAMPLE
    Get-vRAPropertyDefinition -Limit 200

    .EXAMPLE
    Get-vRAPropertyDefinition -Id Hostname
    
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Id,

        [parameter(Mandatory=$false)]    
        [ValidateNotNullOrEmpty()]
        [String]$Tenant = $Global:vRAConnection.Tenant

    )

    Begin {

    }

    Process {

        try {
            # Get-vRAPropertyDefinition will throw a 404 error if it doesn't exist
            if(Get-vRAPropertyDefinition -Id $Id) {
                
                if ($PSCmdlet.ShouldProcess($Id)){

                    $URI = "/properties-service/api/propertydefinitions/$($Id)?tenantId=$($Tenant)"

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