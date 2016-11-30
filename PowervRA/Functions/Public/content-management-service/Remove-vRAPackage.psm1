function Remove-vRAPackage {
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
    Remove-vRAPackage -Id "f8e0d99e-c567-4031-99cb-d8410c841ed7"

    .EXAMPLE
    Remove-vRAPackage -Name "Package01","Package02"
    
    .EXAMPLE
    Get-vRAPackage -Name "Package01","Package02" | Remove-vRAPackage -Confirm:$false
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

    xRequires -Version 7.0

    begin {

    }
    
    process {    

        switch ($PsCmdlet.ParameterSetName) 
        { 
            "Id"  {

                foreach ($PackageId in $Id){
                
                    try {
                        if ($PSCmdlet.ShouldProcess($PackageId)){

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

                foreach ($PackageName in $Name){
                
                    try {
                        if ($PSCmdlet.ShouldProcess($PackageName)){

                            # --- Find the Content Package
                            $Package = Get-vRAPackage -Name $PackageName
                            $Id = $Package.ID

                            $URI = "/content-management-service/api/packages/$($Id)"  

                            # --- Run vRA REST Request
                            Invoke-vRARestMethod -Method DELETE -URI $URI -Verbose:$VerbosePreference | Out-Null
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