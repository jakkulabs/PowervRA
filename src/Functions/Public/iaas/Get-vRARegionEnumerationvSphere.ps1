function Get-vRARegionEnumerationvSphere {
    <#
        .SYNOPSIS
        Retrieve the External Regions Ids for vSphere environment given

        .DESCRIPTION
        Retrieve the External Regions Ids for vSphere environment given

        .PARAMETER HostName
        vSphere hostname in which this cloud account is created from

        .PARAMETER Username
        Username to use when connecting to the vSphere host

        .PARAMETER Password
        Password to use when connecting to the vSphere host

        .PARAMETER Credential
        Credential object to connect to the vSphere host with
        For domain accounts ensure to specify the Username in the format username@domain, not Domain\Username

        .PARAMETER AcceptSelfSignedCertificate
        If set, a self-signed certificate will be accepted

        .INPUTS
        System.String
        System.Switch

        .OUTPUTS
        System.Management.Automation.PSObject

        .EXAMPLE
        Get-vRARegionEnumerationvSphere -HostName "vc.mycompany.com" -Username "administrator@mycompany.com" -Password  ("cndhjslacd90ascdbasyoucbdh" | ConvertTo-SecureString -AsPlainText -Force) -AcceptSelfSignedCertificate

        .EXAMPLE
        Get-vRARegionEnumerationvSphere -HostName "vc.mycompany.com" -Credential (get-credential)  -AcceptSelfSignedCertificate

    #>
    [CmdletBinding(DefaultParameterSetName = "Username")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory = $false, ParameterSetName = "Username")]
        [Parameter(Mandatory = $false, ParameterSetName = "Credential")]
        [ValidateNotNullOrEmpty()]
        [String]$HostName,

        [Parameter(Mandatory = $true, ParameterSetName = "Username")]
        [ValidateNotNullOrEmpty()]
        [String]$username,

        [Parameter(Mandatory = $true, ParameterSetName = "Username")]
        [ValidateNotNullOrEmpty()]
        [SecureString]$Password,

        [Parameter(Mandatory=$true,ParameterSetName="Credential")]
        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory = $false, ParameterSetName = "Username")]
        [Parameter(Mandatory = $false, ParameterSetName = "Credential")]
        [Switch]$AcceptSelfSignedCertificate

    )

    begin {

        $APIUrl = "/iaas/api/cloud-accounts-vsphere/region-enumeration"

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

    }

    process {
        # --- Create new Azure Cloud Account
        try {

            $Body = @"
            {
                "hostName": "$($HostName)",
                "acceptSelfSignedCertificate": $($AcceptSelfSignedCertificateStatus),
                "password": "$($JSONPassword)",
                "username": "$($username)"
            }
"@

            $Enumeration = Invoke-vRARestMethod -Method POST -URI $APIUrl -Body $Body -Verbose:$VerbosePreference

            if($null -ne $Enumeration -and $Enumeration.PSObject.Properties.name -match "externalRegionIds") {
                $Enumeration.externalRegionIds
            } else {
                return @()
            }
        }
        catch [Exception] {

            throw
        }
    }
    end {

    }
}
