function Get-vRAPropertyGroup {
<#
    .SYNOPSIS
    Get a property group that the user is allowed to review.
    
    .DESCRIPTION
    API for property groups that a system administrator can interact with. It allows the user to interact 
    with property groups that the user is permitted to review.

    .PARAMETER Id
    The id of the property group

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
    Get-vRAPropertyGroup
    
    .EXAMPLE
    Get-vRAPropertyGroup -Limit 200

    .EXAMPLE
    Get-vRAPropertyGroup -Id Hostname
    
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (
    
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100

    )

    Begin {
        # --- Test for vRA API version
        xRequires -Version 7.0
        
        # Recursive function to Convert returned response to a Hashtable
        function ConvertPSObjectToHashtable
        {
            param (
                [Parameter(ValueFromPipeline)]
                $InputObject
            )

            process
            {
                if ($null -eq $InputObject) { return $null }

                if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string])
                {
                    $collection = @(
                        foreach ($object in $InputObject) { ConvertPSObjectToHashtable $object }
                    )

                    Write-Output -NoEnumerate $collection
                }
                elseif ($InputObject -is [psobject])
                {
                    $hash = @{}

                    foreach ($property in $InputObject.PSObject.Properties)
                    {
                        $hash[$property.Name] = ConvertPSObjectToHashtable $property.Value
                    }

                    $hash
                }
                else
                {
                    $InputObject
                }
            }
        }
    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get property Group by id
                'ById' {
                    
                    foreach ($PropertyGroupId in $Id) {
                
                        $URI = "/properties-service/api/propertygroups/$($PropertyGroupId)"

                        $PropertyGroup = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        # Write-Verbose $Response.content | Out-String

                        $props = @{}
                        foreach($vRAProp in $PropertyGroup.properties.PSObject.Properties) {
                            $facets = @{}
                            foreach($facetkey in $vRAProp.Value.facets.PSObject.Properties) {
                                $facets.Add($facetkey.Name, $facetKey.Value.value.value)
                            }

                            # add to props grouping now
                            $props.Add($vRAProp.Name, $facets)
                        }

                        [PSCustomObject] @{

                            Id = $PropertyGroup.id
                            Label = $PropertyGroup.label
                            Description = $PropertyGroup.description
                            TenantId = $PropertyGroup.tenantId
                            DateCreated = $PropertyGroup.createdDate
                            LastUpdatedDate = $PropertyGroup.lastUpdated
                            Properties = $props
                        }
                    }

                    break

                }

                # --- No parameters passed so return all property Groups
                'Standard' {

                    $URI = "/properties-service/api/propertygroups?limit=$($Limit)&page=$($Page)&`$orderby=id asc"

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                    foreach ($PropertyGroup in $Response.content) {
                        $props = @{}
                        foreach($vRAProp in $PropertyGroup.properties.PSObject.Properties) {
                            $facets = @{}
                            foreach($facetkey in $vRAProp.Value.facets.PSObject.Properties) {
                                $facets.Add($facetkey.Name, $facetKey.Value.value.value)
                            }

                            # add to props grouping now
                            $props.Add($vRAProp.Name, $facets)
                        }

                        [PSCustomObject] @{

                            Id = $PropertyGroup.id
                            Label = $PropertyGroup.label
                            Description = $PropertyGroup.description
                            TenantId = $PropertyGroup.tenantId
                            DateCreated = $PropertyGroup.createdDate
                            LastUpdatedDate = $PropertyGroup.lastUpdated
                            Properties = $props
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