function New-vRATenantDirectory {
<#
    .SYNOPSIS
    Create a vRA Tenant Directory
    
    .DESCRIPTION
    Create a vRA Tenant Directory

    .PARAMETER ID
    Tenant ID
    
    .PARAMETER Name
    Tenant Directory Name
    
    .PARAMETER Description
    Tenant Directory Description

    .PARAMETER Alias
    Tenant Directory Alias

    .PARAMETER Type
    Tenant Directory Type

    .PARAMETER Domain
    Tenant Directory Domain

    .PARAMETER UserNameDN
    DN of the Username to authenticate the Tenant Directory with
    
    .PARAMETER Password
    Password of the Username to authenticate the Tenant Directory with

    .PARAMETER URL
    Tenant Directory URL, e.g. ldap://dc01.vrademo.local:389

    .PARAMETER GroupBaseSearchDN
    Tenant Directory GroupBaseSearchDN

    .PARAMETER UserBaseSearchDN
    Tenant Directory UserBaseSearchDN

    .PARAMETER Subdomains
    Tenant Directory Subdomains

    .PARAMETER GroupBaseSearchDNs
    Tenant Directory GroupBaseSearchDNs

    .PARAMETER UserBaseSearchDNs
    Tenant Directory UserBaseSearchDNs

    .PARAMETER DomainAdminUserName
    Tenant Directory DomainAdminUserName

    .PARAMETER DomainAdminPassword
    Tenant Directory DomainAdminPassword

    .PARAMETER Certificate
    Tenant Directory Certificate

    .PARAMETER TrustAll
    Tenant Directory TrustAll

    .PARAMETER UseGlobalCatalog
    Tenant Directory UseGlobalCatalog

    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String
    System.SecureString

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    $SecurePassword = ConvertTo-SecureString “P@ssword” -AsPlainText -Force
    New-vRATenantDirectory -ID Tenant01 -Name Tenant01 -Description "This is the Tenant01 Directory" -Type AD -Domain "vrademo.local" -UserNameDN "CN=vrasvc,OU=Service Accounts,OU=HQ,DC=vrademo,DC=local" `
      -Password $SecurePassword -URL "ldap://dc01.vrademo.local:389" -GroupBaseSearchDN "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" -UserBaseSearchDN "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" `
     -GroupBaseSearchDNs "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" -UserBaseSearchDNs "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" -TrustAll
    
    .EXAMPLE
    $JSON = @"
    {
      "name" : "Tenant01",
      "description" : "Tenant01",
      "alias" : "",
      "type" : "AD",
      "userNameDn" : "CN=vrasvc,OU=Service Accounts,OU=HQ,DC=vrademo,DC=local",
      "groupBaseSearchDn" : "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local",
      "password" : "P@ssword!",
      "url" : "ldap://dc01.vrademo.local:389",
      "userBaseSearchDn" : "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local",
      "domain" : "vrademo.local",
      "domainAdminUsername" : "",
      "domainAdminPassword" : "",
      "subdomains" : [ "" ],
      "groupBaseSearchDns" : [ "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" ],
      "userBaseSearchDns" : [ "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" ],
      "certificate" : "",
      "trustAll" : true,
      "useGlobalCatalog" : false
    }
    "@
    $JSON | New-vRATenantDirectory -ID Tenant01
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$ID,
    
    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Description,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Alias,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Type,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Domain,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$UserNameDN,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [SecureString]$Password,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$URL,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$GroupBaseSearchDN,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$UserBaseSearchDN,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Subdomains,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$GroupBaseSearchDNs,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$UserBaseSearchDNs,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$DomainAdminUsername,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [SecureString]$DomainAdminPassword,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Certificate,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [Switch]$TrustAll,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [Switch]$UseGlobalCatalog,

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
    [ValidateNotNullOrEmpty()]
    [String]$JSON
    )    

    begin {

        if ($PSBoundParameters.ContainsKey("Password")){

            $JSONPassword = (New-Object System.Management.Automation.PSCredential("username", $Password)).GetNetworkCredential().Password
        }
        if ($PSBoundParameters.ContainsKey("DomainAdminPassword")){

            $JSONDomainAdminPassword = (New-Object System.Management.Automation.PSCredential("username", $DomainAdminPassword)).GetNetworkCredential().Password
        }
        if ($PSBoundParameters.ContainsKey("GroupBaseSearchDNs")){

            $GroupBaseSearchDNsJSON = ($GroupBaseSearchDNs | ForEach-Object {'"' + $_ + '"'}) -join ','
        }
        if ($PSBoundParameters.ContainsKey("UserBaseSearchDNs")){

            $UserBaseSearchDNsJSON = ($UserBaseSearchDNs | ForEach-Object {'"' + $_ + '"'}) -join ','
        }
        if ($PSBoundParameters.ContainsKey("$TrustAll")){

            $TrustAllText = "true"
        }
        else {

            $TrustAllText = "false"
        }
        if ($PSBoundParameters.ContainsKey("$UseGlobalCatalog")){

            $UseGlobalCatalogText = "true"
        }
        else {

            $UseGlobalCatalogText = "false"
        }
    }
    
    process {
    
        # --- Set Body for REST request depending on ParameterSet
        if ($PSBoundParameters.ContainsKey("JSON")){

            $Data = ($JSON | ConvertFrom-Json)
        
            $Body = $JSON
            $Name = $Data.name  
        }
        else {
        
            $Body = @"
                {
                  "name" : "$($Name)",
                  "description" : "$($Description)",
                  "alias" : "$($Alias)",
                  "type" : "$($Type)",
                  "userNameDn" : "$($UserNameDN)",
                  "groupBaseSearchDn" : "$($GroupBaseSearchDN)",
                  "password" : "$($JSONPassword)",
                  "url" : "$($URL)",
                  "userBaseSearchDn" : "$($UserBaseSearchDN)",
                  "domain" : "$($Domain)",
                  "domainAdminUsername" : "$($DomainAdminUsername)",
                  "domainAdminPassword" : "$($JSONDomainAdminPassword)",
                  "subdomains" : [ "$($Subdomains)" ],
                  "groupBaseSearchDns" : [ $($GroupBaseSearchDNsJSON) ],
                  "userBaseSearchDns" : [ $($UserBaseSearchDNsJSON) ],
                  "certificate" : "$($Certificate)",
                  "trustAll" : $($TrustAllText),
                  "useGlobalCatalog" : $($UseGlobalCatalogText)
                }
"@
        }  
           
        try {
            if ($PSCmdlet.ShouldProcess($ID)){

                $URI = "/identity/api/tenants/$($ID)/directories"  

                # --- Run vRA REST Request
                Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference | Out-Null

                # --- Output the Successful Result
                Get-vRATenantDirectory -Id $ID | Where-Object {$_.Name -eq $Name}
            }
        }
        catch [Exception]{

            throw
        }
    }
    end {
        
    }
}