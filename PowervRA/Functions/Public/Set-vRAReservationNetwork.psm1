function Set-vRAReservationNetwork {
<#
    .SYNOPSIS
    Set vRA reservation network properties

    .DESCRIPTION
    Set vRA reservation network properties. This cmdlet can be used to set the Network Profile for a
    Network Path in a reservation.

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
    Get-vRAReservation -Name "Reservation01" | Set-vRAReservationNetwork -NetworkPath "VM Network" -NetworkProfile "Test Profile 1"

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName)]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$NetworkPath,

    [parameter(Mandatory=$false)]
    [ValidateNotNull()]
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
            # --- Set Network Properties
            # ---

            $ReservationNetworkPathId = ((Get-vRAReservationComputeResourceNetwork -Type $ReservationTypeName -ComputeResourceId $ComputeResourceId -Name $NetworkPath).values.entries | Where-Object {$_.key -eq "networkPath"}).value.id

            $ReservationNetworks = $Reservation.extensionData.entries | Where-Object {$_.key -eq "reservationNetworks"}  

            $ReservationNetworkItems = $ReservationNetworks.value.items

            foreach ($ReservationNetworkItem in $ReservationNetworkItems) {

                $NetworkPathId = ($ReservationNetworkItem.values.entries | Where-Object {$_.key -eq "networkPath"}).value.id                 
               
                if ($NetworkPathId -eq $ReservationNetworkPathId) {

                    if ($PSBoundParameters.ContainsKey("NetworkProfile")){

                        # --- Test to see if a network profile exists in the reservation
                        $ExistingNetworkProfile = $ReservationNetworkItem.values.entries | Where-Object {$_.key -eq "networkProfile"}

                        if ($ExistingNetworkProfile) {

                            if ($NetworkProfile -eq '') {

                                # --- Remove an existing network profile

                                Write-Verbose -Message "Removing Network Profile"

                                $ReservationNetworkItem.values.entries = @($ReservationNetworkItem.values.entries | Where-Object {$_.key -ne "networkProfile"})

                            }
                            else {

                                # --- Get network profile information 
                                $Response = Invoke-vRARestMethod -Method GET -URI "/iaas-proxy-provider/api/network/profiles?`$filter=name%20eq%20'$($NetworkProfile)'"

                                if ($Response.content.Count -eq 0) {

                                    throw "Could not find network profile with name $($NetworkProfile)"

                                }

                                # --- Handle updating an existing network profile

                                Write-Verbose -Message "Updating Network Profile: $($ExistingNetworkProfile.value.label) >> $($NetworkProfile)"

                                $ExistingNetworkProfile.value.id = $Response.content[0].id

                                $ExistingNetworkProfile.value.label = $Response.content[0].name

                            }

                        }
                        else {

                            # --- Get network profile information 
                            $Response = Invoke-vRARestMethod -Method GET -URI "/iaas-proxy-provider/api/network/profiles?`$filter=name%20eq%20'$($NetworkProfile)'"

                            if ($Response.content.Count -eq 0) {

                                throw "Could not find network profile with name $($NetworkProfile)"

                            }

                            # --- Handle adding a new network profile to an existing path

                            Write-Verbose -Message "Adding Network Profile: $($NetworkProfile)"

                            $NetworkProfileTemplate = @"

                                {
                                    "key":  "networkProfile",
                                    "value":  {
                                                  "type":  "entityRef",
                                                  "componentId":  null,
                                                  "classId":  "Network",
                                                  "id":  "$($NetworkProfileObject.id)",
                                                  "label":  "$($NetworkProfileObject.name)"
                                              }
                                }

"@

                            $ReservationNetworkItem.values.entries += ($NetworkProfileTemplate | ConvertFrom-Json)

                        }

                    }

                }

            }

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