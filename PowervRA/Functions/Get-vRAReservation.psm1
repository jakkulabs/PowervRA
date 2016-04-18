function Get-vRAReservation {
<#
    .SYNOPSIS
    Get a reservation
    
    .DESCRIPTION
    Get a reservation

    .PARAMETER Id
    The id of the reservation
    
    .PARAMETER Name
    The name of the reservation

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .PARAMETER Page
    The page of response to return. All pages are retuend by default

    .INPUTS
    System.String
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject
    System.Object[]

    .EXAMPLE
    Get-vRAReservation -Id 75ae3400-beb5-4b0b-895a-0484413c93b1

    .EXAMPLE
    Get-vRAReservation -Name Reservation1

    .EXAMPLE
    Get-vRAReservation 

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject', 'System.Object[]')]

    Param (

    [parameter(Mandatory=$true,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,
    
    [parameter(Mandatory=$true,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name,    
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$Limit = "100",
 
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$Page = "1"
       
    )    

    try {

        switch ($PsCmdlet.ParameterSetName) {

            'ById' { 

                foreach ($ReservationId in $Id) {

                    $URI = "/reservation-service/api/reservations/$($ReservationId)"
            
                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI "$($URI)"

                    Write-Verbose -Message "SUCCESS"

                    if ($Response.Count -eq 0) {

                        throw "Could not find reservation $($ReservationId)"

                    }

                    [pscustomobject] @{

                        CreatedDate = $Response.createdDate
                        LastUpdated = $Response.lastUpdated
                        Version = $Response.version
                        Id = $Response.id
                        Name = $Response.name
                        ReservationTypeId = $Response.reservationTypeId
                        TenantId = $Response.tenantId
                        SubTenantId = $Response.subtenantId
                        Enabled = $Response.enabled
                        Priority = $Response.Priority
                        ReservationPolicyId = $Response.reservationPolicyId
                        AlertPolicy = $Response.alertPolicy
                        ExtensionData = $Response.extensionData

                    }

                }

                break

            }

            'ByName' {

                foreach ($ReservationName in $Name) {
            
                    $URI = "/reservation-service/api/reservations?`$filter=name%20eq%20'$($ReservationName)'"
            
                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI "$($URI)"

                    Write-Verbose -Message "SUCCESS"

                    if ($Response.content.Count -eq 0) {

                        throw "Could not find reservation $($ReservationName)"

                    }

                    [pscustomobject] @{

                        CreatedDate = $Response.content.createdDate
                        LastUpdated = $Response.content.lastUpdated
                        Version = $Response.content.version
                        Id = $Response.content.id
                        Name = $Response.content.name
                        ReservationTypeId = $Response.content.reservationTypeId
                        TenantId = $Response.content.tenantId
                        SubTenantId = $Response.content.subtenantId
                        Enabled = $Response.content.enabled
                        Priority = $Response.content.Priority
                        ReservationPolicyId = $Response.content.reservationPolicyId
                        AlertPolicy = $Response.content.alertPolicy
                        ExtensionData = $Response.content.extensionData

                    }
                                      
                }
                
                break                                          
        
            }

            'Standard' {

                $URI = "/reservation-service/api/reservations?limit=$($Limit)"

                # --- Make the first request to determine the size of the request
                $Response = Invoke-vRARestMethod -Method GET -URI $URI

                if (!$PSBoundParameters.ContainsKey("Page")){

                    # --- Get every page back
                    $TotalPages = $Response.metadata.totalPages.ToInt32($null)

                }
                else {

                    # --- Set TotalPages to 1
                    $TotalPages = 1

                }

                # --- Initialise an empty array
                $ResponseObject = @()

                while ($true){

                    Write-Verbose -Message "Getting response for page $($Page) of $($Response.metadata.totalPages)"

                    $PagedUri = "$($URI)&page=$($Page)&`$orderby=name%20asc"

                    Write-Verbose -Message "GET : $($PagedUri)"

                    $Response = Invoke-vRARestMethod -Method GET -URI $PagedUri
            
                    Write-Verbose -Message "Paged Response contains $($Response.content.Count) records"

                    foreach ($Reservation in $Response.content) {

                        $Object = [pscustomobject] @{

                            CreatedDate = $Reservation.createdDate
                            LastUpdated = $Reservation.lastUpdated
                            Version = $Reservation.version
                            Id = $Reservation.id
                            Name = $Reservation.name
                            ReservationTypeId = $Reservation.reservationTypeId
                            TenantId = $Reservation.tenantId
                            SubTenantId = $Reservation.subtenantId
                            Enabled = $Reservation.enabled
                            Priority = $Reservation.Priority
                            ReservationPolicyId = $Reservation.reservationPolicyId
                            AlertPolicy = $Reservation.alertPolicy
                            ExtensionData = $Reservation.extensionData

                        }

                        $ResponseObject += $Object

                    }

                    # --- Break loop
                    if ($Page -ge $TotalPages) {

                        break

                    }

                    # --- Increment the current page by 1
                    $Page++

                }         

                # --- Return reservations
                $ResponseObject

                break
    
            }

        }
           
    }
    catch [Exception]{
        
        throw

    }   
     
}