function Get-vRANetworkIPRange {
    <#
        .SYNOPSIS
        Get a vRA Network IP Ranges
    
        .DESCRIPTION
        Get a vRA Network IP Ranges
    
        .PARAMETER Id
        The ID of the vRA Network IP Ranges
    
        .PARAMETER Name
        The Name of the vRA Network IP Ranges
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRANetworkIPRange
    
        .EXAMPLE
        Get-vRANetworkIPRange -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRANetworkIPRange -Name 'TestNetworkIPRange'
    
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
            $APIUrl = '/iaas/api/network-ip-ranges'
    
            function CalculateOutput([PSCustomObject]$NetworkIPRange) {
    
                [PSCustomObject] @{
                    Owner = $NetworkIPRange.owner
                    Description = $NetworkIPRange.description
                    Tags = $NetworkIPRange.tags
                    ExternalId = $NetworkIPRange.externalId
                    Name = $NetworkIPRange.name
                    Id = $NetworkIPRange.id
                    CreatedAt = $NetworkIPRange.createdAt
                    UpdatedAt = $NetworkIPRange.updatedAt
                    OrganizationId = $NetworkIPRange.orgId
                    StartIPAddress = $NetworkIPRange.startIPAddress
                    EndIPAddress = $NetworkIPRange.endIPAddress
                    IPVersion = $NetworkIPRange.ipVersion
                    Links = $NetworkIPRange._links
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Network IP Range by Id
                    'ById' {
    
                        foreach ($NetworkIPRangeId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($NetworkIPRangeId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($NetworkIPRange in $Response.content) {
                                CalculateOutput $NetworkIPRange
                            }
                        }
    
                        break
                    }
                    # --- Get Network IP Range by Name
                    'ByName' {
    
                        foreach ($NetworkIPRangeName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($NetworkIPRangeName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($NetworkIPRange in $Response.content) {
                                CalculateOutput $NetworkIPRange
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Network IP Ranges
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($NetworkIPRange in $Response.content) {
                            CalculateOutput $NetworkIPRange
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