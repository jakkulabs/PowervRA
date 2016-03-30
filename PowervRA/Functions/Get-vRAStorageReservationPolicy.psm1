function Get-vRAStorageReservationPolicy {
<#
    .SYNOPSIS
    Retrieve vRA Storage Reservation Policies
    
    .DESCRIPTION
    Retrieve vRA Storage Reservation Policies
    
    .PARAMETER Id
    Specify the ID of a Storage Reservation Policy

    .PARAMETER Name
    Specify the Name of a Storage Reservation Policy

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAStorageReservationPolicy
    
    .EXAMPLE
    Get-vRAStorageReservationPolicy -Id "068afd10-560f-4360-aa52-786a28573fdc"

    .EXAMPLE
    Get-vRAStorageReservationPolicy -Name "StorageReservationPolicy01","StorageReservationPolicy02"
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,         

    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name, 
    
    [parameter(Mandatory=$false,ValueFromPipeline=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100" 
    )

    try {                
        switch ($PsCmdlet.ParameterSetName) 
        { 
            "ById"  {                
                
                foreach ($StorageReservationPolicyId in $Id){

                    $URI = "/reservation-service/api/reservations/policies/$($StorageReservationPolicyId)"

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    [pscustomobject]@{

                        Name = $Response.name
                        Id = $Response.id                
                        Description = $Response.description
                        CreatedDate = $Response.createdDate
                        LastUpdated = $Response.lastUpdated
                        ReservationPolicyTypeId = $Response.reservationPolicyTypeId
                    }
                }                              
            
                break
            }

            "ByName"  {                

                foreach ($StorageReservationPolicyName in $Name){

                    $URI = "/reservation-service/api/reservations/policies?`$filter=name%20eq%20'$($StorageReservationPolicyName)'&reservationPolicyTypeId%20eq%20'Infrastructure.Reservation.Policy.Storage'"

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    foreach ($StorageReservationPolicy in $Response.content){

                        [pscustomobject]@{

                            Name = $StorageReservationPolicy.name
                            Id = $StorageReservationPolicy.id                
                            Description = $StorageReservationPolicy.description
                            CreatedDate = $StorageReservationPolicy.createdDate
                            LastUpdated = $StorageReservationPolicy.lastUpdated
                            ReservationPolicyTypeId = $StorageReservationPolicy.reservationPolicyTypeId
                        }
                    }
                }
                
                break
            }

            "Standard"  {

                $URI = "/reservation-service/api/reservations/policies?`$filter=reservationPolicyTypeId%20eq%20'Infrastructure.Reservation.Policy.Storage'"

                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method GET -URI $URI

                foreach ($StorageReservationPolicy in $Response.content){

                    [pscustomobject]@{

                        Name = $StorageReservationPolicy.name
                        Id = $StorageReservationPolicy.id                
                        Description = $StorageReservationPolicy.description
                        CreatedDate = $StorageReservationPolicy.createdDate
                        LastUpdated = $StorageReservationPolicy.lastUpdated
                        ReservationPolicyTypeId = $StorageReservationPolicy.reservationPolicyTypeId
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