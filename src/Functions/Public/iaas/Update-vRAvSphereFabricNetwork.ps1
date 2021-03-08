function Update-vRAvSphereFabricNetwork {
<#
    .SYNOPSIS
    Update the vRA External Network IP Range depending on input

    .DESCRIPTION
    Update the vRA External Network IP Range depending on input, only thing that can be updated is associated fabric at this time.

    .PARAMETER Id
    The ID of the vRA External Network IP Range

    .PARAMETER Name
    The Name of the vRA External Network IP Range

    .PARAMETER Ipv6Cidr
    Network IPv6 CIDR to be used

    .PARAMETER IsDefault
    Indicates whether this is the default subnet for the zone.

    .PARAMETER Domain
    Domain value.
    
    .PARAMETER DefaultIpv6Gateway
    IPv6 default gateway to be used.

    .PARAMETER DnsServerAddresses
    A list of DNS server addresses that were set on this resource instance.

    .PARAMETER IsPublic
    Indicates whether the sub-network supports public IP assignment.

    .PARAMETER Cidr
    Network CIDR to be used.

    .PARAMETER DefaultGateway
    IPv4 default gateway to be used.

    .PARAMETER Tags
    A set of tag keys and optional values that were set on this resource instance.

    .PARAMETER DnsSearchDomains
    A list of DNS search domains that were set on this resource instance.

    .PARAMETER CloudAccountName
    The name of the vRA Cloud account to search for (optional)

    .PARAMETER CloudAccountId
    The ID of the vRA Cloud Account to search for (optional)
    
    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Update-vRAvSphereFabricNetwork

    .EXAMPLE
    Update-vRAvSphereFabricNetwork -Id 'b1dd48e71d74267559bb930934470' -DefaultGateway '1.1.1.1'

    .EXAMPLE
    Update-vRAvSphereFabricNetwork -Name 'my-fabric-network' -DefaultGateway '1.1.1.1'

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'CloudAccountName',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'CloudAccountId',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Ipv6Cidr',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'IsDefault',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Domain',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'DefaultIpv6Gateway',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'DnsServerAddresses',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'IsPublic',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Cidr',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'DefaultGateway',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Tags',Justification = 'False positive as rule does not scan child scopes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'DnsSearchDomains',Justification = 'False positive as rule does not scan child scopes')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [String]$Ipv6Cidr,

        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [bool]$IsDefault,

        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [String]$Domain,

        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [String]$DefaultIpv6Gateway,

        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [String[]]$DnsServerAddresses,

        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [bool]$IsPublic,

        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [String]$Cidr,

        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [String]$DefaultGateway,

        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [String[]]$Tags,

        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [String[]]$DnsSearchDomains,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]]$CloudAccountName,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]]$CloudAccountId



    )
    Begin {

        $APIUrl = "/iaas/api/fabric-networks-vsphere"

        function CalculateOutput {

            if ($Response.PSObject.Properties.name -match "content") {
                foreach ($Record in $Response.content) {
                    
                    [PSCustomObject]@{
                        DefaultGateway = $Record.defaultGateway
                        IsPublic = $Record.isPublic
                        IsDefault = $Record.isDefault
                        ExternalRegionId = $Record.externalRegionId
                        CloudAccountIds = $Record.cloudAccountIds
                        ExternalId = $Record.externalId
                        Name = $Record.name
                        Id = $Record.id
                        CreatedAt = $Record.createdAt
                        UpdatedAt = $Record.updatedAt
                        OrganizationId = $Record.organizationId
                        OrgId = $Record.orgId
                        Links = $Record._links
                    }
                }
            } else {
                [PSCustomObject]@{
                    DefaultGateway = $Response.defaultGateway
                    IsPublic = $Response.isPublic
                    IsDefault = $Response.isDefault
                    ExternalRegionId = $Response.externalRegionId
                    CloudAccountIds = $Response.cloudAccountIds
                    ExternalId = $Response.externalId
                    Name = $Response.name
                    Id = $Response.id
                    CreatedAt = $Response.createdAt
                    UpdatedAt = $Response.updatedAt
                    OrganizationId = $Response.organizationId
                    OrgId = $Response.orgId
                    Links = $Response._links
                }
            }
            
        }

        function buildUpdateBody() {
            $DnsServerAddressesJson = ($DnsServerAddresses | ForEach-Object {"`"$_`""}) -join ","
            $DnsSearchDomainsJson = ($DnsSearchDomains | ForEach-Object {"`"$_`""}) -join ","
            if($DnsServerAddressesJson -eq "`"`"") {
                $DnsServerAddressesJson = $null
            }
            if($DnsSearchDomainsJson -eq "`"`"") {
                $DnsSearchDomainsJson = $null
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

            # handle items that may not have been supplied but exist already on object
            # we keep that value just in case so that is not inadvertantly wiped out
            if ($CurrentRecord.PSObject.Properties.name -match "content") {
                $CurrentRecord = $CurrentRecord[0]
            }

            if ($null -eq $Ipv6Cidr) {
                $Ipv6Cidr = $CurrentRecord.ipv6Cidr
            }
            if ($null -eq $IsDefault) {
                $IsDefault = $CurrentRecord.isDefault
            }
            if ($null -eq $IsPublic) {
                $IsPublic = $CurrentRecord.isPublic
            }
            if ($null -eq $Cidr) {
                $Cidr = $CurrentRecord.cidr
            }

            # # handle tags diff
            # if ($null -eq $Ipv6Cidr) {
            #     $Ipv6Cidr = $CurrentRecord.content[0].ipv6Cidr
            # }

            $Body = @"
                {
                    "ipv6Cidr": "$($ipv6)",
                    "isDefault": $($isDefault | ConvertTo-Json),
                    "domain": "$($Domain)",
                    "defaultIpv6Gateway": "$($DefaultIpv6Gateway)",
                    "dnsServerAddresses": [ $($DnsServerAddressesJson) ],
                    "isPublic": $($IsPublic | ConvertTo-Json),
                    "cidr": "$($Cidr)",
                    "defaultGateway": "$($DefaultGateway)",
                    "tags": $($TagsJson),
                    "dnsSearchDomains": [ $($DnsSearchDomainsJson) ]
                }
"@
            $JSONObject = $Body | ConvertFrom-Json
            $Body = $JSONObject | ConvertTo-Json -Depth 5

            return $Body
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
            if ($accountIdString -ne '') {
                return "cloudAccountIds.item any $($accountIdString.substring(1))"
            } else {
                return ""
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
                        $CurrentRecord = Invoke-vRARestMethod -URI "$APIUrl/$networkId" -Method GET

                        # build the body of the update request
                        $Body = buildUpdateBody

                        # send the udpate request
                        $Response = Invoke-vRARestMethod -URI "$APIUrl/$($CurrentRecord.Id)" -Body $Body -Method PATCH

                        CalculateOutput
                    }
                }
                    break
                }

                # --- Get Network by its name
                'ByName' {
                    if ($PSCmdlet.ShouldProcess($Name)){
                    $acctQuery = buildAccountQuery
                    foreach ($networkName in $Name) {
                        if ($null -ne $acctQuery -and '' -ne $acctQuery) {
                            $CurrentRecord = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$networkName' and $acctQuery" -Method GET
                        } else {
                            $CurrentRecord = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$networkName'" -Method GET
                        }
                        
                        # build the body of the update request
                        $Body = buildUpdateBody

                        # send the udpate request
                        $Response = Invoke-vRARestMethod -URI "$APIUrl/$($CurrentRecord.Id)" -Body $Body -Method PATCH
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
