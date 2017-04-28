function Get-vRANode {
<#
    .SYNOPSIS
    List all vRA nodes registered to the appliance.
    
    .DESCRIPTION
    List all vRA nodes registered to the appliance.

    .PARAMETER Name
    The name of the node.

    .PARAMETER Role
    The roles installed on the node.
    
    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE 
    Get-vRANode -Name vra-01a.lab.local,web-01a.lab.local

    .EXAMPLE
    Get-vRANode -Role Website

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (
    
    [parameter(Mandatory=$false,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name,
    
    [parameter(Mandatory=$false,ParameterSetName="ByRole")]
    [ValidateSet("vRA","vRO","Database","Website","ModelManagerData","ModelManagerWeb","WAPI","ManagerService","DemOrchestrator","DemWorker","vSphereAgent")]
    [String]$Role
       
    )   

begin {

}

process {   
        try {

            switch ($PsCmdlet.ParameterSetName) {
            
                'ByName' {      

                    foreach ($NodeName in $Name) {    

                        $URI = "/nodes/list?json=true&components=true"

                        # --- Run vRA REST Request
                        $Response = Invoke-vRAVAMIRestMethod -Method GET -URI $URI -Verbose:$VerbosePreference | ConvertFrom-Json

                        $Node = $Response | Where-Object { $_.nodeHost -eq $NodeName }
                    
                        if (!$Node) { 
                        
                            throw "Unable to find node $($NodeName)." 
                    
                        }

                        [pscustomobject]@{

                            Name = $Node.NodeHost
                            ID = $Node.NodeId
                            Role = $Node.components.NodeType
                            Version = $Node.components.version
                            
                        }

                    }
  
                }

                'ByRole' {            
                    $URI = "/nodes/list?json=true&components=true"

                    # --- Run vRA REST Request
                    $Response = Invoke-vRAVAMIRestMethod -Method GET -URI $URI -Verbose:$VerbosePreference | ConvertFrom-Json

                    $Nodes = $Response | Where-Object { $_.components.NodeType -contains $Role }
                
                        if (!$Nodes) {
                            
                            throw "Unable to find node with role $($NodeRole)"

                            } else {

                                foreach ($Node in $Nodes) {
                            
                                    [pscustomobject]@{

                                        Name = $Node.NodeHost
                                        ID = $Node.NodeId
                                        Role = $Node.components.NodeType
                                        Version = $Node.components.version

                                    }
                
                        }

                     }
  
                }
                
                'Standard' {
                    $URI = "/nodes/list?json=true&components=true"

                    # --- Run vRA REST Request
                    $Response = Invoke-vRAVAMIRestMethod -Method GET -URI $URI -Verbose:$VerbosePreference | ConvertFrom-Json
            
                    foreach ($Node in $Response) { 
                   
                        [pscustomobject]@{

                            Name = $Node.nodeHost
                            ID = $Node.nodeId
                            Role = $Node.components.nodeType
                            Version = $Node.components.version
                        
                        }

                    }   
                
                }
            }
                
                
        }

        catch [Exception]{

            throw
        }
}

end {

}
}
