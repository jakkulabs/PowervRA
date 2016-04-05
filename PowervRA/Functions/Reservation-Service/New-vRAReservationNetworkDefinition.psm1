function New-vRAReservationNetworkDefinition {
<#
    .SYNOPSIS
    
    .DESCRIPTION

    .PARAMETER Type
    The reservation type
        
    .PARAMETER ComputeResourceId
    The id of the compute resource

    .PARAMETER Path
    The network path
    
    .PARAMETER ReservationSizeGB
    The network profile

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    $Network1 = New-vRAReservationNetworkDefinition -Type vSphere -ComputeResourceId 75ae3400-beb5-4b0b-895a-0484413c93b1 -Path "VM Network" -Profile "Test"

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Type,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$ComputeResourceId,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Path,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Profile

    )    

    begin {
    
    }
    
    process {

        try {

            $SchemaClassId = (Get-vRAReservationType -Name $PSBoundParameters.Type).SchemaClassid

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
            $Network = Get-vRAReservationNetwork -Type $PSBoundParameters.Type -ComputeResourceId $ComputeResourceId -Name $Path

            $NetworkPath = ($Network.values.entries | Where-Object {$_.key -eq "networkPath"})

            # --- Add the network path to the network definition
            $NetworkDefinition.values.entries += $NetworkPath

            if ($Profile) {

                $Response = Invoke-vRARestMethod -Method GET -URI "/iaas-proxy-provider/api/network/profiles?`$filter=name%20eq%20'$($Profile)'"

                if ($Response.content.Count -eq 0) {

                    throw "Could not find network profile with name $($Profile)"

                }

                $NetworkProfile = $Response.content[0]

                $NetworkProfileJSON = @"

                    {
                        "key":  "networkProfile",
                        "value":  {
                                      "type":  "entityRef",
                                      "componentId":  null,
                                      "classId":  "Network",
                                      "id":  "$($NetworkProfile.id)",
                                      "label":  "$($NetworkProfile.name)"
                                  }
                    }

"@

                $NetworkProfile = $NetworkProfileJSON | ConvertFrom-Json 

                # --- Add the network profile to the network definition
                $NetworkDefinition.values.entries += $NetworkProfile

            }

            $NetworkDefinition

        }
        catch [Exception]{

            throw
        }
    }
    end {
        
    }
}