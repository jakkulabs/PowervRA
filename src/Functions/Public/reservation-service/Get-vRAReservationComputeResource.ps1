function Get-vRAReservationComputeResource {
<#
    .SYNOPSIS
    Get a compute resource for a reservation type
    
    .DESCRIPTION
    Get a compute resource for a reservation type

    .PARAMETER Type
    The resource type
    Valid types vRA 7.1 and earlier: Amazon, Hyper-V, KVM, OpenStack, SCVMM, vCloud Air, vCloud Director, vSphere,XenServer
    Valid types vRA 7.2 and later: Amazon EC2, Azure, Hyper-V (SCVMM), Hyper-V (Standalone), KVM (RHEV), OpenStack, vCloud Air, vCloud Director, vSphere (vCenter), XenServer

    .PARAMETER Id
    The id of the compute resource
    
    .PARAMETER Name
    The name of the compute resource

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    # Retrieve a list of compatible reservation types
    Get-vRAReservationType | Select Name

    # Retrieve associated compute resources for the desired reservation type in vRA 7.1
    Get-vRAReservationComputeResource -Type 'vSphere'

    .EXAMPLE
    # Retrieve a list of compatible reservation types
    Get-vRAReservationType | Select Name

    # Retrieve associated compute resources for the desired reservation type in vRA 7.2 and later
    Get-vRAReservationComputeResource -Type 'vSphere (vCenter)'

    .EXAMPLE
    # Retrieve associated compute resources for the vSphere reservation type in vRA 7.1
    Get-vRAReservationComputeResource -Type 'vSphere' -Id 75ae3400-beb5-4b0b-895a-0484413c93b1

    .EXAMPLE
    # Retrieve associated compute resources for the vSphere reservation type in vRA 7.2 and later
    Get-vRAReservationComputeResource -Type 'vSphere (vCenter)' -Id 75ae3400-beb5-4b0b-895a-0484413c93b1

    .EXAMPLE
    # Retrieve associated compute resources for the desired reservation type in vRA 7.1
    Get-vRAReservationComputeResource -Type 'vSphere' -Name "Cluster01 (vCenter)"

    .EXAMPLE
    # Retrieve associated compute resources for the desired reservation type in vRA 7.2 and later
    Get-vRAReservationComputeResource -Type 'vSphere (vCenter)' -Name "Cluster01 (vCenter)"
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Type,

    [parameter(Mandatory=$true,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,
    
    [parameter(Mandatory=$true,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name
       
    ) 
      
    begin {}
    
    process {   

        try {

            $SchemaClassId = (Get-vRAReservationType -Name $Type).schemaClassId

            switch ($PsCmdlet.ParameterSetName) {

                'ById' { 

                    foreach ($ComputeResourceId in $Id) {

                        $URI = "/reservation-service/api/data-service/schema/$($SchemaClassId)/default/computeResource/values"
            
                        Write-Verbose -Message "Preparing POST to $($URI)"

                        $Response = Invoke-vRARestMethod -Method POST -URI "$($URI)" -Body "{}"

                        Write-Verbose -Message "SUCCESS"

                        # --- Get the compute resource by id
                        $ComputeResource = $Response.values | Where-Object {$_.underlyingValue.id -eq $ComputeResourceId}

                        if(!$ComputeResource) {

                            throw "Could not find compute resource with id $($ComputeResourceId)"

                        }

                        [pscustomobject] @{

                            type = $ComputeResource.underlyingValue.type
                            componentId = $ComputeResource.underlyingValue.componentId
                            classId = $ComputeResource.underlyingValue.classId
                            id = $ComputeResource.underlyingValue.id
                            label = $ComputeResource.underlyingValue.label

                        }

                    }

                    break

                }

                'ByName' {

                    foreach ($ComputeResourceName in $Name) {

                        $URI = "/reservation-service/api/data-service/schema/$($SchemaClassId)/default/computeResource/values"
            
                        Write-Verbose -Message "Preparing POST to $($URI)"

                        $Response = Invoke-vRARestMethod -Method POST -URI "$($URI)" -Body "{}"

                        Write-Verbose -Message "SUCCESS"

                        # --- Get the compute resource by name
                        $ComputeResource = $Response.values | Where-Object {$_.underlyingValue.label -eq $ComputeResourceName}

                        if(!$ComputeResource) {

                            throw "Could not find compute resource with name $($ComputeResourceName)"

                        }

                        [pscustomobject] @{

                            type = $ComputeResource.underlyingValue.type
                            componentId = $ComputeResource.underlyingValue.componentId
                            classId = $ComputeResource.underlyingValue.classId
                            id = $ComputeResource.underlyingValue.id
                            label = $ComputeResource.underlyingValue.label

                        }

                    }

                    break                                          
        
                }

                'Standard' {

                    $URI = "/reservation-service/api/data-service/schema/$($SchemaClassId)/default/computeResource/values"

                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body "{}"

                    # --- Return all compute resources
                    foreach ($ComputeResource in $Response.values) {

                        [pscustomobject] @{

                            type = $ComputeResource.underlyingValue.type
                            componentId = $ComputeResource.underlyingValue.componentId
                            classId = $ComputeResource.underlyingValue.classId
                            id = $ComputeResource.underlyingValue.id
                            label = $ComputeResource.underlyingValue.label

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