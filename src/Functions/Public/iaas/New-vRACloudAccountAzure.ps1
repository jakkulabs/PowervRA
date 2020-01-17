function New-vRACloudAccountAzure {
<#
    .SYNOPSIS
    Create a vRA Cloud Account for Azure

    .DESCRIPTION
    Create a vRA Cloud Account for Azure

    .PARAMETER Name
    The name of the service

    .PARAMETER Description
    A description of the service

    .PARAMETER SubscriptionId
    Azure Tenantid

    .PARAMETER TenantId
    Azure Tenantid

    .PARAMETER ClientApplicationId
    Azure ClientApplicationId

    .PARAMETER ClientApplicationSecretKey
    Azure ClientApplicationSecretKey

    .PARAMETER RegionIds
    Azure RegionIds to enable

    .PARAMETER CreateDefaultZones
    Azure RegionIds to enable

    .PARAMETER JSON
    A json string with the body payload

    .INPUTS
    System.String
    System.Switch

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRACloudAccountAzure -Name "Azure Test" -SubscriptionId "7326edb0-1234-012e-22d8-76f9faf6982" -TenantId "e7c5cdf4-21d1-312e-bddb-8765949cfdab" -ClientApplicationId "123e710b-4e10-33dc-b9b2-de3d9b1fe234" -ClientApplicationSecretKey "X9Y;bYRpe:eds-TY[blCB1he6PmarC1W" -RegionIds "northeurope","japaneast"

    .EXAMPLE
    $JSON = @"

        {
            "name": "Azure Test",
            "description": "Azure Test",
            "subscriptionId": "7326edb0-1234-012e-22d8-76f9faf6982",
            "tenantId": "e7c5cdf4-21d1-312e-bddb-8765949cfdab",
            "clientApplicationId": "123e710b-4e10-33dc-b9b2-de3d9b1fe234",
            "clientApplicationSecretKey": "X8Y:bYRpe:wzW-FC[blCB1he7PmarC0W",
            "regionIds": [ "northeurope","japaneast" ],
            "createDefaultZones": false
        }
"@

    $JSON | New-vRACloudAccountAzure


#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$SubscriptionId,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$TenantId,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$ClientApplicationId,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$ClientApplicationSecretKey,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$RegionIds,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [Switch]$CreateDefaultZones,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

    )

    Begin {
        if ($PSBoundParameters.ContainsKey("CreateDefaultZones")) {

            $CreateDefaultZonesStatus = 'true'
        }
        else {

            $CreateDefaultZonesStatus = 'true'
        }
    }

    Process {

            if ($PSBoundParameters.ContainsKey("JSON")) {

                $Data = ($JSON | ConvertFrom-Json)

                $Body = $JSON
                $Name = $Data.name
            }
            else {

                # Format RegionIds with surrounding quotes and join into single string
                $RegionIdsAddQuotes = $RegionIDs | ForEach-Object {"`"$_`""}
                $RegionIdsFormatForBodyText = $RegionIdsAddQuotes -join ","

                $Body = @"
                    {
                        "name": "$($Name)",
                        "description": "$($Description)",
                        "subscriptionId": "$($SubscriptionId)",
                        "tenantId": "$($TenantId)",
                        "clientApplicationId": "$($ClientApplicationId)",
                        "clientApplicationSecretKey": "$($ClientApplicationSecretKey)",
                        "regionIds": [ $($RegionIdsFormatForBodyText) ],
                        "createDefaultZones": $($CreateDefaultZonesStatus)
                    }
"@

$Body

                # --- If certain parameters are specified, ConvertFrom-Json, update, then ConvertTo-Json
                # if ($PSBoundParameters.ContainsKey("Owner") -or $PSBoundParameters.ContainsKey("SupportTeam") -or $PSBoundParameters.ContainsKey("IconId")){

                #     $Object = $Body | ConvertFrom-Json

                #     # --- Add owner catalogPrincipal
                #     if ($PSBoundParameters.ContainsKey("Owner")) {

                #         Write-Verbose -Message "Adding owner principal: $($Owner)"

                #         $CatalogPrincipal = Get-vRACatalogPrincipal -Id $Owner

                #         $Object | Add-Member -MemberType NoteProperty -Name "owner" -Value $CatalogPrincipal

                #     }

                #     # --- Add supportTeam catalogPrincipal
                #     if ($PSBoundParameters.ContainsKey("SupportTeam")) {

                #         Write-Verbose -Message "Adding support team principal: $($SupportTeam)"

                #         $CatalogPrincipal = Get-vRACatalogPrincipal -Id $SupportTeam

                #         $Object | Add-Member -MemberType NoteProperty -Name "supportTeam" -Value $CatalogPrincipal

                #     }

                #     if ($PSBoundParameters.ContainsKey("IconId")) {

                #         Write-Verbose -Message "Setting IconId: $($IconId)"

                #         $Object.iconId = $IconId

                #     }

                #     $Body = $Object | ConvertTo-Json -Compress

                # }

            }

        # --- Create new service
        try {
            if ($PSCmdlet.ShouldProcess($Name)){

                # --- Build the URI string for the service

                $URI = "/iaas/api/cloud-accounts-azure"

                $CloudAccount = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference

                [PSCustomObject] @{

                    Name = $CloudAccount.name
                    Description = $CloudAccount.description
                    Id = $CloudAccount.id
                    CloudAccountType = 'azure'
                    SubscriptionId = $CloudAccount.subscriptionId
                    TenantId = $CloudAccount.tenantId
                    ClientApplicationId = $CloudAccount.clientApplicationId
                    EnabledRegionIds = $CloudAccount.enabledRegionIds
                    CustomProperties = $CloudAccount.customProperties
                    OrganizationId = $CloudAccount.organizationId
                    Links = $CloudAccount._links
                }
            }
        }
        catch [Exception] {

            throw
        }
    }

    End {

    }
}