function Get-vRAPropertyDefinition {
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

    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get property definition by id
                'ById' {

                    foreach ($PropertyDefinitionId in $Id) {
                
                        $URI = "/properties-service/api/propertydefinitions/$($PropertyDefinitionId)"

                        $PropertyDefinition = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        [PSCustomObject] @{

                            Id = $PropertyDefinition.id
                            Label = $PropertyDefinition.label
                            Description = $PropertyDefinition.description
                            Type = $PropertyDefinition.dataType.typeId
                            IsMultivalued = $PropertyDefinition.isMultiValued
                            Display = $PropertyDefinition.displayAdvice
                            TenantId = $PropertyDefinition.tenantId
                            DisplayIndex = $PropertyDefinition.orderIndex
                            PermittedValues = $PropertyDefinition.permissibleValues
                            Options = $PropertyDefinition.facets
                            Version = $PropertyDefinition.version
                            DateCreated = $PropertyDefinition.createdDate
                            LastUpdatedDate = $PropertyDefinition.lastUpdated      

                        }

                    }

                    break

                }

                # --- No parameters passed so return all property definitions
                'Standard' {

                    $URI = "/properties-service/api/propertydefinitions?limit=$($Limit)&page=$($Page)&`$orderby=id asc"

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                    foreach ($PropertyDefinition in $Response.content) {

                        [PSCustomObject] @{

                            Id = $PropertyDefinition.id
                            Label = $PropertyDefinition.label
                            Description = $PropertyDefinition.description
                            Type = $PropertyDefinition.dataType.typeId
                            IsMultivalued = $PropertyDefinition.isMultiValued
                            Display = $PropertyDefinition.displayAdvice
                            TenantId = $PropertyDefinition.tenantId
                            DisplayIndex = $PropertyDefinition.orderIndex
                            PermittedValues = $PropertyDefinition.permissibleValues
                            Options = $PropertyDefinition.facets
                            Version = $PropertyDefinition.version
                            DateCreated = $PropertyDefinition.createdDate
                            LastUpdatedDate = $PropertyDefinition.lastUpdated     

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