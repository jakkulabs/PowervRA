function New-vRAReservation {
<#
    .SYNOPSIS
    Create a new reservation

    .DESCRIPTION
    Create a new reservation

    .PARAMETER Name
    The name of the reservation

    .PARAMETER Description
    A description of the reservation

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

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$ReservationPolicy,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$Priority = 0,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$ComputeResource,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$Quota = 0,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$MemoryMB,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [PSObject[]]$Storage,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [PSObject[]]$Network,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Resourcepool,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$EnableAlerts = $false,

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
    [ValidateNotNullOrEmpty()]
    [String]$JSON
    )
    
    DynamicParam {

        # --- Define the parameter dictionary
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary           

        # --- Dynamic Param:Type
        $ParameterName = "Type"

        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.ParameterSetName = "Standard"

        $AttributeCollection =  New-Object System.Collections.ObjectModel.Collection[System.Attribute]        
        $AttributeCollection.Add($ParameterAttribute)

        # --- Set the dynamic values
        $ValidateSetValues = Get-vRAReservationType | Select -ExpandProperty Name

        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($ValidateSetValues)
        $AttributeCollection.Add($ValidateSetAttribute)
        
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [String], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)

        # --- Dynamic Param:Tenant
        $ParameterName = "Tenant"

        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.ParameterSetName = "Standard"
        
        $AttributeCollection =  New-Object System.Collections.ObjectModel.Collection[System.Attribute]        
        $AttributeCollection.Add($ParameterAttribute)

        # --- Set the dynamic values
        $ValidateSetValues = (Invoke-vRARestMethod -Method GET -URI "/reservation-service/api/reservations/tenants?limit=9999").content | Select-Object -ExpandProperty id
        
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($ValidateSetValues)
        $AttributeCollection.Add($ValidateSetAttribute)

        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [String], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)

        # --- Dynamic Param:BusinessGroup

        $ParameterName = "BusinessGroup"

        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.ParameterSetName = "Standard"

        $AttributeCollection =  New-Object System.Collections.ObjectModel.Collection[System.Attribute]        
        $AttributeCollection.Add($ParameterAttribute)

        # --- Set the dynamic values
        $ValidateSetValues = (Invoke-vRARestMethod -Method GET -URI "/reservation-service/api/reservations/subtenants?limit=9999&tenantId=$($Tenant)").content | Select-Object -ExpandProperty name
        
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($ValidateSetValues)
        $AttributeCollection.Add($ValidateSetAttribute)

        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [String], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)

        # --- Return the dynamic parameters
        return $RuntimeParameterDictionary

    } 

    begin {
    
    }
    
    process {

        try {

            switch ($PSCmdlet.ParameterSetName){

                'JSON' {

                    # --- Handle JSON PARAM
                    $Body = $JSON
                    $Data = ($JSON | ConvertFrom-Json)      
                    $Name = $Data.name

                    break

                }

                'Standard' {

                    Write-Verbose -Message "Preparing reservation payload"
                    
                    #Get the reservation type id
                    $ReservationTypeId = (Get-vRAReservationType -Name $PSBoundParameters.Type).id

                    $TenantId = $PSBoundParameters.Tenant
                    
                    $BusinessGroupId = (Get-vRABusinessGroup -TenantId $TenantId -Name $PSBoundParameters.BusinessGroup).id

                    if ($PSBoundParameters.ContainsKey("ReservationPolicy")){

                        $ReservationPolicyId = (Get-vRAReservationPolicy -Name $ReservationPolicy).id

                    }
                    else {

                        $ReservationPolicyId = "null"

                    }

                    $JSON = @"
                        {
                          "name": "$($Name)",
                          "reservationTypeId": "$($ReservationTypeId)",
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

                    # --- Convert the body to an object and begin adding extensionData
                    $ReservationObject = $JSON | ConvertFrom-Json

                    # --- Set the compute resource
                    if ($PSBoundParameters.Type -eq "vSphere") {

                        Write-Verbose -Message "Creating reservation for type $($PSBoundParameters.Type)"

                        $ComputeResourceObject = Get-vRAReservationComputeResource -Type $PSBoundParameters.Type -Name $ComputeResource

                        Write-Verbose -Message "Found compute resource $($ComputeResource)"

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

                        # --- Set the quota

                        Write-Verbose -Message "Setting machine quota to $($Quota)"

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
                        Write-Verbose -Message "Setting networks"

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

                        foreach ($NetworkDefinition in $Network) {

                            $ReservationNetworks.value.items += $NetworkDefinition

                        }

                        $ReservationObject.extensionData.entries += $ReservationNetworks

                        # --- Set the storage
                        Write-Verbose -Message "Setting storage"

                        $ReservationStoragesJSON = @"

                            {
                                "key":  "reservationStorages",
                                "value":  {
                                    "type":  "multiple",
                                    "elementTypeId":  "COMPLEX",
                                    "items":  []

                                }
                            }
"@

                        $ReservationStorages = $ReservationStoragesJSON | ConvertFrom-Json

                        foreach ($StorageDefinition in $Storage) {

                            $ReservationStorages.value.items += $StorageDefinition

                        }

                        $ReservationObject.extensionData.entries += $ReservationStorages
                   
                        # --- Set the memory
                        #TODO Add validation
                        Write-Verbose -Message "Setting memory"

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
                                                    "value":  $($MemoryMB)
                                                }
                                            }
                                        ]
                                    }
                                }

                            }
"@

                        $ReservationObject.extensionData.entries += ($ReservationMemoryJson | ConvertFrom-Json)

                        # --- Set the resource pool
                        Write-Verbose "Setting resource pool"

                        if ($PSBoundParameters.ContainsKey("ResourcePool")){

                            $ResourcePoolObject = Get-vRAReservationResourcePool -Type $PSBoundParameters.Type -ComputeResourceId $ComputeResourceObject.Id -Name $Resourcepool

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

                    }

                    break

                }

            }
    
            $Body = $ReservationObject | ConvertTo-Json -Depth 500

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