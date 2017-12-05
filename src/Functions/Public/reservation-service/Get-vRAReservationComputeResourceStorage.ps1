function Get-vRAReservationComputeResourceStorage {
<#
    .SYNOPSIS
    Get available storage for a compute resource
    
    .DESCRIPTION
    Get available storage for a compute resource

    .PARAMETER Type
    The reservation type
    Valid types vRA 7.1 and earlier: Amazon, Hyper-V, KVM, OpenStack, SCVMM, vCloud Air, vCloud Director, vSphere, XenServer
    Valid types vRA 7.2 and later: Amazon EC2, Azure, Hyper-V (SCVMM), Hyper-V (Standalone), KVM (RHEV), OpenStack, vCloud Air, vCloud Director, vSphere (vCenter), XenServer
    
    .PARAMETER ComputeResourceId
    The id of the compute resource
    
    .PARAMETER Name
    The name of the storage

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    # Retrieve associated compute resources for the desired reservation type in vRA 7.1
    Get-vRAReservationComputeResource -Type 'vSphere' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

    # Retrieve all associated compute resource storage for the desired reservation type in vRA 7.1
    Get-vRAReservationComputeResourceStorage -Type 'vSphere' -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d

    .EXAMPLE
    # Retrieve associated compute resources for the desired reservation type in vRA 7.1
    Get-vRAReservationComputeResource -Type 'vSphere' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

    # Retrieve associated compute resource storage for the desired reservation type in vRA 7.1
    Get-vRAReservationComputeResourceStorage -Type 'vSphere' -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d -Name DataStore01

    .EXAMPLE
    # Retrieve associated compute resources for the desired reservation type in vRA 7.2 and later
    Get-vRAReservationComputeResource -Type 'vSphere (vCenter)' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

    # Retrieve associated compute resource storage for the desired reservation type in vRA 7.2 and later
    Get-vRAReservationComputeResourceStorage -Type 'vSphere (vCenter)' -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d -Name DataStore01
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