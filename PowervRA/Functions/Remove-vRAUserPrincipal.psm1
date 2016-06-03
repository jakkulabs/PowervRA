function Remove-vRAUserPrincipal {
<#
    .SYNOPSIS
    Remove a vRA local user principal
    
    .DESCRIPTION
    Remove a vRA local user principal
    
    .PARAMETER Id
    The principal id of the user
    
    .PARAMETER Tenant
    The tenant of the user

    .INPUTS
    System.String.

    .OUTPUTS
    None

    .EXAMPLE
    Remove-vRAUserPrincipal -PrincipalId user@vsphere.local
    
    .EXAMPLE
    Get-vRAUserPrincipal -Id user@vsphere.local | Remove-vRAUserPrincipal
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNullOrEmpty()]
    [Alias("PrincipalId")]
    [String[]]$Id,
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Tenant = $Global:vRAConnection.Tenant      
    
    )    

    begin {
    
    }
    
    process {    
            
        foreach ($UserId in $Id){
                
            try {
                
                if ($PSCmdlet.ShouldProcess($UserId)){

                    $URI = "/identity/api/tenants/$($Tenant)/principals/$($UserId)"  
                    
                    Write-Verbose -Message "Preparing DELETE to $($URI)"                        

                    # --- Run vRA REST Request                    
                    Invoke-vRARestMethod -Method DELETE -URI $URI | Out-Null
                    
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