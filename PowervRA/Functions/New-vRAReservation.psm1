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
    The storage that will be associated with the reservation

    .PARAMETER Network
    The network that will be associated with this reservation

    .PARAMETER ResourcePool
    The resource pool that will be associated with this reservation

    .PARAMETER EnableAlerts
    Enable alerts

    .PARAMETER EmailBusinessGroupManager
    Email the alerts to the business group manager

    .PARAMETER Recipients
    The recipients that will recieve email alerts

    .PARAMETER StorageAlertPercentageLevel
    The threshold for storage alerts

    .PARAMETER MemoryAlertPercentageLevel
    The threshold for memory alerts

    .PARAMETER CPUAlertPercentageLevel
    The threshold for cpu alerts

    .PARAMETER MachineAlertPercentageLevel
    The threshold for machine alerts

    .PARAMETER AlertFrequencyReminder
    Alert frequency in days

    .PARAMETER JSON
    Body text to send in JSON format

    .PARAMETER NewName
    If passing a JSON payload NewName can be used to set the reservation name

    .INPUTS
    System.String
    System.Int
    System.Management.Automation.PSObject

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    # --- Get the compute resource id
    $ComputeResource = Get-vRAReservationComputeResource -Type vSphere -Name "Cluster01 (vCenter)"

    # --- Get the network definition
    $NetworkDefinitionArray = @()
    $Network1 = New-vRAReservationNetworkDefinition -Type vSphere -ComputeResourceId $ComputeResource.Id -Path "VM Network" -Profile "Test-Profile"
    $NetworkDefinitionArray += $Network1

    # --- Get the storage definition
    $StorageDefinitionArray = @()
    $Storage1 = New-vRAReservationStorageDefinition -Type vSphere -ComputeResourceId $ComputeResource.Id -Path "Datastore1" -ReservedSizeGB 10 -Priority 0 
    $StorageDefinitionArray += $Storage1

    # --- Set the parameters and create the reservation
    $Param = @{

        Type = "vSphere"
        Name = "Reservation01"
        Tenant = "Tenant01"
        BusinessGroup = "Default Business Group[Tenant01]"
        #ReservationPolicy = ""
        #Priority = 0
        ComputeResource = "Cluster01 (vCenter)"
        #Quota = 0
        MemoryMB = 2048
        Storage = $StorageDefinitionArray
        Resourcepool = "Resources"
        Network = $NetworkDefinitionArray
        EnableAlerts = $false

    }

    New-vRAReservation @Param -Verbose


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
    [ValidateSet("TRUE","FALSE")]
    [String]$EnableAlerts = "FALSE",

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateSet("TRUE","FALSE")]
    [String]$EmailBusinessGroupManager = "FALSE",

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Recipients,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$StorageAlertPercentageLevel = 80,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$MemoryAlertPercentageLevel = 80,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$CPUAlertPercentageLevel = 80,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$MachineAlertPercentageLevel = 80,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$AlertFrequencyReminder = 20,

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
    [ValidateNotNullOrEmpty()]
    [String]$JSON,

    [parameter(Mandatory=$false,ParameterSetName="JSON")]
    [ValidateNotNullOrEmpty()]
    [String]$NewName

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

                    # --- if a new name has been passed set it
                    if ($PSBoundParameters.ContainsKey("NewName")){

                        Write-Verbose -Message "Setting reservaiton name to $($NewName)"

                        $Data.name = $NewName

                        $Body = $Data | ConvertTo-Json -Depth 100 -Compress

                    }

                    break

                }

                'Standard' {

                    Write-Verbose -Message "Preparing reservation payload"
                  
                    $ReservationTypeId = (Get-vRAReservationType -Name $Type).id

                    $BusinessGroupId = (Get-vRABusinessGroup -TenantId $Tenant -Name $BusinessGroup).id

                    if ($PSBoundParameters.ContainsKey("ReservationPolicy")){

                        $ReservationPolicyId = (Get-vRAReservationPolicy -Name $ReservationPolicy).id

                    }
                    else {

                        $ReservationPolicyId = "null"

                    }

                    Write-Verbose -Message "Reservation name is $($Name)"
                    Write-Verbose -Message "ReservationTypeId for $($Type) is $($ReservationTypeId)"
                    Write-Verbose -Message "Tenant is $($Tenant)"
                    Write-Verbose -Message "BusinessGroupId for $($BusinessGroup) is $($BusinessGroupId)"
                    Write-Verbose -Message "ReservationPolicyId for $($ReservationPolicy) is $($ReservationPolicyId)"
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
                            "enabled": $($EnableAlerts.ToLower()),
                            "frequencyReminder": 20,
                            "emailBgMgr": $($EmailBusinessGroupManager.ToLower()),
                            "recipients": [],
                            "alerts": []
                          },
                          "extensionData": {
                            "entries": []
                          }
                        }
