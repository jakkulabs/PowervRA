function Get-vRAContentSource {
    <#
        .SYNOPSIS
        Get a vRA Content Source
    
        .DESCRIPTION
        Get a vRA Content Source
    
        .PARAMETER Id
        The ID of the Content Source
    
        .PARAMETER Name
        The Name of the Content Source
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRAContentSource
    
        .EXAMPLE
        Get-vRAContentSource -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRAContentSource -Name 'TestContentSource'
    
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
            $APIUrl = '/content/api/sources'
    
            function CalculateOutput([PSCustomObject]$ContentSource) {
    
                [PSCustomObject] @{
                    Id = $ContentSource.id
                    Name = $ContentSource.name
                    TypeId = $ContentSource.typeId
                    CreatedAt = $ContentSource.createdAt
                    CreatedBy = $ContentSource.createdBy
                    LastUpdatedAt = $ContentSource.lastUpdatedAt
                    LastUpdatedBy = $ContentSource.lastUpdatedBy
                    Config = $ContentSource.config
                    SyncEnabled = $ContentSource.syncEnabled
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Content Source by Id
                    'ById' {
    
                        foreach ($ContentSourceId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($ContentSourceId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($ContentSource in $Response.content) {
                                CalculateOutput $ContentSource
                            }
                        }
    
                        break
                    }
                    # --- Get Content Source by Name
                    'ByName' {
    
                        foreach ($ContentSourceName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($ContentSourceName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($ContentSource in $Response.content) {
                                CalculateOutput $ContentSource
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Content Sources
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($ContentSource in $Response.content) {
                            CalculateOutput $ContentSource
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
    