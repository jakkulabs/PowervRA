function Get-vRAUserPrincipalGroupMembership {
<#
    .SYNOPSIS
    Retrieve a list of groups that a user is a member of
    
    .DESCRIPTION
    Retrieve a list of groups that a user is a member of
    
    .PARAMETER Id
    The Id of the user
    
    .PARAMETER Tenant
    The tenant of the user
    
    .PARAMETER GroupType
    Return either custom or sso groups
    
    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .PARAMETER Page
    The page of response to return. By default this is 1.

    .INPUTS
    System.String
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAUserPrincipal -Id user@vsphere.local | Get-vRAUserPrincipalGroupMembership
    
    .EXAMPLE
    Get-vRAUserPrincipal -Id user@vsphere.local | Get-vRAUserPrincipalGroupMembership -GroupType SSO

    .EXAMPLE
    Get-vRAUserPrincipalGroupMembership -Id user@vsphere.local
    
    .EXAMPLE
    Get-vRAUserPrincipalGroupMembership -UserPrincipal user@vsphere.local

#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (
        [parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("PrincipalId")]
        [String[]]$Id,
        
        [parameter(Mandatory=$false)]  
        [ValidateNotNullOrEmpty()]
        [String]$Tenant = $Global:vRAConnection.Tenant,    
        
        [parameter(Mandatory=$false)]
        [ValidateSet("SSO","CUSTOM")]
        [String]$GroupType,   
          
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100,
    
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1
    )
    
    Begin {
        # --- Test for vRA API version
        xRequires -Version 7.0
    }
    
    Process {
                
        try {
  
            foreach ($UserId in $Id){

                $URI = "/identity/api/tenants/$($Tenant)/principals/$($UserId)/groups?limit=$($Limit)&page=$($Page)"

                if ($PSBoundParameters.ContainsKey("GroupType")) {
                    $URI = $URI + "&groupType=$($GroupType)"
                }

                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                foreach ($Group in $Response.content) {
                    [PSCustomObject] @{
                        GroupType = $Group.groupType
                        Name = $Group.name
                        Domain = $Group.domain
                        Description = $Group.description
                        PrincipalId = "$($Group.principalId.name)@$($Group.principalId.domain)"
                    }
                }
            }
        }
        catch [Exception]{

            throw $_        
        }
    }
    
    End {

    }   
}