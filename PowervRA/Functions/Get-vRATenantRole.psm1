function Get-vRATenantRole {
<#
    .SYNOPSIS
    Retrieve vRA Tenant Role
    
    .DESCRIPTION
    Retrieve vRA Tenant Role
    
    .PARAMETER TenantId
    Specify the Tenant Id

    .PARAMETER PrincipalId
    Specify the Principal Id

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.
    
    .EXAMPLE
    Get-vRATenantRole -TenantId Tenant01 -PrincipalId Tenantadmin@vrademo.local
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$TenantId,
    
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$PrincipalId,  
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100"
    )
                
try {
        
        foreach ($Principal in $PrincipalId){

            $URI = "/identity/api/authorization/tenants/$($TenantId)/principals/$Principal/roles?limit=$($Limit)"

            # --- Run vRA REST Request
            $Response = Invoke-vRARestMethod -Method GET -URI $URI
        
            foreach ($Role in $Response.content) {
        
                [pscustomobject]@{

                    Principal = $Principal
                    Id = $Role.id
                    Name = $Role.name
                    Description = $Role.description
                    Type = $Role.'@type'
                    AssignedPermissions = $Role.assignedPermissions
                }
            }
        }
}
catch [Exception]{

    throw
}
}