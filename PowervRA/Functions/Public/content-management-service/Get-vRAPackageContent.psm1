function Get-vRAPackageContent {
<#
    .SYNOPSIS
    Get content items for a given package
    
    .DESCRIPTION
    Get content items for a given package
    
    .PARAMETER Id
    Specify the ID of a Package

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100

    .PARAMETER Page
    The index of the page to display.

    .INPUTS
    System.String
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAPackage
    
    .EXAMPLE
    Get-vRAPackage -Id "b2d72c5d-775b-400c-8d79-b2483e321bae"

    .EXAMPLE
    Get-vRAPackage -Name "Package01","Package02"
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100


    )

    # --- Test for vRA API version
    xRequires -Version 7.0
    
    try {                
                         
        foreach ($PackageId in $Id){

            $URI = "/content-management-service/api/packages/$($PackageId)/contents?limit=$($Limit)&page=$($Page)"

            # --- Run vRA REST Request
            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

            if ($Response.content.Count -eq 0) {

                Write-Verbose -Message "The specified package has no content"
                return

            }
            
            foreach ($Content in $Response.Content) {

                [PSCustomObject] @{

                    Id = $Content.id
                    ContentId = $Content.contentId
                    Name = $Content.name
                    Description = $Content.description
                    ContentTypeId = $Content.contentTypeId
                    MimeType = $Content.mimeType
                    TenantId = $Content.tenantId
                    SubtenantId = $Content.subtenantId
                    Dependencies = $Content.dependencies
                    CreatedDate = $Content.createdDate
                    LastUpdated = $Content.lastUpdated
                    Version = $Content.version

                }

            }

             Write-Verbose -Message "Total: $($Response.metadata.totalElements) | Page: $($Response.metadata.number) of $($Response.metadata.totalPages) | Size: $($Response.metadata.size)"

        }                             
            
    }
    catch [Exception]{

        throw
    }
}