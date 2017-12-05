function Remove-vRAReservationNetwork {
<#
    .SYNOPSIS
    Remove a network from a reservation
    
    .DESCRIPTION
    Remove a network from a reservation
    
    .PARAMETER Id
    The id of the reservation

    .PARAMETER NetworkPath
    The network path

    .INPUTS
    System.String

    .EXAMPLE
    Get-vRAReservation -Name Reservation01 | Remove-vRAReservationNetwork -NetworkPath "DMZ"

    .EXAMPLE
    Remove-vRAReservationNetwork -Id 8731ceb3-01cd-4dd6-834e-49a9aa8057d8 -NetworkPath

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param (

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Id,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$NetworkPath          
    )
    
    Begin {}
    
    Process {    

        try {
            # --- Retrieve the reservation
            $URI = "/reservation-service/api/reservations/$($Id)"
            $Reservation = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

            # --- Loop through the reservation object and attempt to find and remove the network path
            :outer foreach ($Entry in $Reservation.extensionData.entries) {
                if ($Entry.key -eq "reservationNetworks") {
                    foreach ($Item in $Entry.value.items) {
                        foreach ($Key in $Item.values.entries){
                            if ($Key.key -eq "networkPath") {
                                if ($Key.value.label -eq $NetworkPath) {
                                    Write-Verbose -Message "Found network path $($NetworkPath) in reservation $($Reservation.name)"
                                    $List = [System.Collections.ArrayList]$Entry.value.items
                                    $List.Remove($Item)
                                    $Entry.value.items = $List
                                    if ($Entry.value.items.Count -eq 0) {
                                        throw "A reservation must have at least one network path selected. Cannot remove $($NetworkPath)"
                                    }
                                    break outer
                                }
                            }
                        }
                    }
                    throw "Could not find network path with name $($NetworkPath)"                                            
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