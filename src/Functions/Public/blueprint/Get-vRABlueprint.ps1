function Get-vRABlueprint {
    <#
        .SYNOPSIS
        Get a vRA Blueprint
    
        .DESCRIPTION
        Get a vRA Blueprint
    
        .PARAMETER Id
        The ID of the Blueprint
    
        .PARAMETER Name
        The Name of the Blueprint
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRABlueprint
    
        .EXAMPLE
        Get-vRABlueprint -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRABlueprint -Name 'TestBlueprint'
    
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
            $APIUrl = '/blueprint/api/blueprints'
    
            function CalculateOutput([PSCustomObject]$Blueprint) {
    
                [PSCustomObject] @{
                    Name = $Blueprint.name
                    Content = $Blueprint.content
                    Id = $Blueprint.id
                    CreatedAt = $Blueprint.createdAt
                    CreatedBy = $Blueprint.createdBy
                    UpdatedAt = $Blueprint.updatedAt
                    UpdatedBy = $Blueprint.updatedBy
                    OrgId = $Blueprint.orgId
                    ProjectId = $Blueprint.projectId
                    ProjectName = $Blueprint.projectName
                    Description = $Blueprint.description
                    Status = $Blueprint.status
                    TotalVersions = $Blueprint.totalVersions
                    TotalReleasedVersions = $Blueprint.totalReleasedVersions
                    RequestScopeOrg = $Blueprint.requestScopeOrg
                    Valid = $Blueprint.valid
                    ValidationMessages = $Blueprint.validationMessages
                    ContentSourceSyncMessages = $Blueprint.contentSourceSyncMessages
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Blueprint by Id
                    'ById' {
    
                        foreach ($BlueprintId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($BlueprintId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($Blueprint in $Response.content) {
                                # Get individual blueprint link
                                $BlueprintSelfLink = $blueprint.selfLink

                                # Get full blueprint resource info
                                $FullBlueprint = (Invoke-vRARestMethod -Method GET -URI $BlueprintSelfLink -Verbose:$VerbosePreference).Content
                                CalculateOutput $FullBlueprint
                            }
                        }
    
                        break
                    }
                    # --- Get Blueprint by Name
                    'ByName' {
    
                        foreach ($BlueprintName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($BlueprintName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($Blueprint in $Response.content) {
                                # Get individual blueprint link
                                $BlueprintSelfLink = $blueprint.selfLink

                                # Get full blueprint resource info
                                $FullBlueprint = (Invoke-vRARestMethod -Method GET -URI $BlueprintSelfLink -Verbose:$VerbosePreference).Content
                                CalculateOutput $FullBlueprint
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Blueprints
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($Blueprint in $Response.content) {
                            # Get individual blueprint link
                            $BlueprintSelfLink = $blueprint.selfLink

                            # Get full blueprint resource info
                            $FullBlueprint = (Invoke-vRARestMethod -Method GET -URI $BlueprintSelfLink -Verbose:$VerbosePreference).Content
                            CalculateOutput $FullBlueprint
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
    