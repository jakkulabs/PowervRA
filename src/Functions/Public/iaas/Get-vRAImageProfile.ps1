function Get-vRAImageProfile {
    <#
        .SYNOPSIS
        Get a vRA Image Profile
    
        .DESCRIPTION
        Get a vRA Image Profile
    
        .PARAMETER Id
        The ID of the vRA Image Profile
    
        .PARAMETER Name
        The Name of the vRA Image Profile
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRAImageProfile
    
        .EXAMPLE
        Get-vRAImageProfile -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRAImageProfile -Name 'TestImageProfile'
    
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
            $APIUrl = '/iaas/api/image-profiles'
    
            function CalculateOutput([PSCustomObject]$ImageProfile) {
    
                [PSCustomObject] @{
                    ImageMappings = $ImageProfile.imageMappings.mapping  ## Pull out mappings from nested JSON object
                    ImageMapNames = ($ImageProfile.imageMappings.mapping | get-member -MemberType NoteProperty).Name  ## List mappings by their key name for easier access
                    ExternalRegionId = $ImageProfile.externalRegionId
                    Name = $ImageProfile.name
                    Id = $ImageProfile.id
                    UpdatedAt = $ImageProfile.updatedAt
                    OrganizationId = $ImageProfile.organizationId
                    Links = $ImageProfile._links
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Image Profile by Id
                    'ById' {
    
                        foreach ($ImageProfileId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($ImageProfileId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($ImageProfile in $Response.content) {
                                CalculateOutput $ImageProfile
                            }
                        }
    
                        break
                    }
                    # --- Get Image Profile by Name
                    'ByName' {
    
                        foreach ($ImageProfileName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($ImageProfileName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($ImageProfile in $Response.content) {
                                CalculateOutput $ImageProfile
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Image Profiles
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($ImageProfile in $Response.content) {
                            CalculateOutput $ImageProfile
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
    