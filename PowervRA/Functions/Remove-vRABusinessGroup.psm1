function Remove-vRABusinessGroup {
<#
    .SYNOPSIS
    Remove a vRA Business Group
    
    .DESCRIPTION
    Remove a vRA Business Group
    
    .PARAMETER TenantId
    Tenant Id

    .PARAMETER Id
    Business Group Id

    .PARAMETER Name
    Business Group Name

    .INPUTS
    System.String.

    .OUTPUTS
    None

    .EXAMPLE
    Remove-vRABusinessGroup -TenantId Tenant01 -Id "f8e0d99e-c567-4031-99cb-d8410c841ed7"

    .EXAMPLE
    Remove-vRABusinessGroup -TenantId Tenant01 -Name "BusinessGroup01","BusinessGroup02"
    
    .EXAMPLE
    Get-vRABusinessGroup -TenantId Tenant01 -Name BusinessGroup01 | Remove-vRABusinessGroup -Confirm:$false
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="Id")]

    Param (

    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNullOrEmpty()]
    [Alias(“Tenant”)]
    [String]$TenantId,

    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="Id")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,

    [parameter(Mandatory=$true,ParameterSetName="Name")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name
    )    

    begin {
        # --- Test for vRA API version
        if (-not $Global:vRAConnection){

            throw "vRA Connection variable does not exist. Please run Connect-vRAServer first to create it"
        }
        elseif ($Global:vRAConnection.APIVersion -lt 7){

            throw "$($MyInvocation.MyCommand) is not supported with vRA API version $($Global:vRAConnection.APIVersion)"
        }  
    }
    
    process {    

        switch ($PsCmdlet.ParameterSetName) 
        { 
            "Id"  {

                foreach ($BusinessGroupId in $Id){
                
                    try {
                        if ($PSCmdlet.ShouldProcess($BusinessGroupId)){

                            $URI = "/identity/api/tenants/$($TenantId)/subtenants/$($id)"  

                            # --- Run vRA REST Request
                            $Response = Invoke-vRARestMethod -Method DELETE -URI $URI
                        }
                    }
                    catch [Exception]{

                        throw
                    } 
                }                
            
                break
            }

            "Name"  {

                foreach ($BusinessGroupName in $Name){
                
                    try {
                        if ($PSCmdlet.ShouldProcess($BusinessGroupName)){

                            # --- Find the Business Group
                            $BusinessGroup = Get-vRABusinessGroup -TenantId $TenantId -Name $BusinessGroupName
                            $Id = $BusinessGroup.ID

                            $URI = "/identity/api/tenants/$($TenantId)/subtenants/$($Id)"  

                            # --- Run vRA REST Request
                            $Response = Invoke-vRARestMethod -Method DELETE -URI $URI
                        }
                    }
                    catch [Exception]{

                        throw
                    } 
                }
                
                break
            } 
        }             
    }
    end {
        
    }
}