function New-vRAEntitlement {
<#
    .SYNOPSIS
    Create a new entitlement

    .DESCRIPTION
    Create a new entitlement

    .PARAMETER Name
    The name of the entitlement

    .PARAMETER Description
    A description of the entitlement

    .PARAMETER BusinessGroup
    The business group that will be associated with the entitlement

    .PARAMETER Principals
    Users or groups that will be associated with the entitlement

    If this parameter is not specified, the entitlement will be created as DRAFT

    .PARAMETER EntitledCatalogItems
    One or more entitled catalog item 

    .PARAMETER EntitledResourceOperations
    The externalId of one or more entitled resource operation (e.g. Infrastructure.Machine.Action.PowerOn)

    .PARAMETER EntitledServices
    One or more entitled service

    .PARAMETER LocalScopeForActions
    Determines if the entitled actions are entitled for all applicable service catalog items or only
    items in this entitlement

    The default value for this parameter is True.

    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRAEntitlement -Name "TestEntitlement" -Description "a test" -BusinessGroup "Test01" -Principals "user@vsphere.local" -EntitledCatalogItems "centos7","centos6" -EntitledServices "Default service" -Verbose

    .EXAMPLE
    $JSON = @"
                    {
                      "description": "",
                      "entitledCatalogItems": [],
                      "entitledResourceOperations": [],
                      "entitledServices": [],
                      "expiryDate": null,
                      "id": null,
                      "lastUpdatedBy": null,
                      "lastUpdatedDate": null,
                      "name": "Test api 4",
                      "organization": {
                        "tenantRef": "Tenant01",
                        "tenantLabel": "Tenant",
                        "subtenantRef": "792e859a-8a5e-4814-bf04-e4489b27cada",
                        "subtenantLabel": "Default Business Group[Tenant01]"
                      },
                      "principals": [
                        {
                          "tenantName": "Tenant01",
                          "ref": "user@vsphere.local",
                          "type": "USER",
                          "value": "Test User"
                        }
                      ],
                      "priorityOrder": 2,
                      "status": "ACTIVE",
                      "statusName": "Active",
                      "localScopeForActions": true,
                      "version": null
                    }
"@

    $JSON | New-vRAEntitlement -Verbose

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$BusinessGroup,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Principals,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$EntitledCatalogItems,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$EntitledResourceOperations,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$EntitledServices,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [bool]$LocalScopeForActions = $true,        

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

    )    

    Begin {

    }
    
    Process {

        try {
    
            # --- Set Body for REST request depending on ParameterSet
            if ($PSBoundParameters.ContainsKey("JSON")){

                $Data = ($JSON | ConvertFrom-Json)
        
                $Body = $JSON
                $Name = $Data.name
            }
            else {

                # --- Get business group information for the request
                Write-Verbose -Message "Requesting business group information for $($BusinessGroup)"

                $BusinessGroupObject = Get-vRABusinessGroup -Name $BusinessGroup

                # --- Prepare payload        
                $Body = @"
                    {
                      "description": "$($Description)",
                      "entitledCatalogItems": [],
                      "entitledResourceOperations": [],
                      "entitledServices": [],
                      "expiryDate": null,
                      "id": null,
                      "lastUpdatedBy": null,
                      "lastUpdatedDate": null,
                      "name": "$($Name)",
                      "organization": {
                        "tenantRef": "$($Global:vRAConnection.Tenant)",
                        "tenantLabel": null,
                        "subtenantRef": "$($BusinessGroupObject.ID)",
                        "subtenantLabel": "$($BusinessGroupObject.Name)"
                      },
                      "principals": [],
                      "priorityOrder": null,
                      "status": "DRAFT",
                      "statusName": "Draft",
                      "localScopeForActions": "$($LocalScopeForActions.ToString().ToLower())",
                      "version": null
                    }
"@

            }

            # --- If certain parameters are specified, ConvertFrom-Json, update, then ConvertTo-Json
            if ($PSBoundParameters.ContainsKey("Principals") -or $PSBoundParameters.ContainsKey("EntitledCatalogItems")  -or $PSBoundParameters.ContainsKey("EntitledResourceOperations")  -or $PSBoundParameters.ContainsKey("EntitledServices")){

                $Object = $Body | ConvertFrom-Json
              
                if ($PSBoundParameters.ContainsKey("Principals")) {

                    Write-Verbose -Message "Principal specified, changing status to ACTIVE"
                    $Object.status = "ACTIVE"

                    foreach($Principal in $Principals) {

                        Write-Verbose -Message "Adding principal: $($Principal)"

                        $CatalogPrincipal = Get-vRACatalogPrincipal -Id $Principal

                        $Object.principals += $CatalogPrincipal

                    }

                }

                if ($PSBoundParameters.ContainsKey("EntitledCatalogItems")) {

                    foreach($CatalogItem in $EntitledCatalogItems) {

                        Write-Verbose "Adding entitled catalog item: $($CatalogItem)"

                        # --- Build catalog item ref object
                        $CatalogItemRef = [PSCustomObject] @{

                            id = $((Get-vRACatalogItem -Name $CatalogItem).Id)
                            label = $null

                        }
                        
                        # --- Build entitled catalog item object and insert catalogItemRef
                        $EntitledCatalogItem = [PSCustomObject] @{

                            approvalPolicyId = $null
                            active = $null
                            catalogItemRef = $CatalogItemRef

                        }

                        $Object.entitledCatalogItems += $EntitledCatalogItem

                    }

                }

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

                        $Object.entitledServices += $EntitledService

                    }

                }

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

                        $Object.entitledResourceOperations += $EntitledResourceOperation

                    }

                }

                $Body = $Object | ConvertTo-Json -Depth 50 -Compress

                Write-Verbose $Body

            }

            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/catalog-service/api/entitlements/"

                # --- Run vRA REST Request
                Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference | Out-Null

                # --- Output the Successful Result
                Get-vRAEntitlement -Name $Name
            }

        }
        catch [Exception]{

            throw
        }

    }
    
    End {

    }

}