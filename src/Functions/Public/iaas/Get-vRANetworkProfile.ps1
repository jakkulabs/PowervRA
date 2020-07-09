function Get-vRANetworkProfile {
<#
    .SYNOPSIS
    Retrieve vRA Network Profile(s) depending on input

    .DESCRIPTION
    Retrieve a list of vRA Network Profiles or a single network profile depending on input

    .PARAMETER Id
    The ID of the vRA Network Profile

    .PARAMETER Name
    The Name of the vRA Network Profile

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRANetworkProfile

    .EXAMPLE
    Get-vRANetworkProfile -Id 'b1dd48e71d74267559bb930934470'

    .EXAMPLE
    Get-vRANetworkProfile -Name 'my-porgroup'

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
    Begin {

        $APIUrl = "/iaas/api/network-profiles"

        function CalculateOutput {

            foreach ($Record in $Response.content) {
                [PSCustomObject]@{
                    Owner = $Record.owner
                    Links = $Record._links
                    ExternalRegionId = $Record.externalRegionId
                    Description = $Record.description
                    IsolationNetworkDomainCIDR = $Record.isolationNetworkDomainCIDR
                    OrgId = $Record.orgId
                    Tags = $Record.tags
                    OrganizationId = $Record.organizationId
                    CreatedAt = $Record.createdAt
                    CustomProperties = $Record.customProperties
                    Name = $Record.name
                    Id = $Record.id
                    IsolationType = $Record.isolationType
                    IsolatedNetworkCIDRPrefix = $Record.isolatedNetworkCIDRPrefix
                    UpdatedAt = $Record.updatedAt
                }
            }
        }
    }
    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Network by its id
                'ById' {
                    foreach ($networkId in $Id) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=id eq '$networkId'" -Method GET
                        CalculateOutput
                    }

                    break
                }

                # --- Get Network by its name
                'ByName' {
                    foreach ($networkName in $Name) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$networkName'" -Method GET
                        CalculateOutput
                    }

                    break
                }

                # --- No parameters passed so return all machines
                'Standard' {
                    $Response = Invoke-vRARestMethod -URI $APIUrl -Method GET
                    CalculateOutput
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
