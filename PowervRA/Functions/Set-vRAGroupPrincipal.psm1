function Set-vRAGroupPrincipal {
<#
    .SYNOPSIS
    Update a vRA local custom group
    
    .DESCRIPTION
    Update a vRA local custom group
    
    NOTE: The API method used by this function does not update the description as suggested.    

    .PARAMETER Id
    The principal id of the user

    .PARAMETER Description
    The group description
    
    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Set-vRAGroupPrincipal -Id Group01@Tenant -Description "Description-Updated"
    
#> 
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Description

    )    

    begin {
    
    }
    
    process {

        try {
            
            foreach ($PrincipalId in $Id) {
                
                $URI = "/identity/api/tenants/$($Global:vRAConnection.Tenant)/groups/$($PrincipalId)"
                $PrincipalObject = Invoke-vRARestMethod -Method GET -URI $URI                
                
                if ($PSBoundParameters.ContainsKey("Description")) {
                    
                    Write-Verbose -Message "Updating Description: $($PrincipalObject.Description) >> $($Description)"
                    $PrincipalObject.Description = $Description                    
                                        
                }                                                                                                                   
                
                $Body = $PrincipalObject | ConvertTo-Json -Compress
                
                Write-Verbose $Body
                
                if ($PSCmdlet.ShouldProcess($PrincipalId)){

                    $URI = "/identity/api/tenants/$($PrincipalObject.Domain)/groups/$($PrincipalId)"  

                    Write-Verbose -Message "Preparing PUT to $($URI)"     

                    # --- Run vRA REST Request           
                    Invoke-vRARestMethod -Method PUT -URI $URI -Body $Body | Out-Null
                    
                    Get-vRAGroupPrincipal -Id $PrincipalId
                    
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