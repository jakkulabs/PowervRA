function Get-vRAReservationComputeResourceMemory {
<#
    .SYNOPSIS
    Get available memory for a compute resource
    
    .DESCRIPTION
    Get available memory for a compute resource

    .PARAMETER Type
    The reservation type

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAReservationComputeResourceMemory -Type vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d

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
    
    begin {}
    
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