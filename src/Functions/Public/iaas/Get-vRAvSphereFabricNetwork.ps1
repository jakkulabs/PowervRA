function Get-vRAvSphereFabricNetwork {
<#
    .SYNOPSIS
    Retrieve vRA vSphere Fabric Network(s) depending on input

    .DESCRIPTION
    Retrieve a list of vRA vSphere Fabric Networks or a single network depending on input

    .PARAMETER Id
    The ID of the vRA vSphere Fabric Network

    .PARAMETER Name
    The Name of the vRA vSphere Fabric Network

    .PARAMETER CloudAccountName
    The name of the vRA Cloud account to search for (optional)

    .PARAMETER CloudAccountId
    The ID of the vRA Cloud Account to search for (optional)

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAvSphereFrabricNetwork

    .EXAMPLE
    Get-vRAvSphereFrabricNetwork -Id 'b1dd48e71d74267559bb930934470'

    .EXAMPLE
    Get-vRAvSphereFrabricNetwork -Name 'my-fabric-network'

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'CloudAccountName',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'CloudAccountId',Justification = 'False positive as rule does not scan child scopes')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]]$CloudAccountName,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]]$CloudAccountId

    )
    Begin {

        $APIUrl = "/iaas/api/fabric-networks-vsphere"

        function CalculateOutput([PSCustomObject]$FabricNetworks) {

            foreach ($FabricNetwork in $FabricNetworks.content) {
                [PSCustomObject]@{
                    ExternalRegionId = $FabricNetwork.externalRegionId
                    DefaultIpv6Gateway = $FabricNetwork.defaultIpv6Gateway
                    Description = $FabricNetwork.description
                    ExternalId = $FabricNetwork.externalId
                    DefaultGateway = $FabricNetwork.defaultGateway
                    OrgId = $FabricNetwork.orgId
                    Tags = $FabricNetwork.tags
                    OrganizationId = $FabricNetwork.organizationId
                    CreatedAt = $FabricNetwork.createdAt
                    Ipv6Cidr = $FabricNetwork.ipv6Cidr
                    CloudAccountIds = $FabricNetwork.cloudAccountIds
                    IsDefault = $FabricNetwork.isDefault
                    Domain = $FabricNetwork.domain
                    DnsServerAddresses = $FabricNetwork.dnsServerAddresses
                    Name = $FabricNetwork.name
                    IsPublic = $FabricNetwork.isPublic
                    Cidr = $FabricNetwork.cidr
                    Id = $FabricNetwork.id
                    UpdatedAt = $FabricNetwork.updatedAt
                    DnsSearchDomains = $FabricNetwork.dnsSearchDomains
                }
            }
        }

        function buildAccountQuery() {
            $accountIdString = ''
            $cloudAccountIds = @()

            if ($null -ne $CloudAccountName -and "" -ne $CloudAccountName) {
                # pull the ID's from each cloud account
                $cloudAccountIds = Get-vRACloudAccount -Name $CloudAccountName | Select-Object Id | ForEach-Object { $_.Id }
            }
            if ($null -ne $CloudAccountId) {
                $cloudAccountIds = $cloudAccountIds + @($CloudAccountId)
            }
            foreach ($id in $cloudAccountIds) {
                $accountIdString = $accountIdString + ",'$id'"
            }
            Write-Verbose $accountIdString
            if ($accountIdString -ne '') {
                return "cloudAccountIds.item any $($accountIdString.substring(1))"
            } else {
                return ""
            }
        }
    }
    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Network by its id
                'ById' {
                    foreach ($networkId in $Id) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=id eq '$networkId'`&`$top=1000" -Method GET
                        CalculateOutput $Response
                    }

                    break
                }

                # --- Get Network by its name
                'ByName' {
                    $acctQuery = buildAccountQuery
                    foreach ($networkName in $Name) {
                        if ($null -ne $acctQuery -and '' -ne $acctQuery) {
                            $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$networkName' and $acctQuery`&`$top=1000" -Method GET
                        } else {
                            $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$networkName'`&`$top=1000" -Method GET
                        }
                        CalculateOutput $Response
                    }

                    break
                }

                # --- No parameters passed so return all networks
                'Standard' {
                    $acctQuery = buildAccountQuery
                    if ($null -ne $acctQuery -and '' -ne $acctQuery) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=$acctQuery`&`$top=1000" -Method GET
                        CalculateOutput $Response
                    } else {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$top=1000" -Method GET
                        CalculateOutput $Response
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
