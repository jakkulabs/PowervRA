function Get-vRAReservationComputeResourceNetwork {
<#
    .SYNOPSIS
    Get available networks for a compute resource
    
    .DESCRIPTION
    Get available network for a compute resource

    .PARAMETER Type
    The reservation type
    
    .PARAMETER Name
    The name of the network

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAReservationComputeResourceNetwork -Type vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d -Name VMNetwork

    .EXAMPLE
    Get-vRAReservationComputeResourceNetwork -Type vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Type,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$ComputeResourceId,
    
    [parameter(Mandatory=$true,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name
       
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
        
            switch ($PsCmdlet.ParameterSetName) {

                'ByName' { 

                    foreach ($NetworkName in $Name) {

                        $URI = "/reservation-service/api/data-service/schema/$($SchemaClassId)/default/reservationNetworks/values"
            
                        Write-Verbose -Message "Preparing POST to $($URI)"

                        $Response = Invoke-vRARestMethod -Method POST -URI "$($URI)" -Body $Body

                        Write-Verbose -Message "SUCCESS"

                        # --- Get the network resource by name
                        $Network = $Response.values | Where-Object {$_.label -eq $NetworkName}

                        if(!$Network) {

                            throw "Could not find network with name $($NetworkName)"

                        }

                        [pscustomobject] @{

                            Type = $Network.underlyingValue.type
                            ComponentTypeId = $Network.underlyingValue.componentTypeId
                            ComponentId = $Network.underlyingValue.componentId
                            ClassId = $Network.underlyingValue.classId
                            TypeFilter = $Network.underlyingValue.TypeFilter
                            Values = $Network.underlyingValue.values

                        }

                    }

                    break

                }

                'Standard' {

                    $URI = "/reservation-service/api/data-service/schema/$($SchemaClassId)/default/reservationNetworks/values"

                    Write-Verbose -Message "Preparing POST to $($URI)"

                    $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body

                    Write-Verbose -Message "SUCCESS"

                    # --- Return all networks 
                    foreach ($Network in $Response.values) {

                        [pscustomobject] @{
                        
                            Type = $Network.underlyingValue.type
                            Name = $Network.label
                            ComponentTypeId = $Network.underlyingValue.componentTypeId
                            ComponentId = $Network.underlyingValue.componentId
                            ClassId = $Network.underlyingValue.classId
                            TypeFilter = $Network.underlyingValue.TypeFilter
                            Values = $Network.underlyingValue.values

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
     
}