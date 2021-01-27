function Get-vRABlueprintVersion {
    <#
        .SYNOPSIS
        Get a vRA Blueprint's Versions
    
        .DESCRIPTION
        Get a vRA Blueprint's Versions
    
        .PARAMETER Blueprint
        The vRA Blueprint object as returned by Get-vRABlueprint
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRABlueprint | Get-vRABlueprintVersion
    
        .EXAMPLE
        Get-vRABlueprintVersion -Blueprint (Get-vRABlueprint -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9')
    
        .EXAMPLE
        Get-vRABlueprintVersion -Blueprint (Get-vRABlueprint -Name 'TestBlueprint')
    
    #>
    [CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]
    
        Param (
    
            [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="Blueprint")]
            [ValidateNotNullOrEmpty()]
            [PSCustomObject[]]$Blueprint
        )
    
        begin {
            $APIUrl = '/blueprint/api/blueprints'
    
            function CalculateOutput([PSCustomObject]$BlueprintVersion) {
    
                [PSCustomObject] @{
                    Id = $BlueprintVersion.id
                    CreatedAt = $BlueprintVersion.createdAt
                    CreatedBy = $BlueprintVersion.createdBy
                    UpdatedAt = $BlueprintVersion.updatedAt
                    UpdatedBy = $BlueprintVersion.updatedBy
                    OrganizationId = $BlueprintVersion.orgId
                    ProjectId = $BlueprintVersion.projectId
                    ProjectName = $BlueprintVersion.projectName
                    SelfLink = $BlueprintVersion.selfLink
                    BlueprintId = $BlueprintVersion.blueprintId
                    Name = $BlueprintVersion.name
                    Description = $BlueprintVersion.description
                    Version = $BlueprintVersion.version
                    Status = $BlueprintVersion.status
                    VersionDescription = $BlueprintVersion.versionDescription
                    VersionChangeLog = $BlueprintVersion.versionChangeLog
                    Valid = $BlueprintVersion.valid
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get BlueprintVersion from Blueprint object
                    'Blueprint' {
    
                        foreach ($Blueprintobj in $Blueprint){
    
                            $URI = "$($APIUrl)/$($Blueprintobj.Id)/versions"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
                            
                            foreach($version in $Response.content){
                                CalculateOutput $version
                            }
                        }
    
                        break
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
    