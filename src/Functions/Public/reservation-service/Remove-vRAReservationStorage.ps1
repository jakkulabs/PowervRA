function Remove-vRAReservationStorage {
<#
    .SYNOPSIS
    Remove vRA reservation storage

    .DESCRIPTION
    Remove vRA reservation storage

    .PARAMETER Id
    The Id of the reservation

    .PARAMETER Path
    The storage path

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAReservation -Name "Reservation01" | Remove-vRAReservationStorage -Path "Datastore01"

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

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
            # --- Set Storage Properties
            # ---

            Write-Verbose -Message "Preparing Removing Storage From Reservation"

            $ReservationStoragePath = (Get-vRAReservationComputeResourceStorage -Type $ReservationTypeName -ComputeResourceId $ComputeResourceId -Name $Path).values.entries | Where-Object {$_.key -eq "storagePath"}

            $ReservationStoragePathId = $ReservationStoragePath.value.id

            $Storage = $Reservation.extensionData.entries | Where-Object {$_.key -eq "reservationStorages"}  

            $StorageItems = $Storage.value.items

            foreach ($Item in $StorageItems) {

                $StoragePath = $item.values.entries | Where-Object {$_.key -eq "StoragePath"}

                if ($StoragePath.value.id -eq $ReservationStoragePathId) {

                    Write-Verbose -Message "Removing Storage $($Path) From Reservation"

                    $Storage.value.items = $Storage.value.items | Where-Object {$_ -ne $Item}

                }

            }

            if ($PSCmdlet.ShouldProcess($Id)){

                $URI = "/reservation-service/api/reservations/$($Id)"
                
                Write-Verbose -Message "Preparing PUT to $($URI)"  

                # --- Run vRA REST Request
                Invoke-vRARestMethod -Method PUT -URI $URI -Body ($Reservation | ConvertTo-Json -Depth 100) -Verbose:$VerbosePreference | Out-Null

            }

        }
        catch [Exception]{

            throw

        }
    }
    end {
        
    }
}