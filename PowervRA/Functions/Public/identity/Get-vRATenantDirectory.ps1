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
        
            [pscustomobject]@{

                Name = $Response.content.name
                Description = $Response.content.description
                Domain = $Response.content.domain
                Alias = $Response.content.alias
                Type = $Response.content.type
                UserNameDN = $Response.content.userNameDn
                Password = $Response.content.password
                URL = $Response.content.url
                GroupBaseSearchDN = $Response.content.groupBaseSearchDn
                UserBaseSearchDN = $Response.content.userBaseSearchDn
                Subdomains = $Response.content.subdomains
                GroupBaseSearchDNs = $Response.content.groupBaseSearchDns
                UserBaseSearchDNs = $Response.content.userBaseSearchDns
                DomainAdminUsername = $Response.content.domainAdminUsername
                DomainAdminPassword = $Response.content.domainAdminPassword
                Certificate = $Response.content.certificate
                TrustAll = $Response.content.trustAll
                UseGlobalCatalog = $Response.content.useGlobalCatalog
                New = $Response.content.new
        }
        }
    }
}
catch [Exception]{

    throw
}
}