function Get-vRAReservationComputeResourceResourcePool {
<#
    .SYNOPSIS
    Get available resource pools for a compute resource
    
    .DESCRIPTION
    Get available resource pools for a compute resource

    .PARAMETER Type
    The reservation type
    Valid types vRA 7.1 and earlier: Amazon, Hyper-V, KVM, OpenStack, SCVMM, vCloud Air, vCloud Director, vSphere, XenServer
    Valid types vRA 7.2 and later: Amazon EC2, Azure, Hyper-V (SCVMM), Hyper-V (Standalone), KVM (RHEV), OpenStack, vCloud Air, vCloud Director, vSphere (vCenter), XenServer

    .PARAMETER ComputeResourceId
    The id of the compute resource

    .PARAMETER Name
    The name of the resource pool

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    # Retrieve associated compute resources for the desired reservation type in vRA 7.1
    Get-vRAReservationComputeResource -Type 'vSphere' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

    # Retrieve all associated compute resource resource pools for the desired reservation type in vRA 7.1
    Get-vRAReservationComputeResourceResourcePool -Type vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d

    .EXAMPLE
    # Retrieve associated compute resources for the desired reservation type in vRA 7.1
    Get-vRAReservationComputeResource -Type 'vSphere' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

    # Retrieve associated compute resource resource pool for the desired reservation type in vRA 7.1
    Get-vRAReservationComputeResourceResourcePool -Type 'vSphere' -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d -Name ResourcePool1

    .EXAMPLE
    # Retrieve associated compute resources for the desired reservation type in vRA 7.2 and later
    Get-vRAReservationComputeResource -Type 'vSphere (vCenter)' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

    # Retrieve associated compute resource resource pool for the desired reservation type in vRA 7.2 and later
    Get-vRAReservationComputeResourceResourcePool -Type 'vSphere (vCenter)' -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d -Name ResourcePool1
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
     
}