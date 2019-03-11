function Import-vRAContentData {
<#
    .SYNOPSIS
    Import a yaml file associated with vRA content

    .DESCRIPTION
    Import a yaml file associated with vRA content

    .PARAMETER ContentType
    The Content Type of the imported item such as composite-blueprint or property-group

    .PARAMETER Path
    The path to file to import

    .INPUTS
    System.String

    .OUTPUTS
    System.String

    .EXAMPLE
    Import-vRAContentData -Path ./CentOS.yaml -ContentType composite-blueprint

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.String')]

    Param (

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("form-definition","property-group", "property-definition", "composite-blueprint", "component-profile-value", "software-component", "o11n-package-type", "reservation-type-category-type", "reservation-type-type", "xaas-bundle-content", "xaas-blueprint", "xaas-resource-action", "xaas-resource-type", "xaas-resource-mapping")]
        [String]$ContentType,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Path
    )

    Begin {

        xRequires -Version 7.0

        $Headers = @{

            "Authorization" = "Bearer $($Global:vRAConnection.Token)";
            "Accept" = "Application/json"
            "Content-Type" = "text/yaml"
        }
    }

    Process {

        try {

            if ($PSCmdlet.ShouldProcess($Path)){

                $Body = Get-Content -Raw -Path $Path

                #vRA API - The string "import" isn't actually processed by vRA. The content id is processed via the body automatically. Validated this for new and exiting content items.
                $URI = "/content-management-service/api/contents/$($ContentType)/import/data"

                Invoke-vRARestMethod -Method POST -URI $URI -Headers $Headers -Verbose:$VerbosePreference -Body $Body

            }

        }
        catch [Exception]{

            throw

        }

    }

    End {

    }

}
