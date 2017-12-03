function Remove-vRAGroupPrincipal {
<#
    .SYNOPSIS
    Remove a vRA custom group
    
    .DESCRIPTION
    Remove a vRA custom group
    
    .PARAMETER Id
    The principal id of the custom group
    
    .PARAMETER Tenant
    The tenant of the group

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
    [String[]]$Id,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Tenant = $Global:vRAConnection.Tenant    
    
    )    

    begin {
    
    }
    
    process {    
            
        foreach ($GroupId in $Id){
                
            try {
                
                if ($PSCmdlet.ShouldProcess($GroupId)){
                   
                    $URI = "/identity/api/tenants/$($Tenant)/groups/$($GroupId)"  
                    
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