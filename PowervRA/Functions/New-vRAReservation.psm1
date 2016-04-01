function New-vRAReservation {
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

    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Tenant,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$BusinessGroup,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$ReservationPolicy,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$Priority,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$ComputeResource,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$Quota = 0,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$Memory,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Storage,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Resourcepool,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Network,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$EnableAlerts = $false,

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
    [ValidateNotNullOrEmpty()]
    [String]$JSON
    )    

    begin {
    
    }
    
    process {

        try {

            $SchemaClassId = "Infrastructure.Reservation.Virtual.vSphere"

            switch ($PSCmdlet.ParameterSetName){

                'JSON' {

                    # --- Handle JSON PARAM
                    $Body = $JSON
                    $Data = ($JSON | ConvertFrom-Json)      
                    $Name = $Data.name

                    break

                }

                'Standard' {

                    # --- Ensure that the tenant id is correct
                    $TenantId = (Get-vRATenant -Id $Tenant).id
                    
                    # --- Get the business group  id
                    $BusinessGroupId = (Get-vRABusinessGroup -TenantId $TenantId -Name $BusinessGroup).id

                    # --- If reservation policy has been specified, get the id
                    $ReservationPolicyId = "null"

                    if ($PSBoundParameters.ContainsKey("ReservationPolicy")){

                        $ReservationPolicyId = Get-vRAReservationPolicy -Name $ReservationPolicy

                    }

                    # --- Build the initial payload
                    $JSON = @"
                        {
                          "name": "$($Name)",
                          "reservationTypeId": "Infrastructure.Reservation.Virtual.vSphere",
                          "tenantId": "$($TenantId)",
                          "subTenantId": "$($BusinessGroupId)",
                          "enabled": true,
                          "priority": $($Priority),
                          "reservationPolicyId": $($ReservationPolicyId),
                          "alertPolicy": {
                            "enabled": $($EnableAlerts.ToString().toLower()),
                            "frequencyReminder": 20,
                            "emailBgMgr": false,
                            "recipients": [],
                            "alerts": [
                              {
                                "alertPercentLevel": 80,
                                "referenceResourceId": "storage",
                                "id": "storage"
                              },
                              {
                                "alertPercentLevel": 80,
                                "referenceResourceId": "memory",
                                "id": "memory"
                              },
                              {
                                "alertPercentLevel": 80,
                                "referenceResourceId": "cpu",
                                "id": "cpu"
                              },
                              {
                                "alertPercentLevel": 80,
                                "referenceResourceId": "machine",
                                "id": "machine"
                              }
                            ]
                          },
                          "extensionData": {
                            "entries": []
                          }
                        }
"@

                    $JSON
                    # --- Convert the body to an object and begin adding extensionData
                    $ReservationObject = $JSON | ConvertFrom-Json

                    # --- Set the compute resource

                    $ComputeResourceObject = Get-vRAReservationComputeResource -SchemaClassId $SchemaClassId -Name $ComputeResource

                    $ComputeResourceJSON = @"

                        {
                            "key": "computeResource",
                            "value": {
                                "type" : "entityRef",
                                "componentId" : null,
                                "classId" : "ComputeResource",
                                "id" : "$($ComputeResourceObject.Id)",
                                "label" : "$($ComputeResourceObject.Label)"                  
                            
                            }

                        }
"@
                    
                    $ReservationObject.extensionData.entries += ($ComputeResourceJSON | ConvertFrom-Json)

                    # --- Set the resource pool

                    if ($PSBoundParameters.ContainsKey("ResourcePool")){

                        $ResourcePoolObject = Get-vRAReservationResourcePool -SchemaClassId $SchemaClassId -ComputeResourceId $ComputeResourceObject.Id -Name $Resourcepool

                        $ResourcePoolJSON = @"
                    
                            {
                                "key": "resourcePool",
                                "value": {
                                    "type": "entityRef",
                                    "componentId": null,
                                    "classId": "ResourcePools",
                                    "id": "$($ResourcePoolObject.id)",
                                    "label": "$($ResourcePoolObject.name)"
                                }
                            }                     
"@
                    
                    $ReservationObject.extensionData.entries += ($ResourcePoolJSON | ConvertFrom-Json)                
                                    
                    }

                    # --- Set the quota

                    $MachineQuotaJSON = @"
                   
                        {
                            "key": "machineQuota",
                            "value": {
                                "type": "integer",
                                "value": $($Quota)
                            }  
                        } 
"@
                                                                 
                    $ReservationObject.extensionData.entries += ($MachineQuotaJSON | ConvertFrom-Json)               

                    # --- Set the networks

                    $ReservationNetworksJSON = @"
                    
                        {
                            "key": "reservationNetworks",
                            "value": {
                                "type": "multiple",
                                "elementTypeId": "COMPLEX",
                                "items": []
                            }
                        }
"@

                    $ReservationNetworks = $ReservationNetworksJSON | ConvertFrom-Json

                    foreach ($NetworkName in $Network) {

                        $NetworkObject = Get-vRAReservationNetwork -SchemaClassId $SchemaClassId -ComputeResourceId $ComputeResourceObject.Id -Name $NetworkName

                        $ReservationNetworks.value.items += $NetworkObject

                    }

                    $ReservationObject.extensionData.entries += $ReservationNetworks

                    # --- Set the storage

                    

                    # --- Set the memory
                    #TODO Add validation
                    #$MemoryObject = Get-vRAReservationMemory -SchemaClassId $SchemaClassId -ComputeResourceId $ComputeResourceObject.id

                    $ReservationMemoryJson = @"

                        {
                            "key":  "reservationMemory",
                            "value":  {
                                "type":  "complex",
                                "componentTypeId":  "com.vmware.csp.iaas.blueprint.service",
                                "componentId":  null,
                                "classId":  "Infrastructure.Reservation.Memory",
                                "typeFilter":  null,
                                "values":  {
                                     "entries":  [
                                        {
                                            "key":  "memoryReservedSizeMb",
                                            "value":  {
                                                "type":  "integer",
                                                "value":  $($Memory)
                                            }
                                        }
                                    ]
                                }
                            }

                        }
"@

                    $ReservationObject.extensionData.entries += ($ReservationMemoryJson | ConvertFrom-Json)

                    break

                }

            }
    
            $Body = $ReservationObject | ConvertTo-Json -Depth 100

            $Body

            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/reservation-service/api/reservations"
                
                Write-Verbose -Message "Preparing POST to $($URI)"  

                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body

                Write-Verbose -Message "Success"

                # --- Output the Successful Result
                Get-vRAReservation -Name $Name
            }

        }
        catch [Exception]{

            throw
        }
    }
    end {
        
    }
}