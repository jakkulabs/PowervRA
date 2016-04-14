function Remove-vRAReservationStorage {
<#
    .SYNOPSIS
    Add storage to an existing vRA reservation

    .DESCRIPTION
    This cmdlet enables the user to add new storage to a reservation. Only one new storage path can be added at a time.
    If a duplicate storage path is detected, the API will throw an error.

    .PARAMETER Id
    The Id of the reservation

    .PARAMETER Path
    The storage path
    
    .PARAMETER ReservationSizeGB
    The size in GB of this reservation
    
    .PARAMETER Priority
    The priority of storage 

    .INPUTS
    System.String.
    System.Int.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAReservation -Name Reservation01 | Add-vRAReservationStorage -Path "Datastore01" -ReservedSizeGB 500 -Priority 1

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName)]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Path

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
            # --- Remove Storage
            # ---

            Write-Verbose -Message "Removing Storage From Reservation"

            $ReservationStoragePath = (Get-vRAReservationStorage -Type $ReservationTypeName -ComputeResourceId $ComputeResourceId -Name $Path).values.entries | Where-Object {$_.key -eq "storagePath"}

            $ReservationStoragePathId = $ReservationStoragePath.value.id

            $Storage = $Reservation.extensionData.entries | Where-Object {$_.key -eq "reservationStorages"}  

            $StorageItems = $Storage.value.items

            foreach ($Item in $StorageItems) {

                $StoragePath = $item.values.entries | Where-Object {$_.key -eq "StoragePath"}
                $StorageEnabled = $item.values.entries | Where-Object {$_.key -eq "storageEnabled"}

                Write-Verbose -Message "StoragePath $($StoragePath.value.id) -> $($ReservationStoragePathId)"

                if ($StoragePath.value.id -eq $ReservationStoragePathId) {

                    Write-Verbose -Message "Setting to false"

                    $StorageEnabled.value.value = "false"

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