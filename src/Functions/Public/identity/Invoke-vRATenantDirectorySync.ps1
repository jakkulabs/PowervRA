function Invoke-vRATenantDirectorySync {
<#
    .SYNOPSIS
    Sync an identity store
    
    .DESCRIPTION
    Sync an identity store
    
    .PARAMETER Id
    Specify the ID of a Tenant

    .PARAMETER Domain
    Specify the Domain of a Tenant Directory

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.
    
    .EXAMPLE
    Invoke-vRATenantDirectorySync -Id Tenant01 -Domain vrademo.local

    .EXAMPLE
    Invoke-vRATenantDirectorySync -Id Tenant01 -Domain vrademo.local,test.local
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Id,    
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String[]]$Domain
    )

    # --- Test for vRA API version
    xRequires -Version 7.4
                
try {
        
    foreach ($TenantDomain in $Domain){

        $URI = "/identity/api/tenants/$($Id)/directories/$($TenantDomain)/sync "
        if ($PSCmdlet.ShouldProcess($Id)){

            # --- Run vRA REST Request
            Invoke-vRARestMethod -Method POST -URI $URI

            Get-vRATenantDirectoryStatus -Id $Id -Domain $Domain
        }
        # --- Run vRA REST Request
        Invoke-vRARestMethod -Method POST -URI $URI
        
        Get-vRATenantDirectoryStatus -Id $Id -Domain $Domain
		
    }
}
catch [Exception]{

    throw
}
}
