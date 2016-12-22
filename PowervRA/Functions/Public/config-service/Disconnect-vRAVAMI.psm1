function Disconnect-vRAVAMIServer {
<#
    .SYNOPSIS
    Disconnect from a vRA appliance
   
    .DESCRIPTION
    Disconnect from a vRA appliance by removing the authorization token and the global vRAConnection variable from PowerShell
 
    .EXAMPLE
    Disconnect-vRAVAMIServer
   
    .EXAMPLE
    Disconnect-vRAVAMIServer -Confirm:$false
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]
 
    Param ()
 
    # --- Test for existing connection to vRA
    if (-not $Global:vRAVAMIConnection){
 
        throw "vRA Connection variable does not exist. Please run Connect-vRAServer first to create it"
    }

    if ($PSCmdlet.ShouldProcess($Global:vRAVAMIConnection.Server)){ 
    
        try {                        
 
            # --- Remove the global PowerShell variable

            Write-Verbose -Message "Removing vRAVAMIConnection global variable"
            Remove-Variable -Name vRAVAMIConnection -Scope Global -Force -ErrorAction SilentlyContinue
           
        }
        catch [Exception]{
       
            throw          
 
        }
        finally {
    

    
        }

    }
 
}