function Get-vRAContent {
<#
    .SYNOPSIS
    Get available vRA content
    
    .DESCRIPTION
    Get available vRA content

    .PARAMETER Id
    The Id of the content

    .PARAMETER Name
    The name of the content

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
    Get-vRAContent

    .EXAMPLE
    Get-vRAContent -Id b2d72c5d-775b-400c-8d79-b2483e321bae

    .EXAMPLE
    Get-vRAContent -Name "some content"
    
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (
    
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100

    )

    Begin {

        xRequires -Version 7.0

    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get content by id
                'ById' {

                    foreach ($ContentId in $Id) {
                
                        $URI = "/content-management-service/api/contents/$($ContentId)"

                        $Content = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

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

                    break

                }
                # --- Get content by name
                'ByName' {

                    foreach ($ContentName in $Name) { 

                        $URI = "/content-management-service/api/contents?`$filter=name eq '$($ContentName)'"            

                        $EscapedURI = [uri]::EscapeUriString($URI)

                        $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                        if ($Response.content.Count -eq 0) {

                            throw "Could not find content with name: $($ContentName)"

                        }

                        $Content = $Response.content

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

                    break

                }
                # --- No parameters passed so return all content
                'Standard' {

                    $URI = "/content-management-service/api/contents?limit=$($Limit)&page=$($Page)&`$orderby=name asc"

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                    foreach ($Content in $Response.content) {

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

                    break

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