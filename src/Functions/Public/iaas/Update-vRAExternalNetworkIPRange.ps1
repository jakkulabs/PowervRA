function Update-vRAExternalNetworkIPRange {
<#
    .SYNOPSIS
    Update the vRA External Network IP Range depending on input

    .DESCRIPTION
    Update the vRA External Network IP Range depending on input, only thing that can be updated is associated fabric at this time.

    .PARAMETER Id
    The ID of the vRA External Network IP Range

    .PARAMETER Name
    The Name of the vRA External Network IP Range

    .PARAMETER FabricId
    The id of the fabric network that this IP range should be associated with.

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Update-vRAExternalNetworkIPRange

    .EXAMPLE
    Update-vRAExternalNetworkIPRange -Id 'b1dd48e71d74267559bb930934470' -FabricId 'MyFabricNetworkId'

    .EXAMPLE
    Update-vRAExternalNetworkIPRange -Name 'my-external-network-name' -FabricId 'MyFabricNetworkId'

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [String]$FabricId

    )
    Begin {

        $APIUrl = "/iaas/api/external-network-ip-ranges"

        function CalculateOutput([PSCustomObject] $ExternalNetworkIPRange) {

            [PSCustomObject] @{
                Owner = $ExternalNetworkIPRange.owner
                Description = $ExternalNetworkIPRange.description
                Tags = $ExternalNetworkIPRange.tags
                ExternalId = $ExternalNetworkIPRange.externalId
                SubnetPrefixLength = $ExternalNetworkIPRange.subnetPrefixLength
                Name = $ExternalNetworkIPRange.name
                Id = $ExternalNetworkIPRange.id
                CreatedAt = $ExternalNetworkIPRange.createdAt
                UpdatedAt = $ExternalNetworkIPRange.updatedAt
                OrganizationId = $ExternalNetworkIPRange.orgId
                StartIPAddress = $ExternalNetworkIPRange.startIPAddress
                EndIPAddress = $ExternalNetworkIPRange.endIPAddress
                IPVersion = $ExternalNetworkIPRange.ipVersion
                AddressSpaceId = $ExternalNetworkIPRange.addressSpaceId
                DNSServerAddresses = $ExternalNetworkIPRange.dnsServerAddresses
                DNSSearchDomains = $ExternalNetworkIPRange.dnsSearchDomains
                Domain = $ExternalNetworkIPRange.domain
                GatewayAddress = $ExternalNetworkIPRange.gatewayAddress
                Links = $ExternalNetworkIPRange._links
            }
        }
    }
    Process {

        try {

            $Body = @"
                    {
                        "fabricNetworkId": "$($FabricId)"
                    }
"@

            switch ($PsCmdlet.ParameterSetName) {

                # --- Process by its id
                'ById' {
                    if ($PSCmdlet.ShouldProcess($Id)){
                    foreach ($networkId in $Id) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl/$networkId" -Body $Body -Method PATCH
                        CalculateOutput $Response
                    }
                }
                    break
                }

                # --- Process by its name
                'ByName' {
                    if ($PSCmdlet.ShouldProcess($Name)){
                    foreach ($networkName in $Name) {
                       $network = Get-vRAExternalNetworkIPRange -name $networkName
                       $Response = Invoke-vRARestMethod -URI "$APIUrl/$($network.Id)" -Body $Body -Method PATCH
                       CalculateOutput $Response
                    }
                }
                    break
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
