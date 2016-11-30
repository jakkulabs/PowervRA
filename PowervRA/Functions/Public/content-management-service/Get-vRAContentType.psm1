function Get-vRAContentType {
<#
    .SYNOPSIS
    Get a list of available vRA content types
    
    .DESCRIPTION
    Get a list of available vRA content types

    .PARAMETER Id
    The id of the content type

    .PARAMETER Name
    The name of the content type

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
    Get-vRAContentType -Id property-group

    .EXAMPLE
    Get-vRAContentType -Name "Property Group"

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (
    
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
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

    xRequires -Version 7.0

    Begin {

    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get content type by id
                'ById' {

                    foreach ($ContentTypeId in $Id) {
                
                        $URI = "/content-management-service/api/provider/contenttypes/$($ContentTypeId)"

                        $ContentType = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        [PSCustomObject] @{

                            Id = $ContentType.id
                            Name = $ContentType.name
                            Description = $ContentType.description
                            ClassId = $ContentType.classId
                            ServiceTypeId = $ContentType.serviceTypeId

                        }

                    }

                    break

                }
                # --- Get content type by name
                'ByName' {

                    foreach ($ContentTypeName in $Name) { 

                        $URI = "/content-management-service/api/provider/contenttypes?`$filter=name eq '$($ContentTypeName)'"            

                        $EscapedURI = [uri]::EscapeUriString($URI)

                        $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                        if ($Response.content.Count -eq 0) {

                            throw "Could not find content type with name: $($ContentName)"

                        }

                        $ContentType = $Response.content

                        [PSCustomObject] @{

                            Id = $ContentType.id
                            Name = $ContentType.name
                            Description = $ContentType.description
                            ClassId = $ContentType.classId
                            ServiceTypeId = $ContentType.serviceTypeId

                        }

                    }

                    break

                }
                # --- No parameters passed so return all content types
                'Standard' {

                    $URI = "/content-management-service/api/provider/contenttypes?limit=$($Limit)&page=$($Page)&`$orderby=name asc"

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                    foreach ($ContentType in $Response.content) {

                        [PSCustomObject] @{

                            Id = $ContentType.id
                            Name = $ContentType.name
                            Description = $ContentType.description
                            ClassId = $ContentType.classId
                            ServiceTypeId = $ContentType.serviceTypeId

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