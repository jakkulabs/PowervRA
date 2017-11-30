function Get-vRAReservationComputeResourceMemory {
<#
    .SYNOPSIS
    Get available memory for a compute resource
    
    .DESCRIPTION
    Get available memory for a compute resource

    .PARAMETER Type
    The reservation type
    Valid types vRA 7.1 and earlier: Amazon, Hyper-V, KVM, OpenStack, SCVMM, vCloud Air, vCloud Director, vSphere,XenServer
    Valid types vRA 7.2 and later: Amazon EC2, Azure, Hyper-V (SCVMM), Hyper-V (Standalone), KVM (RHEV), OpenStack, vCloud Air, vCloud Director, vSphere (vCenter), XenServer

    .PARAMETER ComputeResourceId
    The id of the compute resource

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    # Retrieve associated compute resources for the desired reservation type in vRA 7.1
    Get-vRAReservationComputeResource -Type 'vSphere' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

    # Retrieve associated compute resource memory for the desired reservation type in vRA 7.1
    Get-vRAReservationComputeResourceMemory -Type 'vSphere' -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d

    .EXAMPLE
    # Retrieve associated compute resources for the desired reservation type in vRA 7.2 and later
    Get-vRAReservationComputeResource -Type 'vSphere (vCenter)' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

    # Retrieve associated compute resource memory for the desired reservation type in vRA 7.2 and later
    Get-vRAReservationComputeResourceMemory -Type 'vSphere (vCenter)' -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Type,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$ComputeResourceId
       
    )
    
    begin {
        # --- Test for vRA API version
        xRequires -Version 7.0
    }
    
    process {         

        try {

            $SchemaClassId = (Get-vRAReservationType -Name $Type).schemaClassId

            # --- Set the body for the POST
            $Body = @"

            {
              "text": "",
              "dependencyValues": {
                "entries": [{
                  "key": "computeResource",
                  "value": {
                    "type": "entityRef",
                    "componentId": null,
                    "classId": "ComputeResource",
                    "id": "$($ComputeResourceId)"
                  }
                }]
              }
            }
"@        
 
            $URI = "/reservation-service/api/data-service/schema/$($SchemaClassId)/default/reservationMemory/values"

            Write-Verbose -Message "Preparing POST to $($URI)"

            $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body

            Write-Verbose -Message "SUCCESS"

            if ($Response.values.Count -eq 0) {

                throw "Could not find memory for compute resource $($ComputeResourceId)"

            }

            forEach ($Memory in $Response.values) {

                [pscustomobject] @{

                    Type = $Memory.underlyingValue.type
                    ComponentTypeId = $Memory.underlyingValue.componentTypeId
                    ComponentId = $Memory.underlyingValue.componentId
                    ClassId = $Memory.underlyingValue.classId
                    TypeFilter = $Memory.underlyingValue.typeFilter
                    Values = $Memory.underlyingValue.values

                }

            }
           
        }
        catch [Exception]{
        
            throw

        }
        
    }   
     
}