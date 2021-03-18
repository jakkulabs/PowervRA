function Get-vRANetworkProfile {
    <#
        .SYNOPSIS
        Get a vRA Network Profile
    
        .DESCRIPTION
        Get a vRA Network Profile
    
        .PARAMETER Id
        The ID of the Network Profile
    
        .PARAMETER Name
        The Name of the Network Profile
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRANetworkProfile
    
        .EXAMPLE
        Get-vRANetworkProfile -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRANetworkProfile -Name 'TestNetworkProfile'
    
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
            $APIUrl = '/iaas/api/network-profiles'
    
            function CalculateOutput([PSCustomObject]$NetworkProfile) {
    
                [PSCustomObject] @{
                    ExternalRegionId = $NetworkProfile.externalRegionId
                    IsolationType = $NetworkProfile.isolationType
                    CustomProperties = $NetworkProfile.customProperties
                    Name = $NetworkProfile.name
                    Id = $NetworkProfile.id
                    UpdatedAt = $NetworkProfile.updatedAt
                    OrganizationId = $NetworkProfile.organizationId
                    Links = $NetworkProfile._links
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Network Profile by Id
                    'ById' {
    
                        foreach ($NetworkProfileId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($NetworkProfileId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($NetworkProfile in $Response.content) {
                                CalculateOutput $NetworkProfile
                            }
                        }
    
                        break
                    }
                    # --- Get Network Profile by Name
                    'ByName' {
    
                        foreach ($NetworkProfileName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($NetworkProfileName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($NetworkProfile in $Response.content) {
                                CalculateOutput $NetworkProfile
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Network Profiles
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($NetworkProfile in $Response.content) {
                            CalculateOutput $NetworkProfile
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
    