"@

                    # --- Convert the body to an object and begin adding extensionData
                    $ReservationObject = $Template | ConvertFrom-Json

                    if ($EnableAlerts -eq "TRUE" -and $PSBoundParameters.ContainsKey("Recipients")) {

                        foreach ($Recipient in $Recipients) {

                            $ReservationObject.alertPolicy.recipients += $Recipient

                        }

                    }

                    switch ($PSBoundParameters.Type) {

                        'vSphere' {
                            
                            # ---
                            # --- Alert Policy
                            # ---

                            $AlertsTemplate = @"

                                [

                                    {
                                        "alertPercentLevel": $($StorageAlertPercentageLevel),
                                        "referenceResourceId": "storage",
                                        "id": "storage"
                                    },
                                    {
                                        "alertPercentLevel": $($MemoryAlertPercentageLevel),
                                        "referenceResourceId": "memory",
                                        "id": "memory"
                                    },
                                    {
                                        "alertPercentLevel": $($CPUAlertPercentageLevel),
                                        "referenceResourceId": "cpu",
                                        "id": "cpu"
                                    },
                                    {
                                       "alertPercentLevel": $($MachineAlertPercentageLevel),
                                        "referenceResourceId": "machine",
                                        "id": "machine"
                                    }

                                ]
"@
                            
                            $ReservationObject.alertPolicy.alerts += $AlertsTemplate | ConvertFrom-Json                            

                            # --- 
                            # --- Compute Resource
                            # ---

                            Write-Verbose -Message "Adding extensionData for type $($Type)"

                            $ComputeResourceObject = Get-vRAReservationComputeResource -Type $Type -Name $ComputeResource

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

                                $ResourcePoolObject = Get-vRAReservationResourcePool -Type $Type -ComputeResourceId $ComputeResourceObject.Id -Name $Resourcepool

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

                        'vCloud Air' {

                            # ---
                            # --- Alert Policy
                            # ---

                            $AlertsTemplate = @"

                                [

                                    {
                                        "alertPercentLevel": $($StorageAlertPercentageLevel),
                                        "referenceResourceId": "storage",
                                        "id": "storage"
                                    },
                                    {
                                        "alertPercentLevel": $($MemoryAlertPercentageLevel),
                                        "referenceResourceId": "memory",
                                        "id": "memory"
                                    },
                                    {
                                        "alertPercentLevel": $($CPUAlertPercentageLevel),
                                        "referenceResourceId": "cpu",
                                        "id": "cpu"
                                    },
                                    {
                                       "alertPercentLevel": $($MachineAlertPercentageLevel),
                                        "referenceResourceId": "machine",
                                        "id": "machine"
                                    }

                                ]
"@
                            
                            $ReservationObject.alertPolicy.alerts += $AlertsTemplate | ConvertFrom-Json                            

                            # --- 
                            # --- Compute Resource
                            # ---

                            Write-Verbose -Message "Adding extensionData for type $($Type)"

                            $ComputeResourceObject = Get-vRAReservationComputeResource -Type $Type -Name $ComputeResource

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


                    $Body = $ReservationObject | ConvertTo-Json -Depth 500

                }

            }
    
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