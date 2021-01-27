function Get-vRAFabricCompute {
    <#
        .SYNOPSIS
        Get a vRA Fabric Compute
    
        .DESCRIPTION
        Get a vRA Fabric Compute
    
        .PARAMETER Id
        The ID of the Fabric Compute
    
        .PARAMETER Name
        The Name of the Fabric Compute
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRAFabricCompute
    
        .EXAMPLE
        Get-vRAFabricCompute -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRAFabricCompute -Name 'TestFabricCompute'
    
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
            $APIUrl = '/deployment/api/fabric-computes'
    
            function CalculateOutput([PSCustomObject]$FabricCompute) {
    
                [PSCustomObject] @{
                    ExternalRegionId = $FabricCompute.externalRegionId
                    Tags = $FabricCompute.tags
                    Type = $FabricCompute.type
                    CustomProperties = $FabricCompute.customProperties
                    ExternalId = $FabricCompute.externalId
                    Name = $FabricCompute.name
                    Id = $FabricCompute.id
                    CreatedAt = $FabricCompute.createdAt
                    UpdatedAt = $FabricCompute.updatedAt
                    OrganizationId = $FabricCompute.organizationId
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get FabricCompute by Id
                    'ById' {
    
                        foreach ($FabricComputeId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($FabricComputeId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($FabricCompute in $Response.content) {
                                CalculateOutput $FabricCompute
                            }
                        }
    
                        break
                    }
                    # --- Get FabricCompute by Name
                    'ByName' {
    
                        foreach ($FabricComputeName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($FabricComputeName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($FabricCompute in $Response.content) {
                                CalculateOutput $FabricCompute
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all FabricComputes
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($FabricCompute in $Response.content) {
                            CalculateOutput $FabricCompute
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
    