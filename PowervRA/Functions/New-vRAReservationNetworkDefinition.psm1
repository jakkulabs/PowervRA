function New-vRAReservationNetworkDefinition {
<#
    .SYNOPSIS
    
    .DESCRIPTION
        
    .PARAMETER Path
    The storage path
    
    .PARAMETER ReservationSizeGB
    The size in GB of this reservation
    
    .PARAMETER Priority
    The priority of storage 

    .INPUTS
    System.String.
    System.Int.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Path,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Profile,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$ComputeResourceId

    )
    
    DynamicParam {
    
        # --- Define the parameter dictionary
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary           

        # --- Dynamic Param:Type
        $ParameterName = "Type"

        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.ParameterSetName = "Standard"

        $AttributeCollection =  New-Object System.Collections.ObjectModel.Collection[System.Attribute]        
        $AttributeCollection.Add($ParameterAttribute)

        # --- Set the dynamic values
        $ValidateSetValues = Get-vRAReservationType | Select -ExpandProperty Name

        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($ValidateSetValues)
        $AttributeCollection.Add($ValidateSetAttribute)
        
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [String], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
    
        # --- Return the dynamic parameters
        return $RuntimeParameterDictionary    
    
    }        

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