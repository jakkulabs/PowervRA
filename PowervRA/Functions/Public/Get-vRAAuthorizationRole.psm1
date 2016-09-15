function Get-vRAAuthorizationRole {
<#
    .SYNOPSIS
    Retrieve vRA Authorization Role
    
    .DESCRIPTION
    Retrieve vRA Authorization Role
    
    .PARAMETER Id
    Specify the Id of a Role

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAAuthorizationRole
    
    .EXAMPLE
    Get-vRAAuthorizationRole -Id CSP_TENANT_ADMIN
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,    
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100"
    )
                
try {
    # --- If the Id parameter is passed return only that Role Id
    if ($PSBoundParameters.ContainsKey("Id")){ 
        
        foreach ($Role in $Id){

            $URI = "/identity/api/authorization/roles/$Role"

            # --- Run vRA REST Request
            $Response = Invoke-vRARestMethod -Method GET -URI $URI
        
            [pscustomobject]@{

                Id = $Response.id
                Name = $Response.name
                Description = $Response.description
                Type = $Response.'@type'
                AssignedPermissions = $Response.assignedPermissions
            }
        }
    }
    else {

        $URI = "/identity/api/authorization/roles?limit=$($Limit)"
        
        # --- Run vRA REST Request
        $Response = Invoke-vRARestMethod -Method GET -URI $URI
        
        foreach ($Role in $Response.content) {
        
            [pscustomobject]@{

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