function Get-vRAReservationComputeResourceStorage {
<#
    .SYNOPSIS
    Get available storage for a compute resource
    
    .DESCRIPTION
    Get available storage for a compute resource

    .PARAMETER Type
    The reservation type
    
    .PARAMETER Name
    The name of the storage

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAReservationComputeResourceStorage -Type vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d -Name DataStore01

    .EXAMPLE
    Get-vRAReservationComputeResourceStorage -Type vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d

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

            $SchemaClassId = (Get-vRAReservationType -Name $Type).schemaClassid

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

                    foreach ($StorageName in $Name) {

                        $URI = "/reservation-service/api/data-service/schema/$($SchemaClassId)/default/reservationStorages/values"
            
                        Write-Verbose -Message "Preparing POST to $($URI)"

                        $Response = Invoke-vRARestMethod -Method POST -URI "$($URI)" -Body $Body

                        Write-Verbose -Message "SUCCESS"

                        # --- Get the storage resource by name
                        $Storage = $Response.values | Where-Object {$_.label -eq $StorageName}

                        if(!$Storage) {

                            throw "Could not find storage with name $($StorageName)"

                        }

                        [pscustomobject] @{

                            Type = $Storage.underlyingValue.type
                            ComponentTypeId = $Storage.underlyingValue.componentTypeId
                            ComponentId = $Storage.underlyingValue.componentId
                            ClassId = $Storage.underlyingValue.classId
                            TypeFilter = $Storage.underlyingValue.TypeFilter
                            Values = $Storage.underlyingValue.values

                        }

                    }

                    break

                }

                'Standard' {

                    $URI = "/reservation-service/api/data-service/schema/$($SchemaClassId)/default/reservationStorages/values"

                    Write-Verbose -Message "Preparing POST to $($URI)"

                    $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body

                    Write-Verbose -Message "SUCCESS"

                    # --- Return all storage 
                    foreach ($Storage in $Response.values) {

                        [pscustomobject] @{
                        
                            Type = $Storage.underlyingValue.type
                            Name = $Storage.label
                            ComponentTypeId = $Storage.underlyingValue.componentTypeId
                            ComponentId = $Storage.underlyingValue.componentId
                            ClassId = $Storage.underlyingValue.classId
                            TypeFilter = $Storage.underlyingValue.TypeFilter
                            Values = $Storage.underlyingValue.values

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