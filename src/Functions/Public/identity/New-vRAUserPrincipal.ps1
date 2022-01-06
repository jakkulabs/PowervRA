﻿function New-vRAUserPrincipal {
<#
    .SYNOPSIS
    Create a vRA local user principal

    .DESCRIPTION
    Create a vRA Principal (user)

    .PARAMETER Tenant
    The tenant of the user

    .PARAMETER PrincipalId
    Principal id in user@company.com format

    .PARAMETER FirstName
    First Name

    .PARAMETER LastName
    Last Name

    .PARAMETER EmailAddress
    Email Address

    .PARAMETER Description
    Users text description

    .PARAMETER Password
    Users password

    .PARAMETER Credential
    Credential object

    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String.
    System.SecureString
    Management.Automation.PSCredential

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    $SecurePassword = ConvertTo-SecureString “P@ssword” -AsPlainText -Force
    New-vRAUserPrincipal -Tenant vsphere.local -FirstName "Test" -LastName "User" -EmailAddress "user@company.com" -Description "a description" -Password $SecurePassword -PrincipalId "user@vsphere.local"

    .EXAMPLE
    New-vRAUserPrincipal -Tenant vsphere.local -FirstName "Test" -LastName "User" -EmailAddress "user@company.com" -Description "a description" -Credential (Get-Credential)

    .EXAMPLE
    $JSON = @"
        {
        "locked": "false",
        "disabled": "false",
        "firstName": "Test",
        "lastName": "User",
        "emailAddress": "user@company.com",
        "description": "no",
        "password": "password123",
        "principalId": {
            "domain": "vsphere.local",
            "name": "user"
        },
        "tenantName": "Tenant01",
        "name": "Test User"
        }
   "@

   $JSON | New-vRAUserPrincipal

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Password")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ParameterSetName="Password")]
    [ValidateNotNullOrEmpty()]
    [String]$PrincipalId,

    [parameter(Mandatory=$false,ParameterSetName="Credential")]
    [parameter(Mandatory=$false,ParameterSetName="Password")]
    [ValidateNotNullOrEmpty()]
    [String]$Tenant = $Script:vRAConnection.Tenant,

    [parameter(Mandatory=$true,ParameterSetName="Credential")]
    [parameter(Mandatory=$true,ParameterSetName="Password")]
    [ValidateNotNullOrEmpty()]
    [String]$FirstName,

    [parameter(Mandatory=$true,ParameterSetName="Credential")]
    [parameter(Mandatory=$true,ParameterSetName="Password")]
    [ValidateNotNullOrEmpty()]
    [String]$LastName,

    [parameter(Mandatory=$true,ParameterSetName="Credential")]
    [parameter(Mandatory=$true,ParameterSetName="Password")]
    [ValidateNotNullOrEmpty()]
    [String]$EmailAddress,

    [parameter(Mandatory=$false,ParameterSetName="Credential")]
    [parameter(Mandatory=$false,ParameterSetName="Password")]
    [ValidateNotNullOrEmpty()]
    [String]$Description,

    [parameter(Mandatory=$true,ParameterSetName="Password")]
    [ValidateNotNullOrEmpty()]
    [SecureString]$Password,

    [Parameter(Mandatory=$true,ParameterSetName="Credential")]
	[ValidateNotNullOrEmpty()]
	[Management.Automation.PSCredential]$Credential,

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
    [ValidateNotNullOrEmpty()]
    [String]$JSON

    )

    begin {
        # --- Test for vRA API version
        xRequires -Version 7.0
    }

    process {

        try {

            # --- Set Body for REST request depending on ParameterSet
            if ($PSBoundParameters.ContainsKey("JSON")){

                $Body = $JSON
                $Tenant = ($JSON | ConvertFrom-Json).tenantName

            }
            else {

                if ($PSBoundParameters.ContainsKey("Credential")){

                    $PrincipalId = $Credential.UserName
                    $JSONPassword = $Credential.GetNetworkCredential().Password

                }

                if ($PSBoundParameters.ContainsKey("Password")) {

                    $JSONPassword = (New-Object System.Management.Automation.PSCredential("username", $Password)).GetNetworkCredential().Password

                }

                $Name = ($PrincipalId -split "@")[0]
                $Domain = ($PrincipalId -split "@")[1]

                $Body = @"
                {
                    "locked" : "false",
                    "disabled" : "false",
                    "firstName" : "$($FirstName)",
                    "lastName" : "$($LastName)",
                    "emailAddress" : "$($EmailAddress)",
                    "description" : "$($Description)",
                    "password" : "$($JSONPassword)",
                    "principalId": { "domain": "$($Domain)", "name": "$($Name)"} ,
                    "tenantName" : "$($Tenant)",
                    "name" : "$($FirstName) $($LastName)"
                }
"@

            }

            if ($PSCmdlet.ShouldProcess($PrincipalId)){

                $URI = "/identity/api/tenants/$($Tenant)/principals"

                Write-Verbose -Message "Preparing POST to $($URI)"

                # --- Run vRA REST Request
                Invoke-vRARestMethod -Method POST -URI $URI -Body $Body | Out-Null

                Get-vRAUserPrincipal -Tenant $Tenant -Id $PrincipalId

            }

        }
        catch [Exception]{

            throw

        }

    }
    end {

    }

}