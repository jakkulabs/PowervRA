function Add-vRAReservationNetwork {
<#
    .SYNOPSIS
    Add a network to an existing vRA reservation

    .DESCRIPTION
    This cmdlet enables the user to add a new network to a reservation. Only one new network path can be added at a time.
    If a duplicate network path is detected, the API will throw an error.

    .PARAMETER Id
    The Id of the reservation

    .PARAMETER NetworkPath
    The network path
    
    .PARAMETER NetworkProfile
    The network profile

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAReservation -Name Reservation01 | Add-vRAReservationNetwork -NetworkPath "DMZ" -NetworkProfile "DMZ-Profile"

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName)]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$NetworkPath,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$NetworkProfile

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
            # --- Add Network
            # ---

            Write-Verbose -Message "Creating New Network Definition"


            if ($PSBoundParameters.ContainsKey("NetworkProfile")) {

                $NetworkDefinition = New-vRAReservationNetworkDefinition -Type $ReservationTypeName -ComputeResourceId $ComputeResourceId -NetworkPath $NetworkPath -NetworkProfile $NetworkProfile

            }
            else {

                $NetworkDefinition = New-vRAReservationNetworkDefinition -Type $ReservationTypeName -ComputeResourceId $ComputeResourceId -NetworkPath $NetworkPath

            }

            $ReservatonNetworks = $Reservation.extensionData.entries | Where-Object {$_.key -eq "reservationNetworks"}

            Write-Verbose -Message "Adding Network To Reservation"

            $ReservatonNetworks.value.items += $NetworkDefinition         
    
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