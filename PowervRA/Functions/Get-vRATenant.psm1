function Get-vRATenant {
<#
    .SYNOPSIS
    Retrieve vRA Tenants
    
    .DESCRIPTION
    Retrieve vRA Tenants. Make sure to have permission to access all Tenant information
    
    .PARAMETER Id
    Specify the ID of a Tenant

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRATenant
    
    .EXAMPLE
    Get-vRATenant -Id Tenant01
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [Alias("Name")]
    [String[]]$Id,    
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100"
    )
                
try {
    # --- If the Id parameter is passed return only that Tenant
    if ($PSBoundParameters.ContainsKey("Id")){ 
        
        foreach ($TenantId in $Id){

            $URI = "/identity/api/tenants/$($TenantId)"

            # --- Run vRA REST Request
            $Response = Invoke-vRARestMethod -Method GET -URI $URI
        
            [pscustomobject]@{

                Id = $Response.id
                UrlName = $Response.urlName
                Name = $Response.name
                Description = $Response.description
                ContactEmail = $Response.contactEmail
                Password = $Response.password
                DefaultTenant = $Response.defaultTenant
            }
        }
    }
    else {

        $URI = "/identity/api/tenants?limit=$($Limit)"
        
        # --- Run vRA REST Request
        $Response = Invoke-vRARestMethod -Method GET -URI $URI
        
        foreach ($Tenant in $Response.content) {
        
            [pscustomobject]@{

                Id = $Tenant.id
                UrlName = $Tenant.urlName
                Name = $Tenant.name
                Description = $Tenant.description
                ContactEmail = $Tenant.contactEmail
                Password = $Tenant.password
                DefaultTenant = $Tenant.defaultTenant
            }
        }
    }
}
catch [Exception]{

    throw
}
}