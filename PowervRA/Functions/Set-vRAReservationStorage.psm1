function Set-vRAReservationStorage {
<#
    .SYNOPSIS
    Set vRA reservation storage properties

    .DESCRIPTION
    Set vRA reservation storage properties

    .PARAMETER Id
    The Id of the reservation

    .PARAMETER Path
    The storage path
    
    .PARAMETER ReservationSizeGB
    The size in GB of this reservation
    
    .PARAMETER Priority
    The priority of storage
    
    .PARAMETER Enabled
    The status of the storage    

    .INPUTS
    System.String.
    System.Int.
    System.Management.Automation.SwitchParameter

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAReservation -Name "Reservation01" | Set-vRAReservationStorage -Path "Datastore01"  -ReservedSizeGB 20 -Priority 10

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName)]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Path,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [Int]$ReservedSizeGB,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [Int]$Priority,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [Switch]$Enabled

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

            # ---
            # --- Set Storage Properties
            # ---

            Write-Verbose -Message "Removing Storage From Reservation"

            $ReservationStoragePath = (Get-vRAReservationComputeResourceStorage -Type $ReservationTypeName -ComputeResourceId $ComputeResourceId -Name $Path).values.entries | Where-Object {$_.key -eq "storagePath"}

            $ReservationStoragePathId = $ReservationStoragePath.value.id

            $Storage = $Reservation.extensionData.entries | Where-Object {$_.key -eq "reservationStorages"}  

            $StorageItems = $Storage.value.items

            foreach ($Item in $StorageItems) {

                $StoragePath = $item.values.entries | Where-Object {$_.key -eq "StoragePath"}                

                if ($StoragePath.value.id -eq $ReservationStoragePathId) {

                    if ($PSBoundParameters.ContainsKey("ReservedSizeGB")){

                        $StorageReservedSizeGB = $item.values.entries | Where-Object {$_.key -eq "storageReservedSizeGB"}

                        Write-Verbose -Message "Setting Storage Reservation Size: $($StorageReservedSizeGB.value.value) >> $($ReservedSizeGB)"

                        $StorageReservedSizeGB.value.value = $ReservedSizeGB

                    }
                
                    if ($PSBoundParameters.ContainsKey("Priority")){

                        $StorageReservationPriority = $item.values.entries | Where-Object {$_.key -eq "storageReservationPriority"}

                        Write-Verbose -Message "Setting Storage Reservation Priority: $($StorageReservationPriority.value.value) >> $($Priority)"
                        
                        $StorageReservationPriority.value.value = $Priority                        

                    }

                    if ($PSBoundParameters.ContainsKey("Enabled")){

                        if ($Enabled) {

                            $BoolAsString = "true"                            

                        }
                        else {

                            $BoolAsString = "false"

                        }

                        $StorageEnabled = $item.values.entries | Where-Object {$_.key -eq "storageEnabled"}

                        Write-Verbose -Message "Setting Storage Reservation Priority: $($StorageEnabled.value.value) >> $($BoolAsString)"

                        $StorageEnabled.value.value = $BoolAsString

                    }

                }

            }

            if ($PSCmdlet.ShouldProcess($Id)){

                $URI = "/reservation-service/api/reservations/$($Id)"
                
                Write-Verbose -Message "Preparing PUT to $($URI)"  

                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body ($Reservation | ConvertTo-Json -Depth 500)

                Write-Verbose -Message "SUCCESS"

            }

        }
        catch [Exception]{

            throw

        }
    }
    end {
        
    }
}