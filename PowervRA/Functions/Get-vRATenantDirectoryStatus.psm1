function Get-vRATenantDirectoryStatus {
<#
    .SYNOPSIS
    Retrieve vRA Tenant Directory Status
    
    .DESCRIPTION
    Retrieve vRA Tenant Directory Status
    
    .PARAMETER Id
    Specify the ID of a Tenant

    .PARAMETER Domain
    Specify the Domain of a Tenant Directory

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.
    
    .EXAMPLE
    Get-vRATenantDirectoryStatus -Id Tenant01 -Domain vrademo.local

    .EXAMPLE
    Get-vRATenantDirectoryStatus -Id Tenant01 -Domain vrademo.local,test.local
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Id,    
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String[]]$Domain
    )
# --- Test for vRA API version
xRequires -Version 7 -Context $MyInvocation
                
try {
        
    foreach ($TenantDomain in $Domain){

        $URI = "/identity/api/tenants/$($Id)/directories/$($TenantDomain)/status"

        # --- Run vRA REST Request
        $Response = Invoke-vRARestMethod -Method GET -URI $URI
        
        [pscustomobject]@{

            Tenant = $Id
            Directory = $TenantDomain
            Status = $Response.syncStatus.status
            Message = $Response.syncStatus.message
        }
    }
}
catch [Exception]{

    throw
}
}