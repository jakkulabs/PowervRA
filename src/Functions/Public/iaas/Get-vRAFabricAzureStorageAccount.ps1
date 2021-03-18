function Get-vRAFabricAzureStorageAccount {
    <#
        .SYNOPSIS
        Get a vRA Fabric Azure Storage Account

        .DESCRIPTION
        Get a vRA Fabric Azure Storage Account

        .PARAMETER Id
        The ID of the Fabric Azure Storage Account

        .PARAMETER Name
        The Name of the Fabric Azure Storage Account

        .INPUTS
        None

        .OUTPUTS
        System.Management.Automation.PSObject

        .EXAMPLE
        Get-vRAFabricAzureStorageAccounts

        .EXAMPLE
        Get-vRAFabricAzureStorageAccounts -Id 1c3a50ca-1c38-42a3-a572-209d5dfdecf7

        .EXAMPLE
        Get-vRAFabricAzureStorageAccounts -Name "test-Azure-Storage-Account"

    #>
    [CmdletBinding(DefaultParameterSetName = "Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = "ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name
    )

    begin {
        $APIUrl = '/iaas/api/fabric-azure-storage-accounts'

        function CalculateOutput([PSCustomObject]$FabricAzureStorageAccounts) {

            [PSCustomObject] @{

                Type             = $FabricAzureStorageAccounts.type
                ExternalRegionId = $FabricAzureStorageAccounts.externalRegionId
                Name             = $FabricAzureStorageAccounts.name
                Id               = $FabricAzureStorageAccounts.id
                OrganizationId   = $FabricAzureStorageAccounts.organizationId
                CloudAccountIds  = $FabricAzureStorageAccounts.cloudAccountIds
                Links            = $FabricAzureStorageAccounts._links
            }
        }
    }

    process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Cloud Account by id
                'ById' {

                    foreach ($FabricAzureStorageAccountId in $Id) {

                        $URI = "$APIUrl/$($FabricAzureStorageAccountId)"

                        $FabricAzureStorageAccount = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        CalculateOutput $FabricAzureStorageAccount
                    }

                    break
                }
                # --- Get Cloud Account by name
                'ByName' {

                    $URI = $APIUrl

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    foreach ($FabricAzureStorageAccountName in $Name) {

                        $FabricAzureStorageAccounts = $Response.content | Where-Object { $_.name -eq $FabricAzureStorageAccountName }

                        if (!$FabricAzureStorageAccounts) {

                            throw "Could not find Cloud Account with name: $($FabricAzureStorageAccounts)"

                        }

                        CalculateOutput $FabricAzureStorageAccounts
                    }

                    break
                }
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
        catch [Exception] {

            throw
        }
    }

    end {

    }
}
