function Get-vRAGroupPrincipal {
<#
    .SYNOPSIS
    Finds groups.
    
    .DESCRIPTION
    Finds groups in one of the identity providers configured for the tenant.
    
    .PARAMETER Id
    The Id of the group
    
    .PARAMETER Tenant
    The tenant of the group
    
    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAGroupPrincipal
    
    .EXAMPLE
    Get-vRAGroupPrincipal -Id group@vsphere.local
    
    .EXAMPLE
    Get-vRAGroupPrincipal -PrincipalId group@vsphere.local    

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ParameterSetName="ById")]    
    [ValidateNotNullOrEmpty()]
    [Alias("PrincipalId")]
    [String[]]$Id,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [parameter(Mandatory=$true,ParameterSetName="ById")]    
    [ValidateNotNullOrEmpty()]
    [String]$Tenant = $Global:vRAConnection.Tenant,          
          
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100"
    
    )
                
    try {

        switch ($PsCmdlet.ParameterSetName) {
            
            'ById' {
                
                foreach ($GroupId in $Id){

                    $URI = "/identity/api/tenants/$($Tenant)/groups/$($GroupId)"

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI
                
                    [pscustomobject] @{

                        GroupType = $Response.groupType
                        Name = $Response.name
                        Domain = $Response.domain
                        Description = $Response.description
                        PrincipalId = "$($Response.principalId.name)@$($Response.principalId.domain)"

                    }                                    

                }                
   
            }
            
            'Standard' {
 
                $URI = "/identity/api/tenants/$($Tenant)/groups?limit=$($Limit)"
                
                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method GET -URI $URI
                
                foreach ($Principal in $Response.content) {
                
                    [pscustomobject] @{

                        GroupType = $Principal.groupType
                        Name = $Principal.name
                        Domain = $Principal.domain
                        Description = $Principal.description
                        PrincipalId = "$($Principal.principalId.name)@$($Principal.principalId.domain)"

                    }

                }               
                                
            }                             
  
        }
        
    }
    catch [Exception]{

        throw
        
    }
    
}