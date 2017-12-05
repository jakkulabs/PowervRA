function Remove-vRATenantDirectory {
<#
    .SYNOPSIS
    Remove a vRA Tenant Directory
    
    .DESCRIPTION
    Remove a vRA Tenant Directory
    
    .PARAMETER Id
    Tenant Id

    .PARAMETER Domain
    Tenant Directory Domain

    .INPUTS
    System.String.

    .OUTPUTS
    None

    .EXAMPLE
    Remove-vRATenantDirectory -Id Tenant01 -Domain vrademo.local
    
    .EXAMPLE
    $Id = "Tenant01"
    Get-vRATenantDirectory -Id $Id | Remove-vRATenantDirectory -Id $Id -Confirm:$false
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Domain
    )    

    begin {
    
    }
    
    process {    
            
        foreach ($TenantId in $Id){
                
            try {
                if ($PSCmdlet.ShouldProcess($Id)){

                    $URI = "/identity/api/tenants/$($ID)/directories/$($Domain)"  

                    # --- Run vRA REST Request
                    Invoke-vRARestMethod -Method DELETE -URI $URI -Verbose:$VerbosePreference | Out-Null
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