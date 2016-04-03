function Get-vRAReservationMemory {
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
    Get-vRAReservationMemory -Type vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
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
    
    begin {}
    
    process {         

        try {

            $SchemaClassId = (Get-vRAReservationType -Name $PSBoundParameters.Type).schemaClassId

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