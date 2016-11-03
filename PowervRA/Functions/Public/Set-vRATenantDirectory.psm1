function Set-vRATenantDirectory {
<#
    .SYNOPSIS
    Update a vRA Tenant Directory
    
    .DESCRIPTION
    Update a vRA Tenant Directory
    
    .PARAMETER ID
    Tenant ID
    
    .PARAMETER Name
    Tenant Directory Name

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
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Set-vRATenantDirectory -ID Tenant01 -Domain vrademo.local -GroupBaseSearchDNs "OU=Groups,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" -userBaseSearchDNs "OU=Users,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local"
    
    .EXAMPLE
    $JSON = @"
    {
      "name" : "Tenant01",
      "description" : "Tenant01",
      "alias" : "",
      "type" : "AD",
      "userNameDn" : "CN=vrasvc,OU=Service Accounts,OU=HQ,DC=vrademo,DC=local",
      "groupBaseSearchDn" : "OU=Groups,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local",
      "password" : "P@ssword!",
      "url" : "ldap://dc01.vrademo.local:389",
      "userBaseSearchDn" : "OU=Users,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local",
      "domain" : "vrademo.local",
      "domainAdminUsername" : "",
      "domainAdminPassword" : "",
      "subdomains" : [ "" ],
      "groupBaseSearchDns" : [ "OU=Groups,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" ],
      "userBaseSearchDns" : [ "OU=Users,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" ],
      "certificate" : "",
      "trustAll" : true,
      "useGlobalCatalog" : false
    }
    "@
    $JSON | Set-vRATenantDirectory -ID Tenant01 -Domain vrademo.local
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$ID,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Description,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Alias,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Type,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Domain,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$UserNameDN,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Password,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$URL,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$GroupBaseSearchDN,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$UserBaseSearchDN,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Subdomains,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
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
    [String]$DomainAdminPassword,

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
        # --- Test for vRA API version
        xRequires -Version 7
    
        if ($PSBoundParameters.ContainsKey("GroupBaseSearchDNs")){

            if ($GroupBaseSearchDNs.Count -gt 1){

                $GroupBaseSearchDNs | ForEach-Object {

                    $GroupBaseSearchDNsJoin += '"' + $_ + '"'
                }
                $GroupBaseSearchDNs = $GroupBaseSearchDNsJoin -replace '""', '","'
            }
            else {

                $GroupBaseSearchDNs = '"' + $GroupBaseSearchDNs + '"'
            }
        }
        if ($PSBoundParameters.ContainsKey("UserBaseSearchDNs")){

            if ($UserBaseSearchDNs.Count -gt 1){

                $UserBaseSearchDNs | ForEach-Object {

                    $UserBaseSearchDNsJoin += '"' + $_ + '"'
                }
                $UserBaseSearchDNs = $UserBaseSearchDNsJoin -replace '""', '","'
            }
            else {

                $UserBaseSearchDNs = '"' + $UserBaseSearchDNs + '"'
            }
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
            
            # --- Check for existing Tenant
            try {

                $TenantDirectory = Get-vRATenantDirectory -Id $ID | Where-Object {$_.Domain -eq $Domain}
            }
            catch [Exception]{

                throw
            }   
        }
        else {

            # --- Check for existing Tenant
            try {

                $TenantDirectory = Get-vRATenantDirectory -Id $ID | Where-Object {$_.Domain -eq $Domain}
            }
            catch [Exception]{

                throw
            }

            
            # --- Set any properties not specified at function invocation
            if (-not($PSBoundParameters.ContainsKey("Name"))){

                if ($TenantDirectory.Name){

                    $Name = $TenantDirectory.Name
                }
            }            
            if (-not($PSBoundParameters.ContainsKey("Description"))){

                if ($TenantDirectory.Description){

                    $Description = $TenantDirectory.Description
                }
            }
            if (-not($PSBoundParameters.ContainsKey("Alias"))){

                if ($TenantDirectory.Alias){

                    $Alias = $TenantDirectory.Alias
                }
            }
            if (-not($PSBoundParameters.ContainsKey("Type"))){

                if ($TenantDirectory.Type){

                    $Type = $TenantDirectory.Type
                }
            }
            if (-not($PSBoundParameters.ContainsKey("UserNameDN"))){

                if ($TenantDirectory.UserNameDN){

                    $UserNameDN = $TenantDirectory.UserNameDN
                }
            }
            if (-not($PSBoundParameters.ContainsKey("Password"))){

                if ($TenantDirectory.Password){

                    $Password = $TenantDirectory.Password
                }
            }
            if (-not($PSBoundParameters.ContainsKey("URL"))){

                if ($TenantDirectory.URL){

                    $URL = $TenantDirectory.URL
                }
            }
            if (-not($PSBoundParameters.ContainsKey("GroupBaseSearchDN"))){

                if ($TenantDirectory.GroupBaseSearchDN){

                    $GroupBaseSearchDN = $TenantDirectory.GroupBaseSearchDN
                }
            }
            if (-not($PSBoundParameters.ContainsKey("UserBaseSearchDN"))){

                if ($TenantDirectory.UserBaseSearchDN){

                    $UserBaseSearchDN = $TenantDirectory.UserBaseSearchDN
                }
            }
            if (-not($PSBoundParameters.ContainsKey("Subdomains"))){

                if ($TenantDirectory.Subdomains){

                    $Subdomains = $TenantDirectory.Subdomains
                }
            }
            if (-not($PSBoundParameters.ContainsKey("GroupBaseSearchDNs"))){

               if ($TenantDirectory.GroupBaseSearchDNs){

                    $GroupBaseSearchDNs = $TenantDirectory.GroupBaseSearchDNs
                }
               if ($GroupBaseSearchDNs.Count -gt 1){

                    $GroupBaseSearchDNs | ForEach-Object {

                        $GroupBaseSearchDNsJoin += '"' + $_ + '"'
                    }
                    $GroupBaseSearchDNs = $GroupBaseSearchDNsJoin -replace '""', '","'
                }
                else {

                    $GroupBaseSearchDNs = '"' + $GroupBaseSearchDNs + '"'
                }
            }
            if (-not($PSBoundParameters.ContainsKey("UserBaseSearchDNs"))){

                if ($TenantDirectory.UserBaseSearchDNs){

                    $UserBaseSearchDNs = $TenantDirectory.UserBaseSearchDNs
                }
                if ($UserBaseSearchDNs.Count -gt 1){

                    $UserBaseSearchDNs | ForEach-Object {

                        $UserBaseSearchDNsJoin += '"' + $_ + '"'
                    }
                    $UserBaseSearchDNs = $UserBaseSearchDNsJoin -replace '""', '","'
                }
                else {

                    $UserBaseSearchDNs = '"' + $UserBaseSearchDNs + '"'
                }
            }
            if (-not($PSBoundParameters.ContainsKey("DomainAdminUsername"))){

                if ($TenantDirectory.DomainAdminUsername){

                    $DomainAdminUsername = $TenantDirectory.DomainAdminUsername
                }
            }
            if (-not($PSBoundParameters.ContainsKey("DomainAdminPassword"))){

                if ($TenantDirectory.DomainAdminPassword){

                    $DomainAdminPassword = $TenantDirectory.DomainAdminPassword
                }
            }
            if (-not($PSBoundParameters.ContainsKey("Certificate"))){

                if ($TenantDirectory.Certificate){

                    $Certificate = $TenantDirectory.Certificate
                }
            }
            if (-not($PSBoundParameters.ContainsKey("TrustAll"))){

                if ($TenantDirectory.TrustAll){

                    $TrustAll = $TenantDirectory.TrustAll
                }
            }
            if (-not($PSBoundParameters.ContainsKey("UseGlobalCatalog"))){

                if ($TenantDirectory.UseGlobalCatalog){

                    $UseGlobalCatalog = $TenantDirectory.UseGlobalCatalog
                }
            }

        
            $Body = @"
                {
                  "name" : "$($Name)",
                  "description" : "$($Description)",
                  "alias" : "$($Alias)",
                  "type" : "$($Type)",
                  "userNameDn" : "$($UserNameDN)",
                  "groupBaseSearchDn" : "$($GroupBaseSearchDN)",
                  "password" : "$($Password)",
                  "url" : "$($URL)",
                  "userBaseSearchDn" : "$($UserBaseSearchDN)",
                  "domain" : "$($Domain)",
                  "domainAdminUsername" : "$($DomainAdminUsername)",
                  "domainAdminPassword" : "$($DomainAdminPassword)",
                  "subdomains" : [ "$($Subdomains)" ],
                  "groupBaseSearchDns" : [ $($GroupBaseSearchDNs) ],
                  "userBaseSearchDns" : [ $($UserBaseSearchDNs) ],
                  "certificate" : "$($Certificate)",
                  "trustAll" : $($TrustAllText),
                  "useGlobalCatalog" : $($UseGlobalCatalogText)
                }
"@
        }
        
        # --- Update existing Tenant 
        try {
            if ($PSCmdlet.ShouldProcess($Id)){

                $URI = "/identity/api/tenants/$($ID)/directories/$($Domain)"  

                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body $Body

                # --- Output the Successful Result
                Get-vRATenantDirectory -Id $ID | Where-Object {$_.Domain -eq $Domain}
            }
        }
        catch [Exception]{

            throw
        }
    }
    end {
        
    }
}