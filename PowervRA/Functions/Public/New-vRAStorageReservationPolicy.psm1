function New-vRAStorageReservationPolicy {
<#
    .SYNOPSIS
    Create a vRA Storage Reservation Policy
    
    .DESCRIPTION
    Create a vRA Storage Reservation Policy
    
    .PARAMETER Name
    Storage Reservation Policy Name
    
    .PARAMETER Description
    Storage Reservation Policy Description

    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRAStorageReservationPolicy -Name StorageReservationPolicy01 -Description "This is Storage Reservation Policy 01"
    
    .EXAMPLE
    $JSON = @"
    {
      "name": "StorageReservationPolicy01",
      "description": "This is Storage Reservation Policy 01",
      "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.Storage"
    }
    "@
    $JSON | New-vRAStorageReservationPolicy
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
                "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.Storage"
            }
"@
        }   
           
        try {
            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/reservation-service/api/reservations/policies"  

                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body

                # --- Output the Successful Result
                Get-vRAStorageReservationPolicy -Name $Name
            }
        }
        catch [Exception]{

            throw
        }
    }
    end {
        
    }
}