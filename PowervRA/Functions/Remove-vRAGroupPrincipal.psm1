function Remove-vRAGroupPrincipal {
<#
    .SYNOPSIS
    Remove a vRA custom group
    
    .DESCRIPTION
    Remove a vRA custom group
    
    .PARAMETER Id
    The principal id of the custom group

    .INPUTS
    System.String.

    .OUTPUTS
    None

    .EXAMPLE
    Remove-vRAGroupPrincipal -PrincipalId Group@Tenant
    
    .EXAMPLE
    Get-vRAGroupPrincipal -Id Group@Tenant | Remove-vRAGroupPrincipal
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNullOrEmpty()]
    [Alias("PrincipalId")]
    [String[]]$Id
    
    )    

    begin {
    
    }
    
    process {    
            
        foreach ($GroupId in $Id){
                
            try {
                
                if ($PSCmdlet.ShouldProcess($GroupId)){
                    
                    # --- Get the user principal object
                    $Group = Get-vRAGroupPrincipal -Id $GroupId

                    $URI = "/identity/api/tenants/$($Group.Domain)/groups/$($GroupId)"  
                    
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