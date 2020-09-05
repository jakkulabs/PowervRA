function Get-vRARegion {
    <#
        .SYNOPSIS
        Get a vRA Region
    
        .DESCRIPTION
        Get a vRA Region
    
        .PARAMETER Id
        The ID of the vRA Region
    
        .PARAMETER Name
        The Name of the vRA Region
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRARegion
    
        .EXAMPLE
        Get-vRARegion -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRARegion -Name 'TestRegion'
    
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
            $APIUrl = '/iaas/api/regions'
    
            function CalculateOutput([PSCustomObject]$Region) {
    
                [PSCustomObject] @{
                    ExternalRegionId = $Region.externalRegionId
                    Name = $Region.name
                    CloudAccountId = $Region.cloudAccountId
                    Id = $Region.id
                    UpdatedAt = $Region.updatedAt
                    OrgId = $Region.orgId
                    Links = $Region._links
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Region by Id
                    'ById' {
    
                        foreach ($RegionId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($RegionId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($Region in $Response.content) {
                                CalculateOutput $Region
                            }
                        }
    
                        break
                    }
                    # --- Get Region by Name
                    'ByName' {
    
                        foreach ($RegionName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($RegionName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($Region in $Response.content) {
                                CalculateOutput $Region
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Regions
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($Region in $Response.content) {
                            CalculateOutput $Region
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
    