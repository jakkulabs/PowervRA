function Get-vRAResourceType {
<#
    .SYNOPSIS
    Get a resource type
    
    .DESCRIPTION
    A Resource type is a type assigned to resources. The types are defined by the provider types. 
    It allows similar resources to be grouped together.
    
    .PARAMETER Id
    The id of the resource type
    
    .PARAMETER Name
    The Name of the resource type

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .PARAMETER Page
    The index of the page to display.

    .INPUTS
    System.String
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAResourceType
    
    .EXAMPLE
    Get-vRAResourceType -Id "Infrastructure.Machine"
    
    .EXAMPLE
    Get-vRAResourceType -Name "Machine"
    
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

    Begin {

        # --- Test for vRA API version
        xRequires -Version 7 -Context $MyInvocation

    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Resource Type by id
                'ById' {
                
                    foreach ($ResourceTypeId in $Id) { 

                        $URI = "/catalog-service/api/resourceTypes?`$filter=id eq '$($ResourceTypeId)'"

                        $EscapedURI = [uri]::EscapeUriString($URI)

                        $ResourceType = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                        if ($Response.content.Count -eq 0){

                            throw "Could not find Resource Type with Id: $($ResourceTypeId)"

                        }

                        [PSCustomObject] @{

                            Id = $ResourceType.id
                            Callbacks = $ResourceType.callbacks
                            CostFeatures =  $ResourceType.costFeatures
                            Description = $ResourceType.description
                            Forms = $ResourceType.forms
                            ListView = $ResourceType.listView
                            Name = $ResourceType.name
                            PluralizedName = $ResourceType.pluralizedName
                            Primary = $ResourceType.primary
                            ProviderTypeId = $ResourceType.providerTYpeId
                            Schema = $ResourceType.schema
                            ListDescendantTypesSeparately = $ResourceType.listDescendantTypesSeparately
                            ShowChildrenOutsideParent = $ResourceType.ShowChildrenOutsideParent
                            Status = $ResourceType.status

                        }

                    }

                    break

                }
                # --- Get Resource Type by name
                'ByName' {

                    foreach ($ResourceTypeName in $Name) {

                        $URI = "/catalog-service/api/resourceTypes?`$filter=name eq '$($ResourceTypeName)'"

                        $EscapedURI = [uri]::EscapeUriString($URI)

                        $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                        if ($Response.content.Count -eq 0) {

                            throw "Could not find resource type item with name: $($ResourceTypeName)"

                        }

                        $ResourceType = $Response.content

                        [PSCustomObject] @{

                            Id = $ResourceType.id
                            Callbacks = $ResourceType.callbacks
                            CostFeatures =  $ResourceType.costFeatures
                            Description = $ResourceType.description
                            Forms = $ResourceType.forms
                            ListView = $ResourceType.listView
                            Name = $ResourceType.name
                            PluralizedName = $ResourceType.pluralizedName
                            Primary = $ResourceType.primary
                            ProviderTypeId = $ResourceType.providerTYpeId
                            Schema = $ResourceType.schema
                            ListDescendantTypesSeparately = $ResourceType.listDescendantTypesSeparately
                            ShowChildrenOutsideParent = $ResourceType.ShowChildrenOutsideParent
                            Status = $ResourceType.status

                        }

                    }

                    break

                }
                # --- No parameters passed so return all resource types
                'Standard' {
                
                    $URI = "/catalog-service/api/resourceTypes?limit=$($Limit)&page=$($Page)&`$orderby=name asc"

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                    foreach ($ResourceType in $Response.content) {

                        [PSCustomObject] @{

                            Id = $ResourceType.id
                            Callbacks = $ResourceType.callbacks
                            CostFeatures =  $ResourceType.costFeatures
                            Description = $ResourceType.description
                            Forms = $ResourceType.forms
                            ListView = $ResourceType.listView
                            Name = $ResourceType.name
                            PluralizedName = $ResourceType.pluralizedName
                            Primary = $ResourceType.primary
                            ProviderTypeId = $ResourceType.providerTYpeId
                            Schema = $ResourceType.schema
                            ListDescendantTypesSeparately = $ResourceType.listDescendantTypesSeparately
                            ShowChildrenOutsideParent = $ResourceType.ShowChildrenOutsideParent
                            Status = $ResourceType.status

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