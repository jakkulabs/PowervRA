function New-vRAReservation {
<#
    .SYNOPSIS
    Create a new reservation

    .DESCRIPTION
    Create a new reservation

    .PARAMETER Type
    The reservation type

    .PARAMETER Name
    The name of the reservation

    .PARAMETER Tenant
    The tenant that will own the reservation

    .PARAMETER BusinessGroup
    The business group that will be associated with the reservation

    .PARAMETER ReservationPolicy
    The reservation policy that will be associated with the reservation

    .PARAMETER Priority
    The priority of the reservation

    .PARAMETER ComputeResource
    The compute resource that will be associated with the reservation

    .PARAMETER Quota
    The number of machines that can be provisioned in the reservation

    .PARAMETER MemoryMB
    The amount of memory available to this reservation

    .PARAMETER Storage

    .PARAMETER Network

    .PARAMETER ResourcePool

    .PARAMETER EnableAlerts

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
    [String]$Type,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Tenant = $Global:vRAConnection.Tenant,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$BusinessGroup,

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
                  
                    $ReservationTypeId = (Get-vRAReservationType -Name $PSBoundParameters.Type).id

                    $BusinessGroupId = (Get-vRABusinessGroup -TenantId $TenantId -Name $BusinessGroup).id

                    if ($PSBoundParameters.ContainsKey("ReservationPolicy")){

                        $ReservationPolicyId = (Get-vRAReservationPolicy -Name $ReservationPolicy).id

                    }
                    else {

                        $ReservationPolicyId = "null"

                    }

                    Write-Verbose -Message "Reservation name is $($Name)"
                    Write-Verbose -Message "ReservationTypeId for $PSBoundParameters.Types is $ReservationTypeId"
                    Write-Verbose -Message "Tenant is $($Tenant)"
                    Write-Verbose -Message "BusinessGroupId for $BusinessGroup is $BusinessGroupId"
                    Write-Verbose -Message "ReservationPolicyId for $ReservationPolicy is $ReservationPolicyId"
                    Write-Verbose -Message "Priority is $($Priority)"
                    Write-Verbose -Message "Alerts enabled: $($EnableAlerts)"

                    $Template = @"
                        {
                          "name": "$($Name)",
                          "reservationTypeId": "$($ReservationTypeId)",
                          "tenantId": "$($Tenant)",
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
                    $ReservationObject = $Template | ConvertFrom-Json

                    switch ($PSBoundParameters.Type) {

                        'vSphere' {

                            # --- 
                            # --- Compute Resource
                            # ---

                            Write-Verbose -Message "Adding extensionData for reservation for type $($PSBoundParameters.Type)"

                            $ComputeResourceObject = Get-vRAReservationComputeResource -Type $PSBoundParameters.Type -Name $ComputeResource

                            Write-Verbose -Message "Found compute resource $($ComputeResource) with id $($ComputeResource.id)"

                            $ComputeResourceTemplate = @"

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
                    
                            $ReservationObject.extensionData.entries += ($ComputeResourceTemplate | ConvertFrom-Json)

                            # --- 
                            # --- Machine Quota
                            # ---

                            Write-Verbose -Message "Setting machine quota to $($Quota)"

                            $MachineQuotaTemplate = @"
                   
                                {
                                    "key": "machineQuota",
                                    "value": {
                                        "type": "integer",
                                        "value": $($Quota)
                                    }  
                                } 
"@
                                                                 
                            $ReservationObject.extensionData.entries += ($MachineQuotaTemplate | ConvertFrom-Json)

                            # --- 
                            # --- Reservation Networks
                            # ---
                            
                            Write-Verbose -Message "Setting reservation networks"

                            $ReservationNetworksTemplate = @"
                    
                                {
                                    "key": "reservationNetworks",
                                    "value": {
                                        "type": "multiple",
                                        "elementTypeId": "COMPLEX",
                                        "items": []
                                    }
                                }
"@

                            $ReservationNetworks = $ReservationNetworksTemplate | ConvertFrom-Json

                            foreach ($NetworkDefinition in $Network) {

                                $ReservationNetworks.value.items += $NetworkDefinition

                            }

                            $ReservationObject.extensionData.entries += $ReservationNetworks

                            # ---
                            # --- Reservation Storages
                            # ---

                            Write-Verbose -Message "Setting reservation storage"

                            $ReservationStoragesTemplate = @"

                                {
                                    "key":  "reservationStorages",
                                    "value":  {
                                        "type":  "multiple",
                                        "elementTypeId":  "COMPLEX",
                                        "items":  []

                                    }
                                }
"@

                            $ReservationStorages = $ReservationStoragesTemplate | ConvertFrom-Json

                            foreach ($StorageDefinition in $Storage) {

                                $ReservationStorages.value.items += $StorageDefinition

                            }

                            $ReservationObject.extensionData.entries += $ReservationStorages
                   
                            # ---
                            # --- Reservation Memory
                            # ---

                            Write-Verbose -Message "Setting reservation memory"

                            $ReservationMemoryTemplate = @"

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

                            $ReservationObject.extensionData.entries += ($ReservationMemoryTemplate | ConvertFrom-Json)

                            # --- 
                            # --- Resource Pool
                            # ---

                            if ($PSBoundParameters.ContainsKey("ResourcePool")){

                                Write-Verbose "Setting resource pool"

                                $ResourcePoolObject = Get-vRAReservationResourcePool -Type $PSBoundParameters.Type -ComputeResourceId $ComputeResourceObject.Id -Name $Resourcepool

                                $ResourcePoolTemplate = @"
                    
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
                    
                                $ReservationObject.extensionData.entries += ($ResourcePoolTemplate | ConvertFrom-Json)                
                                    
                        }


                        break

                    }

                        'Amazon' {
                        
                            Write-Verbose -Message "Support for this reservation type has not been added"
                            break

                        }

                        'OpenStack' {
                        
                            Write-Verbose -Message "Support for this reservation type has not been added"
                            break

                        }

                        'vCloud' {
                        
                            Write-Verbose -Message "Support for this reservation type has not been added"
                            break                        
                        
                        }

                        'vCloud Air' {
                        
                            Write-Verbose -Message "Support for this reservation type has not been added"
                            break                        
                        
                        }

                        'HyperV' {
                        
                            Write-Verbose -Message "Support for this reservation type has not been added"
                            break                        
                        
                        }

                        'KVM' {
                        
                            Write-Verbose -Message "Support for this reservation type has not been added"
                            break                        
                        
                        }

                        'SCVMM' {
                        
                            Write-Verbose -Message "Support for this reservation type has not been added"
                            break                        
                        
                        }

                        'XenServer' {
                        
                            Write-Verbose -Message "Support for this reservation type has not been added"
                            break                        
                        
                        }    

                    }

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