function Get-vRASecurityGroup {
    <#
        .SYNOPSIS
        Get a vRA Security Group
    
        .DESCRIPTION
        Get a vRA Security Group
    
        .PARAMETER Id
        The ID of the vRA Security Group
    
        .PARAMETER Name
        The Name of the vRA Security Group
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRASecurityGroup
    
        .EXAMPLE
        Get-vRASecurityGroup -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRASecurityGroup -Name 'TestSecurityGroup'
    
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
            $APIUrl = '/iaas/api/security-groups'
    
            function CalculateOutput([PSCustomObject]$SecurityGroup) {
    
                [PSCustomObject] @{
                    Rules = $SecurityGroup.rules
                    ExternalRegionId = $SecurityGroup.externalRegionId
                    CloudAccountIds = $SecurityGroup.cloudAccountIds
                    Tags = $SecurityGroup.tags
                    CustomProperties = $SecurityGroup.customProperties
                    ExternalId = $SecurityGroup.externalId
                    Name = $SecurityGroup.name
                    Id = $SecurityGroup.id
                    CreatedAt = $SecurityGroup.createdAt
                    UpdatedAt = $SecurityGroup.updatedAt
                    organizationId = $SecurityGroup.orgId
                    Links = $SecurityGroup._links
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Security Group by Id
                    'ById' {
    
                        foreach ($SecurityGroupId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($SecurityGroupId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($SecurityGroup in $Response.content) {
                                CalculateOutput $SecurityGroup
                            }
                        }
    
                        break
                    }
                    # --- Get Security Group by Name
                    'ByName' {
    
                        foreach ($SecurityGroupName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($SecurityGroupName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($SecurityGroup in $Response.content) {
                                CalculateOutput $SecurityGroup
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Security Groups
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($SecurityGroup in $Response.content) {
                            CalculateOutput $SecurityGroup
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
    