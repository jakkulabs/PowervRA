function Set-vRAEntitlement {
<#
    .SYNOPSIS
    Update an existing entitlement

    .DESCRIPTION
    Update an existing entitlement

    .PARAMETER Id
    The id of the entitlement

    .PARAMETER Name
    The name of the entitlement

    .PARAMETER Description
    A description of the entitlement

    .PARAMETER Principals
    Users or groups that will be associated with the entitlement

    .PARAMETER EntitledCatalogItems
    One or more entitled catalog item 

    .PARAMETER EntitledResourceOperations
    The externalId of one or more entitled resource operation (e.g. Infrastructure.Machine.Action.PowerOn)

    .PARAMETER EntitledServices
    One or more entitled service 

    .PARAMETER Status
    The status of the entitlement. Accepted values are ACTIVE and INACTIVE

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Set-vRAEntitlement -Id "e5cd1c84-3b76-4ae9-9f2e-35114da6cfd2" -Name "Updated Name"

    .EXAMPLE
    Set-vRAEntitlement -Id "e5cd1c84-3b76-4ae9-9f2e-35114da6cfd2" -Name "Updated Name" -Description "Updated Description" -Principals "user@vsphere.local" -EntitledCatalogItems "Centos" -EntitledServices "A service" -EntitledResourceOperations "Infrastructure.Machine.Action.PowerOff" -Status ACTIVE

    .EXAMPLE
    Get-vRAEntitlement -Name "Entitlement 1" | Set-vRAEntitlement -Description "Updated description!"

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Id,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Principals,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]]$EntitledCatalogItems,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]]$EntitledResourceOperations,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]]$EntitledServices,

        [Parameter(Mandatory=$false)]
        [ValidateSet("ACTIVE","INACTIVE")]
        [String]$Status

    )    

    Begin {
    
    }
    
    Process {

        try {

            Write-Verbose -Message "Testing for existing entitlement"

            $URI = "/catalog-service/api/entitlements/$($Id)"

            $Entitlement = Invoke-vRARestMethod -URI $URI -Method Get

            # --- Update name
            if ($PSBoundParameters.ContainsKey("Name")){

            Write-Verbose -Message "Updating Name: $($Entitlement.name) >> $($Name)"
            $Entitlement.name = $Name

            }

            # --- Update description
            if ($PSBoundParameters.ContainsKey("Description")){

            Write-Verbose -Message "Updating Description: $($Entitlement.description) >> $($Description)"
            $Entitlement.description = $Description

            }

            # --- Update principals
            if ($PSBoundParameters.ContainsKey("Principals")) {

                foreach($Principal in $Principals) {

                    Write-Verbose -Message "Adding principal: $($Principal)"

                    $CatalogPrincipal = Get-vRACatalogPrincipal -Id $Principal

                    $Entitlement.principals += $CatalogPrincipal


                }

            }
                
            # --- Update entitled catalog items
            if ($PSBoundParameters.ContainsKey("EntitledCatalogItems")) {

                foreach($CatalogItem in $EntitledCatalogItems) {

                    Write-Verbose "Adding entitled catalog item: $($CatalogItem)"

                    # --- Build catalog item ref object
                    $CatalogItemRef = [PSCustomObject] @{

                        id = $((Get-vRAEntitledCatalogItem -Name $CatalogItem).Id)
                        label = $null

                    }
                        
                    # --- Build entitled catalog item object and insert catalogItemRef
                    $EntitledCatalogItem = [PSCustomObject] @{

                    approvalPolicyId = $null
                    active = $null
                    catalogItemRef = $CatalogItemRef

                    }

                    $Entitlement.entitledCatalogItems += $EntitledCatalogItem

                }

            }

            # ---  Update entitled services             
            if ($PSBoundParameters.ContainsKey("EntitledServices")) {

                foreach($Service in $EntitledServices) {

                    Write-Verbose -Message "Adding service: $($Service)"

                    # --- Build service ref object
                    $ServiceRef = [PSCustomObject] @{

                    id = $((Get-vRAService -Name $Service).Id)
                    label = $null

                    }
                        
                    # --- Build entitled service object and insert serviceRef
                    $EntitledService = [PSCustomObject] @{

                        approvalPolicyId = $null
                        active = $null
                        serviceRef = $ServiceRef

                    }

                    $Entitlement.entitledServices += $EntitledService

                }

            }

            # --- Update entitled resource operations
            if ($PSBoundParameters.ContainsKey("EntitledResourceOperations")) {

                foreach ($ResourceOperation in $EntitledResourceOperations) {

                    Write-Verbose -Message "Adding resouceoperation: $($resourceOperation)"

                    $Operation = Get-vRAResourceOperation -ExternalId $ResourceOperation

                    $ResourceOperationRef = [PSCustomObject] @{

                        id = $Operation.Id
                        label = $null

                    }

                    $EntitledResourceOperation = [PSCustomObject] @{

                        approvalPolicyId =  $null
                        resourceOperationType = "ACTION"
                        externalId = $Operation.ExternalId
                        active = $true
                        resourceOperationRef = $ResourceOperationRef
                        targetResourceTypeRef = $Operation.TargetResourceTypeRef

                    }

                    $Entitlement.entitledResourceOperations += $EntitledResourceOperation

                }

            }

            # --- Update status
            if ($PSBoundParameters.ContainsKey("Status")) {

                Write-Verbose -Message "Updating Status: $($Entitlement.status) >> $($Status)"
                $Entitlement.status = $Status

            }

            # --- Convert the modified entitlement to json 
            $Body = $Entitlement | ConvertTo-Json -Depth 50 -Compress

            if ($PSCmdlet.ShouldProcess($Id)){

                $URI = "/catalog-service/api/entitlements/$($Id)"
                
                # --- Run vRA REST Request
                Invoke-vRARestMethod -Method PUT -URI $URI -Body $Body -Verbose:$VerbosePreference | Out-Null

                # --- Output the Successful Result
                Get-vRAEntitlement -Id $Id
            }

        }
        catch [Exception]{

            throw

        }

    }

    End {

    }

}