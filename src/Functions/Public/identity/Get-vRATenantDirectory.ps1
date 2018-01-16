function Get-vRATenantDirectory {
<#
    .SYNOPSIS
    Retrieve vRA Tenant Directories

    .DESCRIPTION
    Retrieve vRA Tenant Directories

    .PARAMETER Id
    Specify the ID of a Tenant

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRATenantDirectory -Id Tenant01

    .EXAMPLE
    Get-vRATenantDirectory -Id Tenant01,Tenant02
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100"
    )

try {

    foreach ($TenantId in $Id){

        $URI = "/identity/api/tenants/$($TenantId)/directories?limit=$($Limit)"

        # --- Run vRA REST Request
        $Response = Invoke-vRARestMethod -Method GET -URI $URI

        if ($Response.content){

            foreach ($TenantDirectory in $Response.Content){

                [pscustomobject]@{

                    Name = $TenantDirectory.name
                    Description = $TenantDirectory.description
                    Domain = $TenantDirectory.domain
                    Alias = $TenantDirectory.alias
                    Type = $TenantDirectory.type
                    UserNameDN = $TenantDirectory.userNameDn
                    Password = $TenantDirectory.password
                    URL = $TenantDirectory.url
                    GroupBaseSearchDN = $TenantDirectory.groupBaseSearchDn
                    UserBaseSearchDN = $TenantDirectory.userBaseSearchDn
                    Subdomains = $TenantDirectory.subdomains
                    GroupBaseSearchDNs = $TenantDirectory.groupBaseSearchDns
                    UserBaseSearchDNs = $TenantDirectory.userBaseSearchDns
                    DomainAdminUsername = $TenantDirectory.domainAdminUsername
                    DomainAdminPassword = $TenantDirectory.domainAdminPassword
                    Certificate = $TenantDirectory.certificate
                    TrustAll = $TenantDirectory.trustAll
                    UseGlobalCatalog = $TenantDirectory.useGlobalCatalog
                    New = $TenantDirectory.new
                }
            }
        }
    }
}
catch [Exception]{

    throw
}
}