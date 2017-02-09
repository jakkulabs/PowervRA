function Add-vRAPrincipalToTenantRole {
<#
    .SYNOPSIS
    Add a vRA Principal to a Tenant Role
    
    .DESCRIPTION
    Add a vRA Principal to a Tenant Role
    
    .PARAMETER TenantId
    Specify the Tenant Id

    .PARAMETER PrincipalId
    Specify the Principal Id

    .PARAMETER RoleId
    Specify the Role Id

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.
    
    .EXAMPLE
    Add-vRAPrincipalToTenantRole -TenantId Tenant01 -PrincipalId Tenantadmin@vrademo.local -RoleId CSP_TENANT_ADMIN

    .EXAMPLE
    Get-vRAUserPrincipal -UserName Tenantadmin@vrademo.local | Add-vRAPrincipalToTenantRole -TenantId Tenant01 -RoleId CSP_TENANT_ADMIN
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$TenantId,
    
    [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$PrincipalId,  
    
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$RoleId
    )

begin {

}

process {

    foreach ($Principal in $PrincipalId){
                
        try {

            if ($PSCmdlet.ShouldProcess($Principal)){
     
                $URI = "/identity/api/authorization/tenants/$($TenantId)/principals/$($Principal)/roles/$($Roleid)"

                # --- Run vRA REST Request
                Invoke-vRARestMethod -Method PUT -URI $URI -Verbose:$VerbosePreference | Out-Null
        
                # --- Output the Successful Result
                Get-vRATenantRole -TenantId $TenantId -PrincipalId $Principal | Where-Object {$_.Id -eq $RoleId} | Select-Object Principal,Id,Name
            }
        }
        catch [Exception]{

            throw
        }
    }
}

end {

}
}