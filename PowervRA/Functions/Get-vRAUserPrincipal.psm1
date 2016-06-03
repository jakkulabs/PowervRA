function Get-vRAUserPrincipal {
<#
    .SYNOPSIS
    Finds regular users
    
    .DESCRIPTION
    Finds regular users in one of the identity providers configured for the tenant.
    
    .PARAMETER Id
    The Id of the user
    
    .PARAMETER Tenant
    The tenant of the user
    
    .PARAMETER LocalUsersOnly
    Only return local users
    
    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAUserPrincipal
    
    .EXAMPLE
    Get-vRAUserPrincipal -LocalUsersOnly

    .EXAMPLE
    Get-vRAUserPrincipal -Id user@vsphere.local
    
    .EXAMPLE
    Get-vRAUserPrincipal -UserName user@vsphere.local
    
    .EXAMPLE
    Get-vRAUserPrincipal -PrincipalId user@vsphere.local
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true, ParameterSetName="byId")]
    [ValidateNotNullOrEmpty()]
    [Alias("UserName","PrincipalId")]
    [String[]]$Id,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]  
    [parameter(Mandatory=$false,ParameterSetName="byId")]    
    [ValidateNotNullOrEmpty()]
    [String]$Tenant = $Global:vRAConnection.Tenant,    
    
    [parameter(Mandatory=$false, ParameterSetName="Standard")]
    [Switch]$LocalUsersOnly,   
          
    [parameter(Mandatory=$false, ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100"
    
    )
                
    try {
        
        switch ($PSCmdlet.ParameterSetName){
            
            'ById'{

                foreach ($UserId in $Id){

                    $URI = "/identity/api/tenants/$($Tenant)/principals/$($UserId)"

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI
                
                    [pscustomobject] @{

                        FirstName = $Response.firstName
                        LastName = $Response.lastName
                        EmailAddress = $Response.emailAddress
                        Description = $Response.description
                        Locked = $Response.locked
                        Disabled = $Response.disabled
                        Password = $Response.password
                        PrincipalId = "$($Response.principalId.name)@$($Response.principalId.domain)"
                        TenantName = $Response.tenantName
                        Name = $Response.name

                    }
                    
                }
                                
            }
            
            'Standard' {
                     
                if ($PSBoundParameters.ContainsKey("LocalUsersOnly")) {
                    
                    $Params = "&localUsersOnly=true"
                    
                }
                
                $URI = "/identity/api/tenants/$($Tenant)/principals?limit=$($Limit)$($Params)"
                
                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method GET -URI $URI
                
                foreach ($Principal in $Response.content) {
                
                    [pscustomobject] @{

                        FirstName = $Principal.firstName
                        LastName = $Principal.lastName
                        EmailAddress = $Principal.emailAddress
                        Description = $Principal.description
                        Locked = $Principal.locked
                        Disabled = $Principal.disabled
                        Password = $Principal.password
                        PrincipalId = "$($Principal.principalId.name)@$($Principal.principalId.domain)"
                        TenantName = $Principal.tenantName
                        Name = $Principal.name

                    }
                    
                }                                
                
            }
     
        }
        
    }
    catch [Exception]{

        throw
        
    }
    
}