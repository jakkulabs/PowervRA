function Get-vRAFabricNetwork {
    <#
        .SYNOPSIS
        Get a vRA Fabric Network
    
        .DESCRIPTION
        Get a vRA Fabric Network
    
        .PARAMETER Id
        The ID of the Fabric Network
    
        .PARAMETER Name
        The Name of the Fabric Network
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRAFabricNetwork
    
        .EXAMPLE
        Get-vRAFabricNetwork -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRAFabricNetwork -Name 'TestFabricNetwork'
    
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
            $APIUrl = '/iaas/api/fabric-networks'
    
            function CalculateOutput([PSCustomObject]$FabricNetwork) {
    
                [PSCustomObject] @{
                    ExternalRegionId = $FabricNetwork.externalRegionId
                    CloudAccountIds = $FabricNetwork.cloudAccountIds
                    ExternalId = $FabricNetwork.externalId
                    Name = $FabricNetwork.name
                    Id = $FabricNetwork.id
                    CreatedAt = $FabricNetwork.createdAt
                    UpdatedAt = $FabricNetwork.updatedAt
                    OrganizationId = $FabricNetwork.organizationId
                    Links = $FabricNetwork._links
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Fabric Network by Id
                    'ById' {
    
                        foreach ($FabricNetworkId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($FabricNetworkId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($FabricNetwork in $Response.content) {
                                CalculateOutput $FabricNetwork
                            }
                        }
    
                        break
                    }
                    # --- Get Fabric Network by Name
                    'ByName' {
    
                        foreach ($FabricNetworkName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($FabricNetworkName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($FabricNetwork in $Response.content) {
                                CalculateOutput $FabricNetwork
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Fabric Networks
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($FabricNetwork in $Response.content) {
                            CalculateOutput $FabricNetwork
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
    