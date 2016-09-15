function Remove-vRAReservationPolicy {
<#
    .SYNOPSIS
    Remove a vRA Reservation Policy
    
    .DESCRIPTION
    Remove a vRA Reservation Policy
    
    .PARAMETER Id
    Reservation Policy ID

    .PARAMETER Name
    Reservation Policy Name

    .INPUTS
    System.String.

    .OUTPUTS
    None

    .EXAMPLE
    Remove-vRAReservationPolicy -Id "34ae1d6c-9972-4736-acdb-7ee109ad1dbd"

    .EXAMPLE
    Remove-vRAReservationPolicy -Name "ReservationPolicy01"
    
    .EXAMPLE
    Get-vRAReservationPolicy -Name "ReservationPolicy01" | Remove-vRAReservationPolicy -Confirm:$false
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="ById")]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,

    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name
    )    

    begin {
    
    }
    
    process {    

        switch ($PsCmdlet.ParameterSetName) 
        { 
            "ById"  {

                foreach ($ReservationPolicyId in $Id){
                
                    try {
                        if ($PSCmdlet.ShouldProcess($ReservationPolicyId)){

                            $URI = "/reservation-service/api/reservations/policies/$($ReservationPolicyId)"  

                            # --- Run vRA REST Request
                            $Response = Invoke-vRARestMethod -Method DELETE -URI $URI
                        }
                    }
                    catch [Exception]{

                        throw
                    }
                }
            }
            "ByName"  {

                foreach ($ReservationPolicyName in $Name){
                
                    try {
                        if ($PSCmdlet.ShouldProcess($ReservationPolicyName)){

                            $ReservationPolicy = Get-vRAReservationPolicy -Name $Name

                            if (-not $ReservationPolicy){

                                throw "Reservation Policy with name $($Name) does not exist"
                            }

                            $Id = $ReservationPolicy.Id

                            $URI = "/reservation-service/api/reservations/policies/$($Id)"  

                            # --- Run vRA REST Request
                            $Response = Invoke-vRARestMethod -Method DELETE -URI $URI
                        }
                    }
                    catch [Exception]{

                        throw
                    }
                }
            }            
        }
    }
    end {
        
    }
}