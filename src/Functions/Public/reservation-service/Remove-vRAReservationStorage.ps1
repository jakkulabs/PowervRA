function Remove-vRAReservationStorage {
<#
    .SYNOPSIS
    Remove a storage from a reservation
    
    .DESCRIPTION
    Remove a storage from a reservation
    
    .PARAMETER Id
    The id of the reservation

    .PARAMETER StoragePath
    The storage path

    .INPUTS
    System.String

    .EXAMPLE
    Get-vRAReservation -Name Reservation01 | Remove-vRAReservationStorage -StoragePath Datastore01

    .EXAMPLE
    Remove-vRAReservationStorage -Id 8731ceb3-01cd-4dd6-834e-49a9aa8057d8 -StoragePath Datastore01

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param (

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Id,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$StoragePath          
    )
    
    Begin {}
    
    Process {    

        try {
            # --- Retrieve the reservation
            $URI = "/reservation-service/api/reservations/$($Id)"
            $Reservation = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

            # --- Loop through the reservation object and attempt to find and remove the storage path
            :outer foreach ($Entry in $Reservation.extensionData.entries) {
                if ($Entry.key -eq "reservationStorages") {
                    foreach ($Item in $Entry.value.items) {
                        foreach ($Key in $Item.values.entries){
                            if ($Key.key -eq "storagePath") {
                                if ($Key.value.label -eq $StoragePath) {
                                    Write-Verbose -Message "Found storage path $($StoragePath) in reservation $($Reservation.name)"
                                    $List = [System.Collections.ArrayList]$Entry.value.items
                                    $List.Remove($Item)
                                    $Entry.value.items = $List
                                    if ($Entry.value.items.Count -eq 0) {
                                        throw "A reservation must have at least one storage path selected. Cannot remove $($StoragePath)"
                                    }
                                    break outer
                                }
                            }
                        }
                    }
                    throw "Could not find storage path with name $($StoragePath)"                                            
                }
            }

            if ($PSCmdlet.ShouldProcess($Id)){

                # --- Run vRA REST Request
                Invoke-vRARestMethod -Method PUT -URI $URI -Body ($Reservation | ConvertTo-Json -Depth 100) -Verbose:$VerbosePreference | Out-Null
            }            
        }
        catch [Exception]{
        
            throw $_
        } 
    }

    End{}       
}