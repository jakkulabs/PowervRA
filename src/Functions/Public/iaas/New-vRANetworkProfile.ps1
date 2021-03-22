function New-vRANetworkProfile {
<#
    .SYNOPSIS
    Create a vRA Network Profile

    .DESCRIPTION
    Create a vRA Network Profile

    .PARAMETER Name
    The name of the Network Profile

    .PARAMETER Description
    A description of the Network Profile

    .PARAMETER Description
    A description of the network profile

    .PARAMETER IsolationNetworkDomainCIDR
    CIDR of the isolation network domain

    .PARAMETER IsolationNetworkDomainId
    The Id of the network domain used for creating isolated networks.

    .PARAMETER FabricNetworkIds
    Id's of the Fabric networks you would like to associate with this profile

    .PARAMETER RegionId
    The Id of the region for which this profile is created

    .PARAMETER SecurityGroupIds
    A list of security group Ids which are assigned to the network profile

    .PARAMETER Name
    A human-friendly name used as an identifier in APIs that support this option.

    .PARAMETER IsolationExternalFabricNetworkId
    The Id of the fabric network used for outbound access.

    .PARAMETER IsolationType
    Specifies the isolation type e.g. none, subnet or security group

    .PARAMETER IsolatedNetworkCIDRPrefix
    The CIDR prefix length to be used for the isolated networks that are created with the network profile.

    .PARAMETER LoadBalancerIds
    A list of load balancers which are assigned to the network profile.

    .PARAMETER Tags
    A array of tags to tag the created network profile with

    .PARAMETER JSON
    A JSON string with the body payload

    .INPUTS
    System.String
    System.Switch
    PSCustomObject

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    $ProfileArguments = @{

        Name = 'My Profile'
        Description = 'Test Profile'
        RegionId = '9e49'
        fabricNetworkIds = '6543','6542'
        Tags = 'placement:coems','mytag2:2'
    }

    New-vRANetworkProfile @ProfileArguments

    .EXAMPLE
    $JSON = @"
       {
        "description": "string",
        "isolationNetworkDomainCIDR": "10.10.10.0/24",
        "isolationNetworkDomainId": "1234",
        "fabricNetworkIds": "[ \"6543\" ]",
        "regionId": "9e49",
        "securityGroupIds": "[ \"6545\" ]",
        "name": "string",
        "isolationExternalFabricNetworkId": "1234",
        "isolationType": "SUBNET",
        "isolatedNetworkCIDRPrefix": 24,
        "loadBalancerIds": "[ \"6545\" ]",
        "Tags": [ "placement:coems", "mytag2:2"]
        }
"@

    $JSON | New-vRANetworkProfile
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$IsolationNetworkDomainCIDR,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$IsolationNetworkDomainId,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$FabricNetworkIds,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$RegionId,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$SecurityGroupIds,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$IsolationExternalFabricNetworkId,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$IsolationType,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [int]$IsolatedNetworkCIDRPrefix,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$LoadBalancerIds,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Tags,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

    )

    begin {
        function CalculateOutput([PSCustomObject]$NetworkProfile) {

            [PSCustomObject] @{

                Owner = $NetworkProfile.owner
                Links = $NetworkProfile._links
                ExternalRegionId = $NetworkProfile.externalRegionId
                Description = $NetworkProfile.description
                IsolationNetworkDomainCIDR = $NetworkProfile.isolationNetworkDomainCIDR
                OrgId = $NetworkProfile.orgId
                Tags = $NetworkProfile.tags
                OrganizationId = $NetworkProfile.organizationId
                CreatedAt = $NetworkProfile.createdAt
                CustomProperties = $NetworkProfile.customProperties
                Name = $NetworkProfile.name
                Id = $NetworkProfile.id
                IsolationType = $NetworkProfile.isolationType
                IsolatedNetworkCIDRPrefix = $NetworkProfile.isolatedNetworkCIDRPrefix
                UpdatedAt = $NetworkProfile.updatedAt

        }
    }
}

    process {

            if ($PSBoundParameters.ContainsKey("JSON")) {

                $Data = ($JSON | ConvertFrom-Json)

                $Body = $JSON
                $Name = $Data.name
            }
            else {

                $FabricNetworkIdJson = ($FabricNetworkIds | ForEach-Object {"`"$_`""}) -join ","
                $SecurityGroupIdJson = ($SecurityGroupIds | ForEach-Object {"`"$_`""}) -join ","
                $LoadBalancerIdJson = ($LoadBalancerIds | ForEach-Object {"`"$_`""}) -join ","
                if($FabricNetworkIdJson -eq "`"`"") {
                    $FabricNetworkIdJson = $null
                }
                if($SecurityGroupIdJson -eq "`"`"") {
                    $SecurityGroupIdJson = $null
                }
                if($LoadBalancerIdJson -eq "`"`"") {
                    $LoadBalancerIdJson = $null
                }

                # handle Tags
                $TagsJson = "null"
                if ($null -ne $Tags) {
                    $TagsJson = ($Tags | ForEach-Object { 
                        $TagSplit = $_.Split(":")
                        [PSCustomObject]@{
                            key = $TagSplit[0]
                            value = $TagSplit[1]
                        }   
                    }) | ConvertTo-Json -Depth 5 -Compress
                }
                

                $Body = @"
                    {
                        "name": "$($Name)",
                        "description": "$($Description)",
                        "isolationNetworkDomainCIDR": "$($IsolationNetworkDomainCIDR)",
                        "isolationNetworkDomainId": "$($IsolationNetworkDomainId)",
                        "fabricNetworkIds": [ $($FabricNetworkIdJson) ],
                        "regionId": "$($RegionId)",
                        "securityGroupIds": [ $($SecurityGroupIdJson) ],
                        "isolationExternalFabricNetworkId": "$($IsolationExternalFabricNetworkId)",
                        "isolationType": "$($IsolationType)",
                        "loadBalancerIds": [ $($LoadBalancerIdJson) ],
                        "tags": [$($TagsJson)]
                    }
"@
                Write-Verbose $Body
                $JSONObject = $Body | ConvertFrom-Json

                if ($IsolatedNetworkCIDRPrefix -gt 0) {
                    $JSONObject | Add-Member -NotePropertyName isolatedNetworkCIDRPrefix -NotePropertyValue $IsolatedNetworkCIDRPrefix
                }

                $Body = $JSONObject | ConvertTo-Json -Depth 5
            }

        # --- Create new Network Profile
        try {
            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/iaas/api/network-profiles"
                $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference
                CalculateOutput $Response
                
            }
        }
        catch [Exception] {

            throw
        }
    }
    end {

    }
}