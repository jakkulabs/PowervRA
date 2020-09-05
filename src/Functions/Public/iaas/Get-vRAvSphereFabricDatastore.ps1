function Get-vRAvSphereFabricDatastore {
    <#
        .SYNOPSIS
        Get a only vSphere Fabric Datastore from vRA
    
        .DESCRIPTION
        Get a only vSphere Fabric Datastore from vRA
    
        .PARAMETER Id
        The ID of the vSphere Fabric Datastore
    
        .PARAMETER Name
        The Name of the vSphere Fabric Datastore
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRAvSphereFabricDatastore
    
        .EXAMPLE
        Get-vRAvSphereFabricDatastore -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRAvSphereFabricDatastore -Name 'TestFabricDatastore'
    
    #>
    [CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]
    
        Param (
    
            [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
            [ValidateNotNullOrEmpty()]
            [String[]]$Id,
    
            [Parameter(Mandatory=$true,ParameterSetName="ByName")]
            [ValidateNotNullOrEmpty()]
            [String[]]$Name
        )
    
        begin {
            $APIUrl = '/iaas/api/fabric-vsphere-datastores'
    
            function CalculateOutput([PSCustomObject]$FabricDatastore) {
    
                [PSCustomObject] @{
                    Type = $FabricDatastore.type
                    ExternalRegionId = $FabricDatastore.externalRegionId
                    FreeSizeGB = $FabricDatastore.freeSizeGB
                    CloudAccountIds = $FabricDatastore.cloudAccountIds
                    ExternalId = $FabricDatastore.externalId
                    Name = $FabricDatastore.name
                    Id = $FabricDatastore.id
                    CreatedAt = $FabricDatastore.createdAt
                    UpdatedAt = $FabricDatastore.updatedAt
                    OrganizationId = $FabricDatastore.organizationId
                    Links = $FabricDatastore._links
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Fabric Datastore by Id
                    'ById' {
    
                        foreach ($FabricDatastoreId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($FabricDatastoreId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($FabricDatastore in $Response.content) {
                                CalculateOutput $FabricDatastore
                            }
                        }
    
                        break
                    }
                    # --- Get Fabric Datastore by Name
                    'ByName' {
    
                        foreach ($FabricDatastoreName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($FabricDatastoreName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($FabricDatastore in $Response.content) {
                                CalculateOutput $FabricDatastore
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Fabric Datastores
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($FabricDatastore in $Response.content) {
                            CalculateOutput $FabricDatastore
                        }
                    }
                }
            }
            catch [Exception]{
    
                throw
            }
        }
    
        end {
    
        }
    }
    