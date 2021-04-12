function Get-vRANetwork {
    <#
        .SYNOPSIS
        Get a vRA Network
    
        .DESCRIPTION
        Get a vRA Network
    
        .PARAMETER Id
        The ID of the vRA Network
    
        .PARAMETER Name
        The Name of the vRA Network
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRANetwork
    
        .EXAMPLE
        Get-vRANetwork -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRANetwork -Name 'TestNetwork'
    
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
            $APIUrl = '/iaas/api/networks'
    
            function CalculateOutput([PSCustomObject]$Network) {
    
                [PSCustomObject] @{
                    Cidr = $Network.cidr
                    ExternalZoneId = $Network.externalZoneId
                    ExternalRegionId = $Network.externalRegionId
                    CloudAccountIds = $Network.cloudAccountIds
                    Tags = $Network.tags
                    CustomProperties = $Network.customProperties
                    ExternalId = $Network.externalId
                    Name = $Network.name
                    Id = $Network.id
                    UpdatedAt = $Network.updatedAt
                    OrganizationId = $Network.orgId
                    Links = $Network._links
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Network by Id
                    'ById' {
    
                        foreach ($NetworkId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($NetworkId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($Network in $Response.content) {
                                CalculateOutput $Network
                            }
                        }
    
                        break
                    }
                    # --- Get Network by Name
                    'ByName' {
    
                        foreach ($NetworkName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($NetworkName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($Network in $Response.content) {
                                CalculateOutput $Network
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Networks
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($Network in $Response.content) {
                            CalculateOutput $Network
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