function Disconnect-vRAServer {
<#
    .SYNOPSIS
    Disconnect from a vRA server
   
    .DESCRIPTION
    Disconnect from a vRA server by removing the authorization token and the global vRAConnection variable from PowerShell
 
    .EXAMPLE
    Disconnect-vRAServer
   
    .EXAMPLE
    Disconnect-vRAServer -Confirm:$false
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]
 
    Param ()
 
    # --- Test for existing connection to vRA
    if (-not $Global:vRAConnection){
 
        throw "vRA Connection variable does not exist. Please run Connect-vRAServer first to create it"
    }

    if ($PSCmdlet.ShouldProcess($Global:vRAConnection.Server)){ 
    
        try {                        
 
            # --- Remove the token from vRA and remove the global PowerShell variable
            $URI = "/identity/api/tokens/$($Global:vRAConnection.Token)" 
            Invoke-vRARestMethod -Method DELETE -URI $URI -Verbose:$VerbosePreference

            # --- Remove custom Security Protocol if it has been specified
            if ($Global:vRAConnection.SslProtocol -ne 'Default'){

                if ($PSVersionTable.PSEdition -eq "Desktop" -or !$PSVersionTable.PSEdition) {

                    [System.Net.ServicePointManager]::SecurityProtocol -= [System.Net.SecurityProtocolType]::$($Global:vRAConnection.SslProtocol)
                }
            }
           
        }
        catch [Exception]{
       
            throw          
 
        }
        finally {
    
            Write-Verbose -Message "Removing vRAConnection global variable"
            Remove-Variable -Name vRAConnection -Scope Global -Force -ErrorAction SilentlyContinue
    
        }

    }
 
}