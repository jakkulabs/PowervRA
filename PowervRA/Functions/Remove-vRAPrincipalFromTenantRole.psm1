function Remove-vRAPrincipalFromTenantRole {
<#
    .SYNOPSIS
    Remove a vRA Principal from a Tenant Role
    
    .DESCRIPTION
    Remove a vRA Principal from a Tenant Role
    
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
    Remove-vRAPrincipalFromTenantRole -TenantId Tenant01 -PrincipalId Tenantadmin@vrademo.local -RoleId CSP_TENANT_ADMIN

    .EXAMPLE
    Get-vRAUserPrincipal -UserName Tenantadmin@vrademo.local | Remove-vRAPrincipalFromTenantRole -TenantId Tenant01 -RoleId CSP_TENANT_ADMIN
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

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
                $Response = Invoke-vRARestMethod -Method DELETE -URI $URI
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