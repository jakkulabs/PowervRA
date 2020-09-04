function Get-vRAFlavorProfile {
    <#
        .SYNOPSIS
        Get a vRA Flavor Profile
    
        .DESCRIPTION
        Get a vRA Flavor Profile
    
        .PARAMETER Id
        The ID of the vRA Flavor Profile
    
        .PARAMETER Name
        The Name of the vRA Flavor Profile
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRAFlavorProfile
    
        .EXAMPLE
        Get-vRAFlavorProfile -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRAFlavorProfile -Name 'TestFlavorProfile'
    
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
            $APIUrl = '/iaas/api/flavor-profiles'
    
            function CalculateOutput([PSCustomObject]$FlavorProfile) {
    
                [PSCustomObject] @{
                    FlavorMappings = $FlavorProfile.flavorMappings
                    ExternalRegionId = $FlavorProfile.externalRegionId
                    Name = $FlavorProfile.name
                    Id = $FlavorProfile.id
                    UpdatedAt = $FlavorProfile.updatedAt
                    OrganizationId = $FlavorProfile.organizationId
                    Links = $FlavorProfile._links
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Flavor Profile by Id
                    'ById' {
    
                        foreach ($FlavorProfileId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($FlavorProfileId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($FlavorProfile in $Response.content) {
                                CalculateOutput $FlavorProfile
                            }
                        }
    
                        break
                    }
                    # --- Get Flavor Profile by Name
                    'ByName' {
    
                        foreach ($FlavorProfileName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($FlavorProfileName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($FlavorProfile in $Response.content) {
                                CalculateOutput $FlavorProfile
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Flavor Profiles
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($FlavorProfile in $Response.content) {
                            CalculateOutput $FlavorProfile
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
    