function Get-vRACloudAccount {
<#
    .SYNOPSIS
    Get a vRA Cloud Account.

    .DESCRIPTION
    Get a vRA Cloud Account.

    .PARAMETER Id
    The id of the Cloud Account

    .PARAMETER Name
    The name of the Cloud Account

    .PARAMETER Type
    Cloud Account Type, e.g. vSphere, Azure, AWS, GCP etc

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRACloudAccount

    .EXAMPLE
    Get-vRACloudAccount -Id d6f8b87ba95ab675597c97eefdd9c

    .EXAMPLE
    Get-vRACloudAccount -Name vSphere_test

    .EXAMPLE
    Get-vRACloudAccount -Type vSphere

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [Parameter(Mandatory=$false)]
        [ValidateSet('azure','aws','gcp','nsx-t','nsx-v','vmc','vsphere')]
        [String]$Type
    )

    Begin {
        $APIUrl = '/iaas/api/cloud-accounts'

        if ($PSBoundParameters.ContainsKey('Type')){

            $APIUrl = $APIUrl + "-$Type"
        }

        function CalculateOutput([PSCustomObject]$CloudAccount, [String]$Type) {

            if ($null -ne $Type){

                $CloudAccountType = $Type
            }
            else {

                $CloudAccountType = $CloudAccount.cloudAccountType
            }

            [PSCustomObject] @{

                Name = $CloudAccount.name
                Description = $CloudAccount.description
                Id = $CloudAccount.id
                CloudAccountType = $CloudAccountType
                EnabledRegionIds = $CloudAccount.enabledRegionIds
                CustomProperties = $CloudAccount.customProperties
                OrganizationId = $CloudAccount.organizationId
                Links = $CloudAccount._links
            }
        }
    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Cloud Account by id
                'ById' {

                    foreach ($CloudAccountId in $Id) {

                        $URI = "$APIUrl/$($CloudAccountId)"

                        $CloudAccount = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        CalculateOutput $CloudAccount $Type
                    }

                    break
                }
                # --- Get Cloud Account by name
                'ByName' {

                    $URI = $APIUrl

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    foreach ($CloudAccountName in $Name) {

                        $CloudAccount = $Response.content | Where-Object {$_.name -eq $CloudAccountName}

                        if (!$CloudAccount) {

                            throw "Could not find Cloud Account with name: $($CloudAccountName)"

                        }

                        CalculateOutput $CloudAccount $Type
                    }

                    break
                }
                # --- No parameters passed so return all Cloud Accounts
                'Standard' {

                    $URI = $APIUrl

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    foreach ($CloudAccount in $Response.content) {

                        CalculateOutput $CloudAccount $Type
                    }
                }
            }
        }
        catch [Exception]{

            throw
        }
    }

    End {

    }
}
