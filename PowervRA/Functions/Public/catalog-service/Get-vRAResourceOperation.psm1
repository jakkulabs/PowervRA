function Get-vRAResourceOperation {
<#
    .SYNOPSIS
    Get a resource operation

    .DESCRIPTION
    A resource operation represents a Day-2 operation that can be performed on a resource. 
    Resource operations are registered in the Service Catalog and target a specific resource type. 
    These operations can be invoked / accessed by consumers through the self-service interface on the resources they own.
    
    .PARAMETER Id
    The id of the resource operation

    .PARAMETER ExternalId
    The external id of the resource operation

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
    Get-vRAResourceOperation
    
    .EXAMPLE
    Get-vRAResourceOperation -Id "a4d57b16-9706-471b-9960-d0855fe544bb"

    .EXAMPLE
    Get-vRAResourceOperation -Name "Power On"

    .EXAMPLE
    Get-vRAResourceOperation -ExternalId "Infrastructure.Machine.Action.PowerOn"
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="ByExternalId")]
        [ValidateNotNullOrEmpty()]
        [String[]]$ExternalId,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100

    )
                
    try {

        switch ($PsCmdlet.ParameterSetName) {

            # --- Get resource operation by id
            'ById'{

                foreach ($ResourceOperation in $Id ) { 

                    $URI = "/catalog-service/api/resourceOperations/$($ResourceOperation)"

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    $ResourceOperation = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                    [PSCustomObject] @{

                        Id = $ResourceOperation.id
                        Name = $ResourceOperation.name
                        ExternalId = $ResourceOperation.externalId
                        Description = $ResourceOperation.description
                        IconId = $ResourceOperation.iconId
                        TargetCriteria = $ResourceOperation.targetCriteria
                        TargetResourceTypeRef = $ResourceOperation.targetResourceTypeRef
                        Status = $ResourceOperation.status
                        Entitleable = $ResourceOperation.entitleable
                        organization = $ResourceOperation.organization
                        RequestSchema =$ResourceOperation.requestSchema
                        Forms = $ResourceOperation.forms
                        Callbacks = $ResourceOperation.callbacks
                        LifecycleAction = $ResourceOperation.lifecycleACtion
                        BindingId = $ResourceOperation.bindingId
                        ProviderTypeRef =$ResourceOperation.providerTypeRef

                    }

                }

                break

            }

            # --- Get resource operation by external id
            'ByExternalId' {

                foreach ($ResourceOperation in $ExternalId) {           

                    $URI = "/catalog-service/api/resourceOperations?`$filter=externalId eq '$($ResourceOperation)'"

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                    if ($Response.content.Count -eq 0) {

                        throw "Could not find resource operation item with name: $Name"

                    }

                    $ResourceOperation = $Response.content

                    [PSCustomObject] @{

                        Id = $ResourceOperation.id
                        Name = $ResourceOperation.name
                        ExternalId = $ResourceOperation.externalId
                        Description = $ResourceOperation.description
                        IconId = $ResourceOperation.iconId
                        TargetCriteria = $ResourceOperation.targetCriteria
                        TargetResourceTypeRef = $ResourceOperation.targetResourceTypeRef
                        Status = $ResourceOperation.status
                        Entitleable = $ResourceOperation.entitleable
                        organization = $ResourceOperation.organization
                        RequestSchema =$ResourceOperation.requestSchema
                        Forms = $ResourceOperation.forms
                        Callbacks = $ResourceOperation.callbacks
                        LifecycleAction = $ResourceOperation.lifecycleACtion
                        BindingId = $ResourceOperation.bindingId
                        ProviderTypeRef =$ResourceOperation.providerTypeRef

                    }

                }

                break

            }
                
            # --- No parameters passed so return all resource operations
            'Standard' {
            
                $URI = "/catalog-service/api/resourceOperations?limit=$($Limit)&page=$($Page)&`$orderby=name asc"

                $EscapedURI = [uri]::EscapeUriString($URI)

                $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                foreach ($ResourceOperation in $Response.content) {

                    [PSCustomObject] @{

                        Id = $ResourceOperation.id
                        Name = $ResourceOperation.name
                        ExternalId = $ResourceOperation.externalId
                        Description = $ResourceOperation.description
                        IconId = $ResourceOperation.iconId
                        TargetCriteria = $ResourceOperation.targetCriteria
                        TargetResourceTypeRef = $ResourceOperation.targetResourceTypeRef
                        Status = $ResourceOperation.status
                        Entitleable = $ResourceOperation.entitleable
                        organization = $ResourceOperation.organization
                        RequestSchema =$ResourceOperation.requestSchema
                        Forms = $ResourceOperation.forms
                        Callbacks = $ResourceOperation.callbacks
                        LifecycleAction = $ResourceOperation.lifecycleACtion
                        BindingId = $ResourceOperation.bindingId
                        ProviderTypeRef =$ResourceOperation.providerTypeRef

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