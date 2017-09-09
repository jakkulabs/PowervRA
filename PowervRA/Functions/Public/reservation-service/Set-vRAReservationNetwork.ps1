function Set-vRAReservationNetwork {
<#
    .SYNOPSIS
    Set vRA reservation network properties

    .DESCRIPTION
    Set vRA reservation network properties.

    This function enables you to:

    - Add a new network path to a reservation
    - Add a new network path to a reservation and assign a network profile
    - Update the network profile of an existing network path

    If the network path you supply is already selected in the reservation and no network profile is supplied, no action will be taken.

    .PARAMETER Id
    The Id of the reservation

    .PARAMETER NetworkPath
    The network path
    
    .PARAMETER NetworkProfile
    The network profile

    .INPUTS
    System.String

    .OUTPUTS
    None

    .EXAMPLE
    Get-vRAReservation -Name "Reservation01" | Set-vRAReservationNetwork -NetworkPath "VM Network" -NetworkProfile "Test Profile 1"

    .EXAMPLE
    Get-vRAReservation -Name "Reservation01" | Set-vRAReservationNetwork -NetworkPath "VM Network" -NetworkProfile "Test Profile 2"

    .EXAMPLE
    Get-vRAReservation -Name "Reservation01" | Set-vRAReservationNetwork -NetworkPath "Test Network"

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType()]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Id,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$NetworkPath,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$NetworkProfile

    )
 
    begin {
    
        function intGetNetworkProfileByName($Network) {
        <#

            Internal helper fucntion to retrieve a network profile by it's name

        #>
            $Response = (Invoke-vRARestMethod -Method GET -URI "/iaas-proxy-provider/api/network/profiles?`$filter=name%20eq%20'$($NetworkProfile)'").content
            if (!$Response) {
                throw "Could not find Network Profile with name $($NetworkProfile)"
            }
            return $Response
        }

        function intGetNetworkByPath ($ReservationNetworks, $NetworkPath) {
        <#

            Internal helper function to retrieve an existing network path

        #>
            foreach ($ReservationNetwork in $ReservationNetworks) {
                $ExistingNetworkPath = $ReservationNetwork.values.entries | Where-Object  {$_.key -eq "networkPath"} 
                if ($ExistingNetworkPath.value.label -eq $NetworkPath) {
                    return $ReservationNetwork
                }
            }
        }

    }
    
    process {

        try {

            # --- Get the reservation

            $Reservation = Invoke-vRARestMethod -Method GET -URI "/reservation-service/api/reservations/$($id)" -Verbose:$VerbosePreference
            
            $ReservationTypeName = (Get-vRAReservationType -Id $Reservation.reservationTypeId -Verbose:$VerbosePreference).name

            $ComputeResourceId = ($Reservation.extensionData.entries | Where-Object {$_.key -eq "computeResource"}).value.id                         

            # ---
            # --- Set Network Properties
            # ---

            $NetworkPathId = ((Get-vRAReservationComputeResourceNetwork -Type $ReservationTypeName -ComputeResourceId $ComputeResourceId -Name $NetworkPath -Verbose:$VerbosePreference).values.entries | Where-Object {$_.key -eq "networkPath"}).value.id

            # --- Check to see if the provided network path is available for the reservation
            If(!$NetworkPathId) {

                throw "Could not find network path $($NetworkPath) in Compute Resource $($ComputeResourceId)"

            }

            # --- Get a list of networks currently selected by the reservation
            $SelectedReservationNetworks = ($Reservation.extensionData.entries | Where-Object {$_.key -eq "reservationNetworks"}).value.items

            # --- Check to see if the provided networkpath is currently selected in the reservation
            $ExistingReservationNetwork = intGetNetworkByPath $SelectedReservationNetworks $NetworkPath

            if ($ExistingReservationNetwork) {

                # --- If the network path exists and network profile is passed update otherwise exit with nothing to do
                if ($PSBoundParameters.ContainsKey("NetworkProfile")) {

                    Write-Verbose -Message "Network path exists in reservation and Network Profile has been specified"
                
                    $NetworkProfileObject = intGetNetworkProfileByName $NetworkProfile

                    # --- Check to see if the network path already has a profile assigned, if one exists, update it, if not add it
                    $ExistingReservationNetworkProfile = $ExistingReservationNetwork | Where-Object{$_.key -eq "networkProfile"}

                    if ($ExistingReservationNetworkProfile) {

                        Write-Verbose -Message "Updating existing Network Profile"

                        $ExistingReservationNetworkProfile.value.id = $NetworkProfileObject.id
                        $ExistingReservationNetworkProfile.value.label = $NetworkProfileObject.name

                    } else {

                        Write-Verbose -Message "Adding new Network Profile"

                        $ReservationNetworkProfileTemplate = @"

                            {
                                "key": "networkProfile",
                                "value": {
                                    "type": "entityRef",
                                    "componentId": null,
                                    "classId": "networkProfile",
                                    "id": "$($NetworkProfileObject.id)",
                                    "label": "$($NetworkProfileObject.name)"
                                }
                            }

"@

                            $ExistingReservationNetwork.values.entries += ($ReservationNetworkProfileTemplate | ConvertFrom-Json)

                    }

                } else {

                    # --- It would be nice to exit cleanly here
                    Write-Verbose -Message "Network path exists in reservation but no Network profile has been specified"
                    Write-Verbose -Message "Exiting gracefully"
                    return

                }

            } else {

                # --- If the network path doesn't exist add it and also a network profile if passed

                Write-Verbose -Message "Adding new Network Path to reservation"

                $ReservationNetworkTemplate = @"

                    {
                        "type": "complex",
                        "componentTypeId": "com.vmware.csp.iaas.blueprint.service",
                        "componentId": null,
                        "classId": "Infrastructure.Reservation.Network",
                        "typeFilter": null,
                        "values": {
                            "entries": [
                                {
                                    "key": "networkPath",
                                    "value": {
                                        "type": "entityRef",
                                        "componentId": null,
                                        "classId": "Network",
                                        "id": "$($NetworkPathId)",
                                        "label": "$($NetworkPath)"
                                    }
                                }
                            ]
                        }
                    }

"@

                $ReservationNetworkObject = $ReservationNetworkTemplate | ConvertFrom-Json

                if ($PSBoundParameters.ContainsKey("NetworkProfile")) {

                    Write-Verbose -Message "Assigning a Network Profile to new Network Path"

                    $NetworkProfileObject = intGetNetworkProfileByName $NetworkProfile

                    $ReservationNetworkProfileTemplate = @"

                        {
                            "key": "networkProfile",
                            "value": {
                                "type": "entityRef",
                                "componentId": null,
                                "classId": "networkProfile",
                                "id": "$($NetworkProfileObject.id)",
                                "label": "$($NetworkProfileObject.name)"
                            }
                        }

"@

                        $ReservationNetworkObject.values.entries += $ReservationNetworkProfileTemplate | ConvertFrom-Json

                }

                $ReservationNetworks = $Reservation.extensionData.entries | Where-Object {$_.key -eq "reservationNetworks"}

                $ReservationNetworks.value.items += $ReservationNetworkObject

            }

            if ($PSCmdlet.ShouldProcess($Id)){

                $URI = "/reservation-service/api/reservations/$($Id)"
                
                Write-Verbose -Message "Preparing PUT to $($URI)"  

                # --- Run vRA REST Request
                Invoke-vRARestMethod -Method PUT -URI $URI -Body ($Reservation | ConvertTo-Json -Depth 100) -Verbose:$VerbosePreference | Out-Null

            }

        }
        catch [Exception]{

            throw

        }
    }
    end {
        
    }
}