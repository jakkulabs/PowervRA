function Get-vRAConsumerResourceOperation {
<#
    .SYNOPSIS
    Get a consumer resource operation
    
    .DESCRIPTION
    Consumer Resource Operation API exposed to users. A resource operation represents a Day-2 operation that can be performed on a resource.
    Resource operations are registered in the Service Catalog and target a specific resource type. 
    These operations can be invoked / accessed by consumers through the self-service interface on the resources they own.
    
    .PARAMETER Id
    The id of the resource operation

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.
    
    .EXAMPLE
    Get-vRAConsumerResourceOperation -Id "a4d57b16-9706-471b-9960-d0855fe544bb"

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id          

    )
                
    try {

        # --- Get resource operation by id

        foreach ($ResourceOperation in $Id ) { 
            
            $URI = "/catalog-service/api/consumer/resourceOperations/$($ResourceOperation)"

            Write-Verbose -Message "Preparing GET to $($URI)"

            $Response = Invoke-vRARestMethod -Method GET -URI $URI

            Write-Verbose -Message "SUCCESS"

            Write-Verbose -Message "Returning type: $($Response.'@type')"                

            switch ($Response.'@type') {

                'ResourceAction' {                    

                    [pscustomobject] @{

                        Type = $Response.'@type'
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

                    break
                    
                }

                'ResourceExtension' {

                    [pscustomobject] @{

                        Type = $Response.'@type'
                        Id = $Response.id
                        ExternalId = $Response.externalId
                        Name = $Response.name
                        Description = $Response.description
                        IconId = $Response.iconId
                        TargetCriteria = $Response.targetCriteria
                        TargetResourceTypeRef = $Response.targetResourceTypeRef
                        Status = $Response.status
                        Entitleable = $Response.entitleable
                        ExtensionId = $Response.extensionId

                    }

                    break

                }
            }

        }

    }
    catch [Exception]{

        throw
    }

}