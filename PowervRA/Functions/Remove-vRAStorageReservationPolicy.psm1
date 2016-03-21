function Remove-vRAStorageReservationPolicy {
<#
    .SYNOPSIS
    Remove a vRA Storage Reservation Policy
    
    .DESCRIPTION
    Remove a vRA Storage Reservation Policy
    
    .PARAMETER Id
    Storage Reservation Policy ID

    .PARAMETER Name
    Storage Reservation Policy Name

    .INPUTS
    System.String.

    .OUTPUTS
    None

    .EXAMPLE
    Remove-vRAStorageReservationPolicy -Id "34ae1d6c-9972-4736-acdb-7ee109ad1dbd"

    .EXAMPLE
    Remove-vRAStorageReservationPolicy -Name "StorageReservationPolicy01"
    
    .EXAMPLE
    Get-vRAStorageReservationPolicy -Name "StorageReservationPolicy01" | Remove-vRAStorageReservationPolicy -Confirm:$false
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

                foreach ($StorageReservationPolicyId in $Id){
                
                    try {
                        if ($PSCmdlet.ShouldProcess($StorageReservationPolicyId)){

                            $URI = "/reservation-service/api/reservations/policies/$($StorageReservationPolicyId)"  

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

                foreach ($StorageReservationPolicyName in $Name){
                
                    try {
                        if ($PSCmdlet.ShouldProcess($StorageReservationPolicyName)){

                            $StorageReservationPolicy = Get-vRAStorageReservationPolicy -Name $Name

                            if (-not $StorageReservationPolicy){

                                throw "Storage Reservation Policy with name $($Name) does not exist"
                            }

                            $Id = $StorageReservationPolicy.Id

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