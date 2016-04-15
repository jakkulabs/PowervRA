function Set-vRAReservation {
<#
    .SYNOPSIS
    Set a vRA reservation

    .DESCRIPTION
    Set a vRA reservation

    .PARAMETER Id
    The Id of the reservation

    .PARAMETER Name
    The name of the reservation

    .PARAMETER ReservationPolicy
    The reservation policy that will be associated with the reservation

    .PARAMETER Priority
    The priority of the reservation

    .PARAMETER Quota
    The number of machines that can be provisioned in the reservation

    .PARAMETER MemoryGB
    The amount of memory available to this reservation

    .PARAMETER ResourcePool
    The resource pool that will be associated with this reservation

    .PARAMETER EnableAlerts
    Enable alerts

    .PARAMETER EmailBusinessGroupManager
    Email the alerts to the business group manager

    .PARAMETER AlertRecipients
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

    .INPUTS
    System.String
    System.Int
    System.Management.Automation.SwitchParameter
    System.Management.Automation.PSObject

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAReservation -Name Reservation01 | Set-vRAReservation -Name Reservation01-Updated

    .EXAMPLE
    Set-vRAReservation -Id 75ae3400-beb5-4b0b-895a-0484413c93b1 -ReservationPolicy "ReservationPolicy01"

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$ReservationPolicy,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$Priority = 0,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Switch]$Enabled,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$Quota = 0,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$MemoryGB,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNull()]
    [String]$ResourcePool,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Switch]$EnableAlerts,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Switch]$EmailBusinessGroupManager,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$AlertRecipients,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$StorageAlertPercentageLevel,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$MemoryAlertPercentageLevel,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$CPUAlertPercentageLevel,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$MachineAlertPercentageLevel,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$AlertFrequencyReminder

    )
 
    begin {
    
    }
    
    process {

        try {

            # --- Get the reservation

            $URI = "/reservation-service/api/reservations/$($id)"

            $Reservation = Invoke-vRARestMethod -Method GET -URI $URI

            $ReservationTypeName = (Get-vRAReservationType -Id $Reservation.reservationTypeId).name

            $ComputeResourceId = ($Reservation.extensionData.entries | Where-Object {$_.key -eq "computeResource"}).value.id

            # --- Set generic reservation properties

            if ($PSBoundParameters.ContainsKey("Name")) {

                Write-Verbose -Message "Updating Name: $($Reservation.name) >> $($Name)"

                $Reservation.name = $Name

            }

            if ($PSBoundParameters.ContainsKey("ReservationPolicy")) {               

                Write-Verbose -Message "Updating Reservation Policy: $($ReservationPolicy)"

                $ReservationPolicyId = (Get-vRAReservationPolicy -Name $ReservationPolicy).id

                $Reservation.reservationPolicyId = $ReservationPolicyId

            }

            if ($PSBoundParameters.ContainsKey("Priority")) {               

                Write-Verbose -Message "Updating Priority: $($Reservation.priority) >> $($Priority)"

                $Reservation.priority = $Priority

            }

            if ($PSBoundParameters.ContainsKey("Enabled")) {
            
                if ($Enabled) {
                                                          
                    $BoolAsString = "true"
                
                }
                else {

                    $BoolAsString = "false"

                }
                
                Write-Verbose -Message "Updating Reservation Status: $($Reservation.enabled) >> $($BoolAsString)"                                                     

                $Reservation.enabled = $BoolAsString

            }

            if ($PSBoundParameters.ContainsKey("EnableAlerts")) {
            
                if ($EnableAlerts) {
                                                          
                    $BoolAsString = "true"
                
                }
                else {

                    $BoolAsString = "false"

                }
                
                Write-Verbose -Message "Updating Alert Policy Status: $($Reservation.alertPolicy.enabled) >> $($BoolAsString)"                               

                $Reservation.alertPolicy.enabled = $BoolAsString

            }

            if ($PSBoundParameters.ContainsKey("AlertReminderFrequency")){

                Write-Verbose "Updating Alert Policy Reminder Frequency: $($Reservation.alertPolicy.frequencyReminder) >> $($AlertFrequencyReminder)"

                $Reservation.alertPolicy.frequencyReminder = $AlertReminderFrequency

            }

            if ($PSBoundParameters.ContainsKey("AlertRecipients")){

                Write-Verbose -Message "Updating recipients list with $($AlertRecipients.Count) new contact(s)"

                foreach ($Recipient in $AlertRecipients) {

                    $Reservation.alertPolicy.recipients += $Recipient

                }

            }

            if ($PSBoundParameters.ContainsKey("EmailBusinessGroupManager")) {
            
                if ($EmailBusinessGroupManager) {
                                                          
                    $BoolAsString = "true"
                
                }
                else {

                    $BoolAsString = "false"

                }
                
                Write-Verbose "Updating Email Business Group Manager Status: $($Reservation.alertPolicy.emailBgMgr) >> $($BoolAsString)"                                               

                $Reservation.alertPolicy.emailBgMgr = $BoolAsString

            }

            # --- Set type specific properties

            switch ($ReservationTypeName) {

                'vSphere' {

                    # ---
                    # --- Alert Policy
                    # ---                

                    if ($PSBoundParameters.ContainsKey("StorageAlertPercentageLevel")) {

                        Write-Verbose -Message "Setting Storage Alert Threshold To $($StorageAlertPercentageLevel)"

                        $AlertPolicy = $Reservation.alertPolicy

                        $StorageAlert = $AlertPolicy.alerts |  Where-Object {$_.referenceResourceId -eq "storage"}

                        $StorageAlert.alertPercentLevel = $StorageAlertPercentageLevel

                    }

                    if ($PSBoundParameters.ContainsKey("MemoryAlertPercentageLevel")){

                        Write-Verbose -Message "Setting Memory Alert Threshold To $($MemoryAlertPercentageLevel)"

                        $AlertPolicy = $Reservation.alertPolicy

                        $MemoryAlert = $AlertPolicy.alerts |  Where-Object {$_.referenceResourceId -eq "memory"}

                        $MemoryAlert.alertPercentLevel = $MemoryAlertPercentageLevel

                    }

                    if ($PSBoundParameters.ContainsKey("CPUAlertPercentageLevel")){

                        Write-Verbose -Message "Setting CPU Alert Threshold To $($CPUAlertPercentageLevel)"

                        $AlertPolicy = $Reservation.alertPolicy

                        $CPUAlert = $AlertPolicy.alerts |  Where-Object {$_.referenceResourceId -eq "cpu"}

                        $CPUAlert.alertPercentLevel = $CPUAlertPercentageLevel

                    }

                    if ($PSBoundParameters.ContainsKey("MachineAlertPercentageLevel")){

                        Write-Verbose -Message "Setting Machine Alert Threshold To $($MachineAlertPercentageLevel)"

                        $AlertPolicy = $Reservation.alertPolicy

                        $MachineAlert = $AlertPolicy.alerts |  Where-Object {$_.referenceResourceId -eq "machine"}

                        $MachineAlert.alertPercentLevel = $MachineAlertPercentageLevel

                    }

                    # ---
                    # --- Machine Quota
                    # ---

                    if ($PSBoundParameters.ContainsKey("Quota")) {

                        $MachineQuota = $Reservation.extensionData.entries | Where-Object {$_.key -eq "machineQuota"}

                        Write-Verbose "Updating Machine Quota: $($MachineQuota.value.value) >> $($Quota)"

                        $MachineQuota.value.value = $Quota

                    }

                    # ---
                    # --- Reservation Memory
                    # ---

                    if ($PSBoundParameters.ContainsKey("MemoryGB")) {

                        # --- Calculate the memory value in MB

                        $MemoryMB = [Math]::Round(($MemoryGB * 1024 * 1024 * 1024 / 1MB),4,[MidPointRounding]::AwayFromZero)  

                        $ReservationMemory = $Reservation.extensionData.entries | Where-Object {$_.key -eq "reservationMemory"}

                        $MemoryReservedSizeMb = $ReservationMemory.value.values.entries | Where-Object {$_.key -eq "memoryReservedSizeMb"}

                        Write-Verbose "Updating Machine allocated Memory: $($MemoryReservedSizeMb.value.value) >> $($MemoryMB)"

                        $MemoryReservedSizeMb.value.value = $MemoryMB

                    }

                    # ---
                    # --- ResourcPool
                    # ---

                    if ($PSBoundParameters.ContainsKey("ResourcePool")) {

                        # --- Test to see if a resource pool currently exists

                        $ResourcePoolObject = $Reservation.extensionData.entries | Where-Object {$_.key -eq "resourcePool"}

                        if ($ResourcePoolObject) {

                            if ($ResourcePool -eq '') {

                                # --- Remove the resource pool from the reservation

                                Write-Verbose "Removing resource pool"

                                $Reservation.extensionData.entries = $Reservation.extensionData.entries | Where-Object {$_.key -ne "resourcePool"}


                            }
                            else {

                                # --- Update the existing resource pool                            

                                $NewResourcePool = Get-vRAReservationComputeResourceResourcePool -Type $ReservationTypeName -ComputeResourceId $ComputeResourceId -Name $ResourcePool

                                $ResourcePoolId = $NewResourcePool.id

                                $ResourcePoolLabel = $NewResourcePool.label

                                Write-Verbose "Updating Resource Pool: $($ResourcePoolObject.value.label) >> $($ResourcePool)"                        

                                $ResourcePoolObject.value.id = $ResourcePoolId

                                $ResourcePoolObject.value.label = $ResourcePoolLabel

                            }

                        }
                        else {

                            Write-Verbose -Message "Setting Resource Pool To $($ResourcePool)"

                            $NewResourcePool = Get-vRAReservationComputeResourceResourcePool -Type $ReservationTypeName -ComputeResourceId $ComputeResourceId -Name $ResourcePool                        

                            $ResourcePoolTemplate = @"
                    
                                {
                                    "key": "resourcePool",
                                    "value": {
                                        "type": "entityRef",
                                        "componentId": null,
                                        "classId": "ResourcePools",
                                        "id": "$($NewResourcePool.Id)",
                                        "label": "$($NewResourcePool.Label)"
                                    }
                                }                     
"@
                    
                            $Reservation.extensionData.entries += ($ResourcePoolTemplate | ConvertFrom-Json)                
                                    
                        }
                    
                    }           
 
                    break
                }

                'vCloud Air' {

                    # ---
                    # --- Alert Policy
                    # ---                

                    if ($PSBoundParameters.ContainsKey("StorageAlertPercentageLevel")) {

                        Write-Verbose -Message "Setting Storage Alert Threshold To $($StorageAlertPercentageLevel)"

                        $AlertPolicy = $Reservation.alertPolicy

                        $StorageAlert = $AlertPolicy.alerts |  Where-Object {$_.referenceResourceId -eq "storage"}

                        $StorageAlert.alertPercentLevel = $StorageAlertPercentageLevel

                    }

                    if ($PSBoundParameters.ContainsKey("MemoryAlertPercentageLevel")){

                        Write-Verbose -Message "Setting Memory Alert Threshold To $($MemoryAlertPercentageLevel)"

                        $AlertPolicy = $Reservation.alertPolicy

                        $MemoryAlert = $AlertPolicy.alerts |  Where-Object {$_.referenceResourceId -eq "memory"}

                        $MemoryAlert.alertPercentLevel = $MemoryAlertPercentageLevel

                    }

                    if ($PSBoundParameters.ContainsKey("CPUAlertPercentageLevel")){

                        Write-Verbose -Message "Setting CPU Alert Threshold To $($CPUAlertPercentageLevel)"

                        $AlertPolicy = $Reservation.alertPolicy

                        $CPUAlert = $AlertPolicy.alerts |  Where-Object {$_.referenceResourceId -eq "cpu"}

                        $CPUAlert.alertPercentLevel = $CPUAlertPercentageLevel

                    }

                    if ($PSBoundParameters.ContainsKey("MachineAlertPercentageLevel")){

                        Write-Verbose -Message "Setting Machine Alert Threshold To $($MachineAlertPercentageLevel)"

                        $AlertPolicy = $Reservation.alertPolicy

                        $MachineAlert = $AlertPolicy.alerts |  Where-Object {$_.referenceResourceId -eq "machine"}

                        $MachineAlert.alertPercentLevel = $MachineAlertPercentageLevel

                    }

                    # ---
                    # --- Machine Quota
                    # ---

                    if ($PSBoundParameters.ContainsKey("Quota")) {

                        $MachineQuota = $Reservation.extensionData.entries | Where-Object {$_.key -eq "machineQuota"}

                        Write-Verbose "Updating Machine Quota: $($MachineQuota.value.value) >> $($Quota)"

                        $MachineQuota.value.value = $Quota

                    }

                    # ---
                    # --- Reservation Memory
                    # ---

                    if ($PSBoundParameters.ContainsKey("MemoryGB")) {

                        # --- Calculate the memory value in MB

                        $MemoryMB = [Math]::Round(($MemoryGB * 1024 * 1024 * 1024 / 1MB),4,[MidPointRounding]::AwayFromZero)                          

                        $ReservationMemory = $Reservation.extensionData.entries | Where-Object {$_.key -eq "reservationMemory"}

                        $MemoryReservedSizeMb = $ReservationMemory.value.values.entries | Where-Object {$_.key -eq "memoryReservedSizeMb"}

                        Write-Verbose "Updating Machine allocated Memory: $($MemoryReservedSizeMb.value.value) >> $($MemoryMB)"

                        $MemoryReservedSizeMb.value.value = $MemoryMB

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
    
            if ($PSCmdlet.ShouldProcess($Id)){

                $URI = "/reservation-service/api/reservations/$($Id)"
                
                Write-Verbose -Message "Preparing PUT to $($URI)"  

                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body ($Reservation | ConvertTo-Json -Depth 500)

                Write-Verbose -Message "SUCCESS"

                # --- Output the Successful Result
                Get-vRAReservation -Id $Id
            }

        }
        catch [Exception]{

            throw
        }
    }
    end {
        
    }
}