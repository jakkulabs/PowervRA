function Get-vRAFabricAzureStorageAccount {
    <#
        .SYNOPSIS
        Get a vRA Fabric Azure Storage Accounts
    
        .DESCRIPTION
        Get a vRA Fabric Azure Storage Accounts
    
        .INPUTS
        None
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRAFabricAzureStorageAccounts
    
    #>
    [CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]
    
        Param (
        )
    
        begin {
            $APIUrl = '/iaas/api/fabric-azure-storage-accounts'
    
            function CalculateOutput([PSCustomObject]$FabricAzureStorageAccounts) {

                # Don't have any Azure accounts so not sure what this is supposed to look like, will test later
                # TODO find examples of what these objects look like
    
                [PSCustomObject] @{
                    FabricAzureStorageAccount = $FabricAzureStorageAccounts
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Return all Fabric AWS Volume Types
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($FabricAzureStorageAccounts in $Response.content) {
                            CalculateOutput $FabricAzureStorageAccounts
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
    