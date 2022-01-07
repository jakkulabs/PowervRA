﻿function New-vRAReservationNetworkDefinition {
<#
    .SYNOPSIS
    Creates a new network definition for a reservation.

    .DESCRIPTION
    Creates a new network definition for a reservation. This cmdlet is used to create a custom
    complex network object. One or more of these can be added to an array and passed to New-vRAReservation.

    .PARAMETER Type
    The reservation type
    Valid types vRA 7.1 and earlier: Amazon, Hyper-V, KVM, OpenStack, SCVMM, vCloud Air, vCloud Director, vSphere, XenServer
    Valid types vRA 7.2 and later: Amazon EC2, Azure, Hyper-V (SCVMM), Hyper-V (Standalone), KVM (RHEV), OpenStack, vCloud Air, vCloud Director, vSphere (vCenter), XenServer

    .PARAMETER ComputeResourceId
    The id of the compute resource

    .PARAMETER NetworkPath
    The network path

    .PARAMETER NetworkProfile
    The network profile

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    # Create a network definition for type vSphere in vRA 7.1
    $NetworkDefinitionArray = @()
    $Network1 = New-vRAReservationNetworkDefinition -Type 'vSphere' -ComputeResourceId 75ae3400-beb5-4b0b-895a-0484413c93b1 -NetworkPath 'VM Network' -NetworkProfile 'Test'
    $NetworkDefinitionArray += $Network1

    .EXAMPLE
    # Create a network definition for type vSphere in vRA 7.2 and later
    $NetworkDefinitionArray = @()
    $Network1 = New-vRAReservationNetworkDefinition -Type 'vSphere (vCenter)' -ComputeResourceId 75ae3400-beb5-4b0b-895a-0484413c93b1 -NetworkPath 'VM Network' -NetworkProfile 'Test'
    $NetworkDefinitionArray += $Network1
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Type,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$ComputeResourceId,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$NetworkPath,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$NetworkProfile

    )

    begin {

    }

    process {

        try {

            if ($PSCmdlet.ShouldProcess("ReservationNetworkDefinition")) {

                # --- Define object
                $NetworkDefinitionJSON = @"

                    {
                        "type": "complex",
                        "componentTypeId": "com.vmware.csp.iaas.blueprint.service",
                        "componentId": null,
                        "classId": "Infrastructure.Reservation.Network",
                        "typeFilter": null,
                        "values": {
                            "entries": []

                        }

                    }
"@

                # --- Convert the networkDefinition json to an object
                $NetworkDefinition = $NetworkDefinitionJSON | ConvertFrom-Json

                # --- Get network information
                $Network = Get-vRAReservationComputeResourceNetwork -Type $Type -ComputeResourceId $ComputeResourceId -Name $NetworkPath

                $Path = ($Network.values.entries | Where-Object {$_.key -eq "networkPath"})

                # --- Add the network path to the network definition
                $NetworkDefinition.values.entries += $Path

                if ($NetworkProfile) {

                    $Response = Invoke-vRARestMethod -Method GET -URI "/iaas-proxy-provider/api/network/profiles?`$filter=name%20eq%20'$($NetworkProfile)'"

                    if ($Response.content.Count -eq 0) {

                        throw "Could not find network profile with name $($NetworkProfile)"

                    }

                    $ReturnedNetworkProfile = $Response.content[0]

                    $NetworkProfileJSON = @"

                        {
                            "key":  "networkProfile",
                            "value":  {
                                        "type":  "entityRef",
                                        "componentId":  null,
                                        "classId":  "Network",
                                        "id":  "$($ReturnedNetworkProfile.id)",
                                        "label":  "$($ReturnedNetworkProfile.name)"
                                    }
                        }
"@

                    $ReturnedNetworkProfile = $NetworkProfileJSON | ConvertFrom-Json

                    # --- Add the network profile to the network definition
                    $NetworkDefinition.values.entries += $ReturnedNetworkProfile

                }

                $NetworkDefinition

            }

        }
        catch [Exception]{

            throw
        }
    }
    end {

    }
}
