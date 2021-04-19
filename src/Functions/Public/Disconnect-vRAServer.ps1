function Disconnect-vRAServer {
<#
    .SYNOPSIS
    Disconnect from a vRA server

    .DESCRIPTION
    Disconnect from a vRA server by removing the authorization token and the vRAConnection script variable from PowerShell

    .EXAMPLE
    Disconnect-vRAServer

    .EXAMPLE
    Disconnect-vRAServer -Confirm:$false
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param ()

    # --- Test for existing connection to vRA
    if (-not $Script:vRAConnection){

        throw "vRA Connection variable does not exist. Please run Connect-vRAServer first to create it"
    }

    if ($PSCmdlet.ShouldProcess($Script:vRAConnection.Server)){

        try {

            # --- Remove custom Security Protocol if it has been specified
            if ($Script:vRAConnection.SslProtocol -ne 'Default'){

                if (!$IsCoreCLR) {

                    [System.Net.ServicePointManager]::SecurityProtocol -= [System.Net.SecurityProtocolType]::$($Script:vRAConnection.SslProtocol)
                }
            }

        }
        catch [Exception]{

            throw

        }
        finally {

            # --- Remove the vRAConnection script variable
            Write-Verbose -Message "Removing vRAConnection script variable"
            Remove-Variable -Name vRAConnection -Scope Script -Force -ErrorAction SilentlyContinue
        }
    }
}