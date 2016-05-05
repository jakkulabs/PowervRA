function Remove-vRAContentPackage {
<#
    .SYNOPSIS
    Remove a vRA Content Package
    
    .DESCRIPTION
    Remove a vRA Content Package

    .PARAMETER Id
    Content Package Id

    .PARAMETER Name
    Content Package Name

    .INPUTS
    System.String.

    .OUTPUTS
    None

    .EXAMPLE
    Remove-vRAContentPackage -Id "f8e0d99e-c567-4031-99cb-d8410c841ed7"

    .EXAMPLE
    Remove-vRAContentPackage -Name "ContentPackage01","ContentPackage02"
    
    .EXAMPLE
    Get-vRAContentPackage -Name "ContentPackage01","ContentPackage02" | Remove-vRAContentPackage -Confirm:$false
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="Id")]

    Param (

    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="Id")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,

    [parameter(Mandatory=$true,ParameterSetName="Name")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name
    )    

    begin {
    
    }
    
    process {    

        switch ($PsCmdlet.ParameterSetName) 
        { 
            "Id"  {

                foreach ($ContentPackageId in $Id){
                
                    try {
                        if ($PSCmdlet.ShouldProcess($ContentPackageId)){

                            $URI = "/content-management-service/api/packages/$($id)"  

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

                foreach ($ContentPackageName in $Name){
                
                    try {
                        if ($PSCmdlet.ShouldProcess($ContentPackageName)){

                            # --- Find the Content Package
                            $ContentPackage = Get-vRAContentPackage -Name $ContentPackageName
                            $Id = $ContentPackage.ID

                            $URI = "/content-management-service/api/packages/$($Id)"  

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