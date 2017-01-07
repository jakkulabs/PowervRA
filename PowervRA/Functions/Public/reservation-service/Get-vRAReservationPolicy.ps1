function Get-vRAReservationPolicy {
<#
    .SYNOPSIS
    Retrieve vRA Reservation Policies
    
    .DESCRIPTION
    Retrieve vRA Reservation Policies
    
    .PARAMETER Id
    Specify the ID of a Reservation Policy

    .PARAMETER Name
    Specify the Name of a Reservation Policy

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAReservationPolicy
    
    .EXAMPLE
    Get-vRAReservationPolicy -Id "068afd10-560f-4360-aa52-786a28573fdc"

    .EXAMPLE
    Get-vRAReservationPolicy -Name "ReservationPolicy01","ReservationPolicy02"
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
                
                foreach ($ReservationPolicyId in $Id){

                    $URI = "/reservation-service/api/reservations/policies/$($ReservationPolicyId)"

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

                foreach ($ReservationPolicyName in $Name){

                    $URI = "/reservation-service/api/reservations/policies?`$filter=name%20eq%20'$($ReservationPolicyName)'&reservationPolicyTypeId%20eq%20'Infrastructure.Reservation.Policy.ComputeResource'"

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    foreach ($ReservationPolicy in $Response.content){

                        [pscustomobject]@{

                            Name = $ReservationPolicy.name
                            Id = $ReservationPolicy.id                
                            Description = $ReservationPolicy.description
                            CreatedDate = $ReservationPolicy.createdDate
                            LastUpdated = $ReservationPolicy.lastUpdated
                            ReservationPolicyTypeId = $ReservationPolicy.reservationPolicyTypeId
                        }
                    }
                }
                
                break
            }

            "Standard"  {

                $URI = "/reservation-service/api/reservations/policies?`$filter=reservationPolicyTypeId%20eq%20'Infrastructure.Reservation.Policy.ComputeResource'"

                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method GET -URI $URI

                foreach ($ReservationPolicy in $Response.content){

                    [pscustomobject]@{

                        Name = $ReservationPolicy.name
                        Id = $ReservationPolicy.id                
                        Description = $ReservationPolicy.description
                        CreatedDate = $ReservationPolicy.createdDate
                        LastUpdated = $ReservationPolicy.lastUpdated
                        ReservationPolicyTypeId = $ReservationPolicy.reservationPolicyTypeId
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