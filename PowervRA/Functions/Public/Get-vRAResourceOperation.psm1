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

    .PARAMETER Name
    The name of the resource operation

    .PARAMETER ExternalId
    The external id of the resource operation

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

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

    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,
    
    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ByExternalId")]
    [ValidateNotNullOrEmpty()]
    [String[]]$ExternalId,               

    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name, 
    
    [parameter(Mandatory=$false,ValueFromPipeline=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100" 
    )
                
    try {

        switch ($PsCmdlet.ParameterSetName) {

            # --- Get resource operation by id
            'ById'{
        
                foreach ($ResourceOperation in $Id ) { 
            
                    $URI = "/catalog-service/api/resourceOperations/$($ResourceOperation)"

                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    Write-Verbose -Message "SUCCESS"

                    [pscustomobject] @{

                        Id = $Response.id
                        ExternalId = $Response.externalId
                        Name = $Response.name
                        Description = $Response.description
                        IconId = $Response.iconId
                        TargetCriteria = $Response.targetCriteria
                        TargetResourceTypeRef = $Response.targetResourceTypeRef
                        Status = $Response.status
                        Entitleable = $Response.entitleable
                        organization = $Response.organization
                        RequestSchema =$Response.requestSchema
                        Forms = $Response.forms
                        Callbacks = $Response.callbacks
                        LifecycleAction = $Response.lifecycleACtion
                        BindingId = $Response.bindingId
                        ProviderTypeRef =$Response.providerTypeRef

                    }

                }

                break

            }
                
            # --- Get resource operation by name
            'ByName' {

                foreach ($ResourceOperation in $Name) {
            

                    $URI = "/catalog-service/api/resourceOperations?`$filter=name%20eq%20'$($ResourceOperation)'"

                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    Write-Verbose -Message "SUCCESS"

                    Write-Verbose -Message "Response contains $($Response.content.Length) records"
            
                    if ($Response.content.Length -eq 0) {

                        throw "Could not find resource operation item with name: $Name"

                    }        
            
                    [pscustomobject] @{

                        Id = $Response.content.id
                        ExternalId = $Response.content.externalId
                        Name = $Response.content.name
                        Description = $Response.content.description
                        IconId = $Response.content.iconId
                        TargetCriteria = $Response.content.targetCriteria
                        TargetResourceTypeRef = $Response.content.targetResourceTypeRef
                        Status = $Response.content.status
                        Entitleable = $Response.content.entitleable
                        organization = $Response.content.organization
                        RequestSchema =$Response.content.requestSchema
                        Forms = $Response.content.forms
                        Callbacks = $Response.content.callbacks
                        LifecycleAction = $Response.content.lifecycleACtion
                        BindingId = $Response.content.bindingId
                        ProviderTypeRef =$Response.content.providerTypeRef

                    }           
                }

                break

            }

            # --- Get resource operation by external id
            'ByExternalId' {

                foreach ($ResourceOperation in $ExternalId) {           

                    $URI = "/catalog-service/api/resourceOperations?`$filter=externalId%20eq%20'$($ResourceOperation)'"

                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    Write-Verbose -Message "SUCCESS"

                    Write-Verbose -Message "Response contains $($Response.content.Length) records"
            
                    if ($Response.content.Length -eq 0) {

                        throw "Could not find resource operation item with name: $Name"

                    }        
            
                    [pscustomobject] @{

                        Id = $Response.content.id
                        ExternalId = $Response.content.externalId
                        Name = $Response.content.name
                        Description = $Response.content.description
                        IconId = $Response.content.iconId
                        TargetCriteria = $Response.content.targetCriteria
                        TargetResourceTypeRef = $Response.content.targetResourceTypeRef
                        Status = $Response.content.status
                        Entitleable = $Response.content.entitleable
                        organization = $Response.content.organization
                        RequestSchema =$Response.content.requestSchema
                        Forms = $Response.content.forms
                        Callbacks = $Response.content.callbacks
                        LifecycleAction = $Response.content.lifecycleACtion
                        BindingId = $Response.content.bindingId
                        ProviderTypeRef =$Response.content.providerTypeRef

                    }           
                }

                break

            }
                
            # --- No parameters passed so return all resource operations
            'Standard' {
            
                $URI = "/catalog-service/api/resourceOperations?limit=$($Limit)&`$orderby=name%20asc"

                Write-Verbose -Message "Preparing GET to $($URI)"

                $Response = Invoke-vRARestMethod -Method GET -URI $URI

                Write-Verbose -Message "SUCCESS"

                foreach ($ResourceOperation in $Response.content) {

                    [pscustomobject] @{

                        Id = $ResourceOperation.id
                        ExternalId = $ResourceOperation.externalId
                        Name = $ResourceOperation.name
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

        }

    }
    catch [Exception]{

        throw
    }

}