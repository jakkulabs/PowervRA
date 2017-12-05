function New-vRAReservationPolicy {
<#
    .SYNOPSIS
    Create a vRA Reservation Policy
    
    .DESCRIPTION
    Create a vRA Reservation Policy
    
    .PARAMETER Name
    Reservation Policy Name
    
    .PARAMETER Description
    Reservation Policy Description

    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRAReservationPolicy -Name ReservationPolicy01 -Description "This is Reservation Policy 01"
    
    .EXAMPLE
    $JSON = @"
    {
      "name": "ReservationPolicy01",
      "description": "This is Reservation Policy 01",
      "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.ComputeResource"
    }
    "@
    $JSON | New-vRAReservationPolicy
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Description,

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
    [ValidateNotNullOrEmpty()]
    [String]$JSON
    )    

    begin {
    
    }
    
    process {
    
        # --- Set Body for REST request depending on ParameterSet
        if ($PSBoundParameters.ContainsKey("JSON")){
        
            $Data = ($JSON | ConvertFrom-Json)
            
            $Body = $JSON
            $Name = $Data.name     
        }
        else {
        
            $Body = @"
            {
                "name": "$($Name)",
                "description": "$($Description)",
                "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.ComputeResource"
            }
"@
        }   
           
        try {
            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/reservation-service/api/reservations/policies"  

                # --- Run vRA REST Request
                Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference | Out-Null

                # --- Output the Successful Result
                Get-vRAReservationPolicy -Name $Name
            }
        }
        catch [Exception]{

            throw
        }
    }
    end {
        
    }
}