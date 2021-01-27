function Get-vRAExternalNetworkIPRange {
    <#
        .SYNOPSIS
        Get a vRA External Network IP Range
    
        .DESCRIPTION
        Get a vRA External Network IP Range
    
        .PARAMETER Id
        The ID of the vRA External Network IP Range
    
        .PARAMETER Name
        The Name of the vRA External Network IP Range
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRAExternalNetworkIPRange
    
        .EXAMPLE
        Get-vRAExternalNetworkIPRange -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRAExternalNetworkIPRange -Name 'TestExternalNetworkIPRange'
    
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
            $APIUrl = '/iaas/api/external-network-ip-ranges'
    
            function CalculateOutput([PSCustomObject]$ExternalNetworkIPRange) {
    
                [PSCustomObject] @{
                    Owner = $ExternalNetworkIPRange.owner
                    Description = $ExternalNetworkIPRange.description
                    Tags = $ExternalNetworkIPRange.tags
                    ExternalId = $ExternalNetworkIPRange.externalId
                    SubnetPrefixLength = $ExternalNetworkIPRange.subnetPrefixLength
                    Name = $ExternalNetworkIPRange.name
                    Id = $ExternalNetworkIPRange.id
                    CreatedAt = $ExternalNetworkIPRange.createdAt
                    UpdatedAt = $ExternalNetworkIPRange.updatedAt
                    OrganizationId = $ExternalNetworkIPRange.orgId
                    StartIPAddress = $ExternalNetworkIPRange.startIPAddress
                    EndIPAddress = $ExternalNetworkIPRange.endIPAddress
                    IPVersion = $ExternalNetworkIPRange.ipVersion
                    AddressSpaceId = $ExternalNetworkIPRange.addressSpaceId
                    DNSServerAddresses = $ExternalNetworkIPRange.dnsServerAddresses
                    DNSSearchDomains = $ExternalNetworkIPRange.dnsSearchDomains
                    Domain = $ExternalNetworkIPRange.domain
                    GatewayAddress = $ExternalNetworkIPRange.gatewayAddress
                    Links = $ExternalNetworkIPRange._links
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get External Network IP Range by Id
                    'ById' {
    
                        foreach ($ExternalNetworkIPRangeId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($ExternalNetworkIPRangeId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($ExternalNetworkIPRange in $Response.content) {
                                CalculateOutput $ExternalNetworkIPRange
                            }
                        }
    
                        break
                    }
                    # --- Get External Network IP Range by Name
                    'ByName' {
    
                        foreach ($ExternalNetworkIPRangeName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($ExternalNetworkIPRangeName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($ExternalNetworkIPRange in $Response.content) {
                                CalculateOutput $ExternalNetworkIPRange
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all External Network IP Ranges
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($ExternalNetworkIPRange in $Response.content) {
                            CalculateOutput $ExternalNetworkIPRange
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
    