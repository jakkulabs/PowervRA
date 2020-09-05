function Get-vRAvSphereFabricStoragePolicy {
    <#
        .SYNOPSIS
        Get a only vSphere Fabric Storage Policy from vRA
    
        .DESCRIPTION
        Get a only vSphere Fabric Storage Policy from vRA
    
        .PARAMETER Id
        The ID of the vSphere Fabric Storage Policy
    
        .PARAMETER Name
        The Name of the vSphere Fabric Storage Policy
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRAvSphereFabricStoragePolicy
    
        .EXAMPLE
        Get-vRAvSphereFabricStoragePolicy -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRAvSphereFabricStoragePolicy -Name 'TestFabricStoragePolicy'
    
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
            $APIUrl = '/iaas/api/fabric-vsphere-storage-policies'
    
            function CalculateOutput([PSCustomObject]$FabricStoragePolicy) {
    
                [PSCustomObject] @{
                    ExternalRegionId = $FabricStoragePolicy.externalRegionId
                    CloudAccountIds = $FabricStoragePolicy.cloudAccountIds
                    ExternalId = $FabricStoragePolicy.externalId
                    Name = $FabricStoragePolicy.name
                    Description = $FabricStoragePolicy.description
                    Id = $FabricStoragePolicy.id
                    CreatedAt = $FabricStoragePolicy.createdAt
                    UpdatedAt = $FabricStoragePolicy.updatedAt
                    OrganizationId = $FabricStoragePolicy.organizationId
                    Links = $FabricStoragePolicy._links
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get vSphere Fabric Storage Policy by Id
                    'ById' {
    
                        foreach ($FabricStoragePolicyId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($FabricStoragePolicyId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($FabricStoragePolicy in $Response.content) {
                                CalculateOutput $FabricStoragePolicy
                            }
                        }
    
                        break
                    }
                    # --- Get vSphere Fabric Storage Policy by Name
                    'ByName' {
    
                        foreach ($FabricStoragePolicyName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($FabricStoragePolicyName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($FabricStoragePolicy in $Response.content) {
                                CalculateOutput $FabricStoragePolicy
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all vSphere Fabric Storage Policies
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($FabricStoragePolicy in $Response.content) {
                            CalculateOutput $FabricStoragePolicy
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
    