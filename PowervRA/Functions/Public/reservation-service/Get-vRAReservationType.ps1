function Get-vRAReservationType {
<#
    .SYNOPSIS
    Get supported Reservation Types
    
    .DESCRIPTION
    Get supported Reservation Types

    .PARAMETER Id
    The id of the Reservation Type
    
    .PARAMETER Name
    The name of the Reservation Type
    Valid names vRA 7.1 and earlier: Amazon, Hyper-V, KVM, OpenStack, SCVMM, vCloud Air, vCloud Director, vSphere,XenServer
    Valid names vRA 7.2 and later: Amazon EC2, Azure, Hyper-V (SCVMM), Hyper-V (Standalone), KVM (RHEV), OpenStack, vCloud Air, vCloud Director, vSphere (vCenter), XenServer

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .PARAMETER Page
    The page of response to return. All pages are retuend by default.

    .INPUTS
    System.String.
    System.Int.

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    # Get all available Reservation Types
    Get-vRAReservationType

    .EXAMPLE
    # Get the vSphere Reservation Type in vRA 7.1
    Get-vRAReservationType -Name "vSphere"

    .EXAMPLE
    # Get the vSphere Reservation Type in vRA 7.2 and later
    Get-vRAReservationType -Name "vSphere (vCenter)"

    .EXAMPLE
    Get-vRAReservationType -Name "vCloud Director"

    .EXAMPLE
    Get-vRAReservationType -Id "Infrastructure.Reservation.Cloud.vCloud"
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject' , 'System.Object[]')]

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
    [Int]$Page = 1
       
    )    

    try {

        switch ($PsCmdlet.ParameterSetName) {

            'ById' { 

                foreach ($ReservationTypeId in $Id) {

                    $URI = "/reservation-service/api/reservations/types/$($ReservationTypeId)"
            
                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI "$($URI)"

                    Write-Verbose -Message "SUCCESS"

                    if ($Response.Count -eq 0) {

                        throw "Could not find reservationType $($ReservationTypeId)"

                    }

                    [pscustomobject] @{

                        CreatedDate = $Response.createdDate
                        LastUpdated = $Response.LastUpdated
                        Version = $Response.version
                        Id = $Response.id
                        Name = $Response.name
                        Description = $Response.description
                        Category = $Response.category
                        ServiceTypeId = $Response.serviceTypeId
                        TenantId = $Response.tenantId
                        FormReference = $Response.formReference
                        SchemaClassId = $Response.schemaClassId
                        AlertTypes = $Response.alertTypes

                    }

                }

                break

            }

            'ByName' {

                foreach ($ReservationTypeName in $Name) {
            
                    $URI = "/reservation-service/api/reservations/types?`$filter=name%20eq%20'$($ReservationTypeName)'"
            
                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI "$($URI)"

                    Write-Verbose -Message "SUCCESS"

                    if ($Response.content.Count -eq 0) {

                        throw "Could not find reservation type $($ReservationTypeName)"

                    }

                    [pscustomobject] @{

                        CreatedDate = $Response.content.createdDate
                        LastUpdated = $Response.content.LastUpdated
                        Version = $Response.content.version
                        Id = $Response.content.id
                        Name = $Response.content.name
                        Description = $Response.content.description
                        Category = $Response.content.category
                        ServiceTypeId = $Response.content.serviceTypeId
                        TenantId = $Response.content.tenantId
                        FormReference = $Response.content.formReference
                        SchemaClassId = $Response.content.schemaClassId
                        AlertTypes = $Response.content.alertTypes

                    }
                                      
                }
                
                break                                          
        
            }

            'Standard' {

                $URI = "/reservation-service/api/reservations/types?limit=$($Limit)"

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

                    foreach ($ReservationType in $Response.content) {

                        [pscustomobject] @{

                            CreatedDate = $ReservationType.createdDate
                            LastUpdated = $ReservationType.LastUpdated
                            Version = $ReservationType.version
                            Id = $ReservationType.id
                            Name = $ReservationType.name
                            Description = $ReservationType.description
                            Category = $ReservationType.category
                            ServiceTypeId = $ReservationType.serviceTypeId
                            TenantId = $ReservationType.tenantId
                            FormReference = $ReservationType.formReference
                            SchemaClassId = $ReservationType.schemaClassId
                            AlertTypes = $ReservationType.alertTypes

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

                # --- Return reservation types
                $ResponseObject

                break
    
            }

        }
           
    }
    catch [Exception]{
        
        throw

    }   
     
}