function Get-vRAStorageProfile {
    <#
        .SYNOPSIS
        Get a vRA Storage Profile
    
        .DESCRIPTION
        Get a vRA Storage Profile
    
        .PARAMETER Id
        The ID of the vRA Storage Profile
    
        .PARAMETER Name
        The Name of the vRA Storage Profile
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRAStorageProfile
    
        .EXAMPLE
        Get-vRAStorageProfile -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRAStorageProfile -Name 'TestStorageProfile'
    
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
            $APIUrl = '/iaas/api/storage-profiles'
    
            function CalculateOutput([PSCustomObject]$StorageProfile) {
    
                [PSCustomObject] @{
                    Owner = $StorageProfile.owner
                    Links = $StorageProfile._links
                    SupportsEncryption = $StorageProfile.supportsEncryption
                    ExternalRegionId = $StorageProfile.externalRegionId
                    Description = $StorageProfile.description
                    OrganizationId = $StorageProfile.orgId
                    Tags = $StorageProfile.tags
                    CreatedAt = $StorageProfile.createdAt
                    DiskProperties = $StorageProfile.diskProperties
                    Name = $StorageProfile.name
                    Id = $StorageProfile.id
                    DefaultItem = $StorageProfile.defaultItem
                    UpdatedAt = $StorageProfile.updatedAt
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Storage Profile by Id
                    'ById' {
    
                        foreach ($StorageProfileId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($StorageProfileId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($StorageProfile in $Response.content) {
                                CalculateOutput $StorageProfile
                            }
                        }
    
                        break
                    }
                    # --- Get Storage Profile by Name
                    'ByName' {
    
                        foreach ($StorageProfileName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($StorageProfileName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($StorageProfile in $Response.content) {
                                CalculateOutput $StorageProfile
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Storage Profiles
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($StorageProfile in $Response.content) {
                            CalculateOutput $StorageProfile
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
    