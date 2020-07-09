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
    The Fabric ID's that will be updated to this range.

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Update-vRAExternalNetworkIPRange

    .EXAMPLE
    Update-vRAExternalNetworkIPRange -Id 'b1dd48e71d74267559bb930934470' -FabricId 'asdfadsfasd','asdfasdf'

    .EXAMPLE
    Update-vRAExternalNetworkIPRange -Name 'my-fabric-network' -FabricId 'asdfadsfasd','asdfasdf'

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

            $Body = @"
                    {
                        "fabricNetworkId": "$($FabricId)"
                    }
"@

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Network by its id
                'ById' {
                    if ($PSCmdlet.ShouldProcess($Id)){
                    foreach ($networkId in $Id) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl/$networkId" -Body $Body -Method PATCH
                        CalculateOutput
                    }
                }
                    break
                }

                # --- Get Network by its name
                'ByName' {
                    if ($PSCmdlet.ShouldProcess($Name)){
                    foreach ($networkName in $Name) {
                       $network = Get-vRAExternalnetworkIPRange -name $networkName
                       $Response = Invoke-vRARestMethod -URI "$APIUrl/$($network.Id)" -Body $Body -Method PATCH
                       CalculateOutput
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
