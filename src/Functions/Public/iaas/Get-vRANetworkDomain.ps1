function Get-vRANetworkDomain {
    <#
        .SYNOPSIS
        Get a vRA Network Domain
    
        .DESCRIPTION
        Get a vRA Network Domain
    
        .PARAMETER Id
        The ID of the vRA Network Domain
    
        .PARAMETER Name
        The Name of the vRA Network Domain
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRANetworkDomain
    
        .EXAMPLE
        Get-vRANetworkDomain -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRANetworkDomain -Name 'TestNetworkDomain'
    
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
            $APIUrl = '/iaas/api/network-domains'
    
            function CalculateOutput([PSCustomObject]$NetworkDomain) {
    
                [PSCustomObject] @{
                    ExternalRegionId = $NetworkDomain.externalRegionId
                    Tags = $NetworkDomain.tags
                    CustomProperties = $NetworkDomain.customProperties
                    CloudAccountIds = $NetworkDomain.cloudAccountIds
                    ExternalId = $NetworkDomain.externalId
                    Name = $NetworkDomain.name
                    Id = $NetworkDomain.id
                    CreatedAt = $NetworkDomain.createdAt
                    UpdatedAt = $NetworkDomain.updatedAt
                    OrganizationId = $NetworkDomain.orgId
                    Links = $NetworkDomain._links
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get NetworkDomain by Id
                    'ById' {
    
                        foreach ($NetworkDomainId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($NetworkDomainId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($NetworkDomain in $Response.content) {
                                CalculateOutput $NetworkDomain
                            }
                        }
    
                        break
                    }
                    # --- Get NetworkDomain by Name
                    'ByName' {
    
                        foreach ($NetworkDomainName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($NetworkDomainName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($NetworkDomain in $Response.content) {
                                CalculateOutput $NetworkDomain
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all NetworkDomains
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($NetworkDomain in $Response.content) {
                            CalculateOutput $NetworkDomain
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
    