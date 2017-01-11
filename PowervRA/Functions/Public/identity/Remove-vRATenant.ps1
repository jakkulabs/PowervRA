function Remove-vRATenant {
<#
    .SYNOPSIS
    Remove a vRA Tenant
    
    .DESCRIPTION
    Remove a vRA Tenant
    
    .PARAMETER Id
    Tenant ID

    .INPUTS
    System.String.

    .OUTPUTS
    None

    .EXAMPLE
    Remove-vRATenant -Id Tenant02
    
    .EXAMPLE
    Get-vRATenant -Id Tenant02 | Remove-vRATenant -Confirm:$false
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id
    )    

    begin {
    
    }
    
    process {    
            
        foreach ($TenantId in $Id){
                
            try {
                if ($PSCmdlet.ShouldProcess($Id)){

                    $URI = "/identity/api/tenants/$($ID)"  

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