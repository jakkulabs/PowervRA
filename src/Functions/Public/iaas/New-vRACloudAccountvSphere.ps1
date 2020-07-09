function New-vRACloudAccountvSphere {
    <#
        .SYNOPSIS
        Create a vRA Cloud Account for vSphere

        .DESCRIPTION
        Create a vRA Cloud Account for vSphere

        .PARAMETER Name
        The name of the Cloud Account for vSphere

        .PARAMETER Description
        A description of the Cloud Account for vSphere

        .PARAMETER HostName
        vSphere hostname in which this cloud account is created from

        .PARAMETER Username
        Username to use when connecting to the vSphere host

        .PARAMETER Password
        Password to use when connecting to the vSphere host

        .PARAMETER Credential
        Credential object to connect to the vSphere host with
        For domain accounts ensure to specify the Username in the format username@domain, not Domain\Username

        .PARAMETER DCId
        Optional - Identifier of a data collector vm deployed in the on-prem infrastructure

        .PARAMETER AssociatedCloudAccountIds
        Optional - Any associated cloud accounts you would like to build into

        .PARAMETER RegionIds
        Optional - vSphere RegionIds to enable (note: if not supplied, all regions available will be added to the cloud account)

        .PARAMETER CreateDefaultZones
        Enable CreateDefaultZones

        .PARAMETER AcceptSelfSignedCertificate
        If set, a self-signed certificate will be accepted

        .PARAMETER JSON
        A JSON string with the body payload

        .INPUTS
        System.String
        System.Switch

        .OUTPUTS
        System.Management.Automation.PSObject

        .EXAMPLE
        New-vRACloudAccountvSphere -Name "vSphere Test" -HostName "vc.mycompany.com" -Username "administrator@mycompany.com" -Password ("cndhjslacd90ascdbasyoucbdh" | ConvertTo-SecureString -AsPlainText -Force) -RegionIds "Datacenter:datacenter-2" -CreateDefaultZones -AcceptSelfSignedCertificate

        .EXAMPLE
        New-vRACloudAccountvSphere -Name "vSphere Test" -HostName "vc.mycompany.com" -Credential (get-credential)  -CreateDefaultZones -AcceptSelfSignedCertificate

        .EXAMPLE
        $JSON = @"

            {
                "hostName": "vc.mycompany.com",
                "acceptSelfSignedCertificate": false,
                "associatedCloudAccountIds": "[ "42f3e0d199d134755684cd935435a" ]",
                "password": "cndhjslacd90ascdbasyoucbdh",
                "createDefaultZones": true,
                "dcid": "23959a1e-18bc-4f0c-ac49-b5aeb4b6eef4",
                "name": "string",
                "description": "string",
                "regionIds": "[ "Datacenter:datacenter-2" ]",
                "username": "administrator@mycompany.com"
            }

"@

        $JSON | New-vRACloudAccountvSphere


    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Low", DefaultParameterSetName = "Username")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory = $false, ParameterSetName = "Username")]
        [Parameter(Mandatory = $false, ParameterSetName = "Credential")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory = $false, ParameterSetName = "Username")]
        [Parameter(Mandatory = $false, ParameterSetName = "Credential")]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory = $false, ParameterSetName = "Username")]
        [Parameter(Mandatory = $false, ParameterSetName = "Credential")]
        [ValidateNotNullOrEmpty()]
        [String]$HostName,

        [Parameter(Mandatory = $true, ParameterSetName = "Username")]
        [ValidateNotNullOrEmpty()]
        [String]$Username,

        [Parameter(Mandatory = $true, ParameterSetName = "Username")]
        [ValidateNotNullOrEmpty()]
        [SecureString]$Password,

        [Parameter(Mandatory=$true,ParameterSetName="Credential")]
        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory = $false, ParameterSetName = "Username")]
        [Parameter(Mandatory = $false, ParameterSetName = "Credential")]
        [ValidateNotNullOrEmpty()]
        [String]$DCId,

        [Parameter(Mandatory = $false, ParameterSetName = "Username")]
        [Parameter(Mandatory = $false, ParameterSetName = "Credential")]
        [ValidateNotNullOrEmpty()]
        [String[]]$AssociatedCloudAccountIds,

        [Parameter(Mandatory = $false, ParameterSetName = "Username")]
        [Parameter(Mandatory = $false, ParameterSetName = "Credential")]
        [ValidateNotNullOrEmpty()]
        [String[]]$RegionIds,

        [Parameter(Mandatory = $false, ParameterSetName = "Username")]
        [Parameter(Mandatory = $false, ParameterSetName = "Credential")]
        [Switch]$CreateDefaultZones,

        [Parameter(Mandatory = $false, ParameterSetName = "Username")]
        [Parameter(Mandatory = $false, ParameterSetName = "Credential")]
        [Switch]$AcceptSelfSignedCertificate,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

    )

    begin {

        $APIUrl = "/iaas/api/cloud-accounts-vsphere"

        if ($CreateDefaultZones.IsPresent) {

            $CreateDefaultZonesStatus = 'true'
        }
        else {

            $CreateDefaultZonesStatus = 'false'
        }

        if ($AcceptSelfSignedCertificate.IsPresent) {

            $AcceptSelfSignedCertificateStatus = 'true'
        }
        else {

            $AcceptSelfSignedCertificateStatus = 'false'
        }

        # --- Convert Secure Credentials to a format for sending in the JSON payload
        if ($PSBoundParameters.ContainsKey("Credential")){

            $Username = $Credential.UserName
            $JSONPassword = $Credential.GetNetworkCredential().Password
        }

        if ($PSBoundParameters.ContainsKey("Password")){

            $JSONPassword = (New-Object System.Management.Automation.PSCredential("username", $Password)).GetNetworkCredential().Password
        }
        function CalculateOutput([PSCustomObject]$CloudAccount) {
            [PSCustomObject] @{
                Name                = $CloudAccount.name
                HostName            = $CloudAccount.HostName
                Username            = $CloudAccount.username
                Description         = $CloudAccount.description
                Id                  = $CloudAccount.id
                CloudAccountType    = 'vsphere'
                EnabledRegionIds    = $CloudAccount.enabledRegionIds
                CustomProperties    = $CloudAccount.customProperties
                OrganizationId      = $CloudAccount.organizationId
                Links               = $CloudAccount._links
            }
        }
    }

    process {
        # --- Create new Azure Cloud Account
        try {
            if ($PSBoundParameters.ContainsKey("JSON")) {

                $Data = ($JSON | ConvertFrom-Json)
                $Body = $JSON
                # have to handle if regionid's were not provided
                if ($null -eq $Data.regionIds) {
                    # region ids were not natively passed
                    $RegionIdProcessing = ProcessReqionIds
                    $Data | Add-Member -NotePropertyName regionIds -NotePropertyValue $RegionIdProcessing -Force
                    $JSON = $Data | ConvertTo-Json
                    Write-Verbose $JSON
                }
                $Body = $JSON
                $Name = $Data.name
            }
            else {

                # Format AssociatedCloudAccountIds with surrounding quotes and join into single string
                $AssociatedCloudAccountIdsAddQuotes = $AssociatedCloudAccountIds | ForEach-Object { "`"$_`"" }
                $AssociatedCloudAccountIdsFormatForBodyText = $AssociatedCloudAccountIdsAddQuotes -join ","

                if ($null -eq $RegionIds) {
                    # process to see if regions were given, if not, we pull all of them
                    if ($PSBoundParameters.ContainsKey("Credential")){
                        $RegionIDs = Get-vRARegionEnumerationvSphere -HostName $HostName  -Credential $Credential -AcceptSelfSignedCertificate:$($AcceptSelfSignedCertificate)
                    } else {
                        # assume username and password
                        $RegionIDs = Get-vRARegionEnumerationvSphere -HostName $HostName  -Username $Username -Password $Password -AcceptSelfSignedCertificate:$($AcceptSelfSignedCertificate)
                    }
                }

                # Format RegionIds with surrounding quotes and join into single string
                $RegionIdsAddQuotes = $RegionIDs | ForEach-Object { "`"$_`"" }
                $RegionIdsFormatForBodyText = $RegionIdsAddQuotes -join ","

                $Body = @"
                            {
                                "hostName": "$($HostName)",
                                "acceptSelfSignedCertificate": $($AcceptSelfSignedCertificateStatus),
                                "associatedCloudAccountIds": [ $($AssociatedCloudAccountIdsFormatForBodyText) ],
                                "password": "$($JSONPassword)",
                                "createDefaultZones": $($CreateDefaultZonesStatus),
                                "dcid": "$($DCId)",
                                "name": "$($Name)",
                                "description": "$($Description)",
                                "regionIds": [ $($RegionIdsFormatForBodyText) ],
                                "username": "$($Username)"
                            }
"@
            }


            if ($PSCmdlet.ShouldProcess($Name)) {

                $CloudAccount = Invoke-vRARestMethod -Method POST -URI $APIUrl -Body $Body -Verbose:$VerbosePreference

                CalculateOutput $CloudAccount
            }
        }
        catch [Exception] {

            throw
        }
    }
    end {

    }
}
