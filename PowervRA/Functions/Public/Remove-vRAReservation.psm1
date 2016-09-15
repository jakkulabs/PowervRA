function Remove-vRAReservation {
<#
    .SYNOPSIS
    Remove a reservation
    
    .DESCRIPTION
    Remove a reservation
    
    .PARAMETER Id
    The id of the reservation

    .PARAMETER Name
    The name of the reservation

    .INPUTS
    System.String

    .EXAMPLE
    Remove-vRAReservation -Name Reservation1

    .EXAMPLE
    Remove-vRAReservation -Id 75ae3400-beb5-4b0b-895a-0484413c93b1

    .EXAMPLE
    Get-vRAReservation -Name Reservation1 | Remove-vRAReservation

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="ById")]

    Param (

    [parameter(Mandatory=$true, ValueFromPipelineByPropertyName, ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,

    [parameter(Mandatory=$true, ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name   
       
    )
    
    begin {}
    
    process {    

        try {

            switch ($PSCmdlet.ParameterSetName) {

                'ById' {

                    foreach ($ReservationId in $Id) {

                        if ($PSCmdlet.ShouldProcess($ReservationId)){

                            $URI = "/reservation-service/api/reservations/$($ReservationId)"
            
                            Write-Verbose -Message "Preparing DELETE to $($URI)"

                            $Response = Invoke-vRARestMethod -Method DELETE -URI "$($URI)"

                            Write-Verbose -Message "SUCCESS"

                        }

                    }

                    break

                }

                'ByName' {

                    foreach ($ReservationName in $Name) {

                        if ($PSCmdlet.ShouldProcess($ReservationName)){

                            $ReservationId = (Get-vRAReservation -Name $ReservationName).id

                            $URI = "/reservation-service/api/reservations/$($ReservationId)"
            
                            Write-Verbose -Message "Preparing DELETE to $($URI)"

                            $Response = Invoke-vRARestMethod -Method DELETE -URI "$($URI)"

                            Write-Verbose -Message "SUCCESS"

                        }

                    }

                    break

                }
  
            }
    
        }
        catch [Exception]{
        
            throw

        }
        
    }   
     
}