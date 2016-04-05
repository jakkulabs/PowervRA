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
    $Storage1 = New-vRAReservationStorageDefinition -Type vSphere -ComputeResourceId 75ae3400-beb5-4b0b-895a-0484413c93b1 -Path "Datastore01" -ReservedSizeGB 10 -Priority 0 

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
    
    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$ReservedSizeGB,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$Priority = 0

    )
   
    begin {
    
    }
    
    process {

        try {

            # --- Get storage information
            $Storage = Get-vRAReservationStorage -Type $Type -ComputeResourceId $ComputeResourceId -Name $Path

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