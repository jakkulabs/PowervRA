function Get-vRAExternalNetworkIPRange {
<#
    .SYNOPSIS
    Retrieve vRA External Network IP Ranges depending on input

    .DESCRIPTION
    Retrieve a list of vRA External Network IP Ranges or a single External Network IP Range depending on input

    .PARAMETER Id
    The ID of the vRA External Network IP Range

    .PARAMETER Name
    The Name of the vRA External Network IP Range

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAExternalNetworkIPRange

    .EXAMPLE
    Get-vRAExternalNetworkIPRange -Id 'b1dd48e71d74267559bb930934470'

    .EXAMPLE
    Get-vRAExternalNetworkIPRange -Name 'my-fabric-network'

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

        $APIUrl = "/iaas/api/external-network-ip-ranges"

        function CalculateOutput {

            foreach ($Record in $Response.content) {
                [PSCustomObject]@{
                    DnsServerAddresses = $Record.dnsServerAddresses
                    Domain = $Record.domain
                    SubnetPrefixLength = $Record.subnetPrefixLength
                    AddressSpaceId = $Record.addressSpaceId
                    StartIPAddress = $Record.startIPAddress
                    EndIPAddress = $Record.endIPAddress
                    IpVersion = $Record.ipVersion
                    Tags = $Record.tags
                    Name = $Record.name
                    Description = $Record.description
                    Id = $Record.id
                    UpdatedAt = $Record.updatedAt
                    OrganizationId = $Record.organizationId
                    OrgId = $Record.orgId
                    Links = $Record._links
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
