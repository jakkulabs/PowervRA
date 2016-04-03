function New-vRAReservationStorageDefinition {
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
    
    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$ReservedSizeGB,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$Priority = 0,

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
        $ParameterAttribute.ParameterSetName = "__AllParameterSets"

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

            # --- Get storage information
            $Storage = Get-vRAReservationStorage -Type $PSBoundParameters.Type -ComputeResourceId $ComputeResourceId -Name $Path

            $StoragePath = ($Storage.values.entries | Where-Object {$_.key -eq "storagePath"}).value

            $StorageTotalSize = ($Storage.values.entries | Where-Object {$_.key -eq "computeResourceStorageTotalSizeGB"}).value.value.ToInt32($null)

            # --- Validate the requested reservation size
            if ($ReservedSizeGB -gt $StorageTotalSize) {

            throw "Reserved size is greater than the total size of the storage ($($ReservedSizeGB) -> $($StorageTotalSize))"

            }

            $StorageDefinitionJSON = @"
    
                {
                    "type": "complex",
                    "componentTypeId": "com.vmware.csp.iaas.blueprint.service",
                    "componentId": null,
                    "classId": "Infrastructure.Reservation.Storage",
                    "typeFilter": null,
                    "values": {
                        "entries": [
                            {
                                "key": "storageReservationPriority",
                                "value": {
                                    "type": "integer",
                                    "value": $($Priority)
                                }
                            },
                            {
                                "key": "storageReservedSizeGB",
                                "value": {
                                    "type": "integer",
                                    "value": $($ReservedSizeGB)
                                }
                            },
                            {
                                "key": "storagePath",
                                "value": {
                                    "type": "entityRef",
                                    "componentId": null,
                                    "classId": "Storage",
                                    "id": "$($StoragePath.id)",
                                    "label": "$($StoragePath.label)"
                                }
                            },
                            {
                                "key": "storageEnabled",
                                "value": {
                                    "type": "boolean",
                                    "value": true
                                }
                            }
                        ]

                    }

                }

"@

            # --- Return the reservation storage definition
            $StorageDefinitionJSON | ConvertFrom-Json

        }
        catch [Exception]{

            throw
        }
    }
    end {
        
    }
}