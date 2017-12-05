function Get-vRAReservationTemplate {
<#
    .SYNOPSIS
    Get a reservation json template
    
    .DESCRIPTION
    Get a reservation json template. This template can then be used to create a new reservation with the same properties
    
    .PARAMETER Id
    The id of the reservation
    
    .PARAMETER OutFile
    The path to an output file

    .INPUTS
    System.String

    .OUTPUTS
    System.String

    .EXAMPLE
    Get-vRAReservationTemplate -Id 75ae3400-beb5-4b0b-895a-0484413c93b1 -OutFile C:\Reservation.json

    .EXAMPLE
    Get-vRAReservation -Name Reservation1 | Get-vRAReservationTemplate -OutFile C:\Reservation.json

    .EXAMPLE
    Get-vRAReservation -Name Reservation1 | Get-vRAReservationTemplate

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.String')]

    Param (

    [parameter(Mandatory=$true, ValueFromPipelineByPropertyName)]
    [ValidateNotNullOrEmpty()]
    [String]$Id,
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$OutFile
       
    )    

    try {


        $URI = "/reservation-service/api/reservations/$($Id)"
            
        Write-Verbose -Message "Preparing GET to $($URI)"

        $Response = Invoke-vRARestMethod -Method GET -URI "$($URI)"

        Write-Verbose -Message "SUCCESS"

        # --- Remove the id from the response
        $Response.PSObject.Properties.Remove("id")

        if ($PSBoundParameters.ContainsKey("OutFile")) {

            Write-Verbose -Message "Outputting response to $($OutFile)"

            # --- Output the response to file
            $Response | ConvertTo-Json -Depth 100 | Out-File -FilePath $OutFile -Force

        }
        else {

            # --- Return the response
            $Response | ConvertTo-Json -Depth 100

        }
           
    }
    catch [Exception]{
        
        throw

    }   
     
}