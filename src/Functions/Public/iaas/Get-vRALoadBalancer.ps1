function Get-vRALoadBalancer {
    <#
        .SYNOPSIS
        Get a vRA Load Balancer
    
        .DESCRIPTION
        Get a vRA Load Balancer
    
        .PARAMETER Id
        The ID of the vRA Load Balancer
    
        .PARAMETER Name
        The Name of the vRA Load Balancer
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRALoadBalancer
    
        .EXAMPLE
        Get-vRALoadBalancer -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRALoadBalancer -Name 'TestLoadBalancer'
    
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
            $APIUrl = '/iaas/api/load-balancers'
    
            function CalculateOutput([PSCustomObject]$LoadBalancer) {
    
                [PSCustomObject] @{
                    Address = $LoadBalancer.address
                    Routes = $LoadBalancer.routes
                    ExternalRegionId = $LoadBalancer.externalRegionId
                    CloudAccountIds = $LoadBalancer.cloudAccountIds
                    Tags = $LoadBalancer.tags
                    CustomProperties = $LoadBalancer.customProperties
                    ExternalId = $LoadBalancer.externalId
                    Name = $LoadBalancer.name
                    Id = $LoadBalancer.id
                    UpdatedAt = $LoadBalancer.updatedAt
                    OrgId = $LoadBalancer.orgId
                    Links = $LoadBalancer._links
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Load Balancer by Id
                    'ById' {
    
                        foreach ($LoadBalancerId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($LoadBalancerId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($LoadBalancer in $Response.content) {
                                CalculateOutput $LoadBalancer
                            }
                        }
    
                        break
                    }
                    # --- Get Load Balancer by Name
                    'ByName' {
    
                        foreach ($LoadBalancerName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($LoadBalancerName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($LoadBalancer in $Response.content) {
                                CalculateOutput $LoadBalancer
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Load Balancers
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($LoadBalancer in $Response.content) {
                            CalculateOutput $LoadBalancer
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
    