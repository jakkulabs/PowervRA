function Get-vRADeployment {
    <#
        .SYNOPSIS
        Get a vRA Deployment
    
        .DESCRIPTION
        Get a vRA Deployment
    
        .PARAMETER Id
        The ID of the Deployment
    
        .PARAMETER Name
        The Name of the Deployment
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRADeployment
    
        .EXAMPLE
        Get-vRADeployment -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRADeployment -Name 'TestDeployment'
    
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
            $APIUrl = '/deployment/api/deployments'
    
            function CalculateOutput([PSCustomObject]$Deployment) {
    
                [PSCustomObject] @{
                    Id = $Deployment.id
                    Name = $Deployment.name
                    OrgId = $Deployment.orgId
                    CatalogItemId = $Deployment.catalogItemId
                    CatalogItemVersion = $Deployment.catalogItemVersion
                    BlueprintId = $Deployment.blueprintId
                    BlueprintVersion = $Deployment.blueprintVersion
                    IconId = $Deployment.iconId
                    CreatedAt = $Deployment.createdAt
                    CreatedBy = $Deployment.createdBy
                    LastUpdatedAt = $Deployment.lastUpdatedAt
                    LastUpdatedBy = $Deployment.lastUpdatedBy
                    LeaseExpireAt = $Deployment.leaseExpireAt
                    Inputs = $Deployment.inputs
                    ProjectId = $Deployment.projectId
                    Status = $Deployment.status
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Deployment by Id
                    'ById' {
    
                        foreach ($DeploymentId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($DeploymentId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($Deployment in $Response.content) {
                                CalculateOutput $Deployment
                            }
                        }
    
                        break
                    }
                    # --- Get Deployment by Name
                    'ByName' {
    
                        foreach ($DeploymentName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($DeploymentName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($Deployment in $Response.content) {
                                CalculateOutput $Deployment
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Deployments
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($Deployment in $Response.content) {
                            CalculateOutput $Deployment
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
    