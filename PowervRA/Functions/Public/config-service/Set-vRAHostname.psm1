function Set-vRAHostname {
<#
    .SYNOPSIS
    Set the hostname value used to resolve the application.
    
    .DESCRIPTION
    This does not change the appliance hostname, only the hostname alias (typically the load balancer VIP FQDN.)

    .PARAMETER Name
    The name of the node on which to execute the command.

    .PARAMETER Hostname
    The desired hostname value.
    
    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE 
    Set-vRAHostname -Name vra-01a.lab.local -Hostname vra.lab.local

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

    Param (
    
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Name,
    
    [parameter(Mandatory=$true)]
    [ValidateNotNullorEmpty()]
    [String]$Hostname
       
    )   

begin {

}

process {   
        try {

            $NodeId = (Get-vRANode -Name $Name).ID


            $URI = "/nodes/command/configure-hostname/node/$($NodeId)"

            
            $JSON = @"
                        {
                          "VraAddress": "$($Hostname)"
                        }
"@

            # --- Convert JSON

            $Body = $JSON | ConvertFrom-Json

            # --- Run vRA REST Request to get Appliance NodeId    

            if ($PSCmdlet.ShouldProcess($Name)){

                Invoke-vRAVAMIRestMethod -Method PUT -URI $URI -Body $Body -Verbose:$VerbosePreference | Out-Null
                
            }

        catch [Exception]{

            throw
        }
}

end {

}
}
