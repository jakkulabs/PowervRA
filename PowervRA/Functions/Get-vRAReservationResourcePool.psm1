function Get-vRAReservationResourcePool {
<#
    .SYNOPSIS
    Get available resource pools for a compute resource
    
    .DESCRIPTION
    Get available resource pools for a compute resource

    .PARAMETER SchemaClassId
    The SchemaClassid id for the reservation type
    
    .PARAMETER Name
    The name of the resource pool

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAReservationResourcePool -SchemaClassId Infrastructure.Reservation.Virtual.vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d -Name ResourcePool1

    .EXAMPLE
    Get-vRAReservationResourcePool -SchemaClassId Infrastructure.Reservation.Virtual.vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true, ValueFromPipelineByPropertyName)]
    [ValidateNotNullOrEmpty()]
    [String]$SchemaClassId,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$ComputeResourceId,
    
    [parameter(Mandatory=$true,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name
       
    )    

    try {

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
        
        switch ($PsCmdlet.ParameterSetName) {

            'ByName' { 

                foreach ($ResourcePoolName in $Name) {

                    $URI = "/reservation-service/api/data-service/schema/$($SchemaClassId)/default/resourcePool/values"
            
                    Write-Verbose -Message "Preparing POST to $($URI)"

                    $Response = Invoke-vRARestMethod -Method POST -URI "$($URI)" -Body $Body

                    Write-Verbose -Message "SUCCESS"

                    # --- Get the resource pool by name
                    $ResourcePool = $Response.values | Where-Object {$_.label -eq $ResourcePoolName}

                    if(!$ResourcePool) {

                        throw "Could not find resource pool with name $($ResourcePoolName)"

                    }

                    [pscustomobject] @{

                        Type = $ResourcePool.underlyingValue.type
                        ComponentId = $ResourcePool.underlyingValue.componentId
                        ClassId = $ResourcePool.underlyingValue.classId
                        Id = $ResourcePool.underlyingValue.id
                        Label = $ResourcePool.underlyingValue.label

                    }

                }

                break

            }

            'Standard' {

                $URI = "/reservation-service/api/data-service/schema/$($SchemaClassId)/default/resourcePool/values"

                Write-Verbose -Message "Preparing POST to $($URI)"

                $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body

                Write-Verbose -Message "SUCCESS"

                # --- Return all resource pools
                foreach ($ResourcePool in $Response.values) {

                    [pscustomobject] @{
                        
                        Type = $ResourcePool.underlyingValue.type
                        ComponentId = $ResourcePool.underlyingValue.componentId
                        ClassId = $ResourcePool.underlyingValue.classId
                        Id = $ResourcePool.underlyingValue.id
                        Label = $ResourcePool.underlyingValue.label

                    }                
                
                }            

                break
    
            }

        }
           
    }
    catch [Exception]{
        
        throw

    }   
     
}