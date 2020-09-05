function Get-vRATag {
    <#
        .SYNOPSIS
        Get all vRA Tags
    
        .DESCRIPTION
        Get all vRA Tags
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRATag
    
    #>
    [CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]
    
        Param (
        )
    
        begin {
            $APIUrl = '/iaas/api/tags'
    
            function CalculateOutput([PSCustomObject]$Tag) {
    
                [PSCustomObject] @{
                    Key = $Tag.key
                    Value = $Tag.value
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
                    # --- No parameters passed so return all Tags
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($Tag in $Response.content) {
                            CalculateOutput $Tag
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
    