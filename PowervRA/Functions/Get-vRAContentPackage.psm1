function Get-vRAContentPackage {
<#
    .SYNOPSIS
    Retrieve vRA Content Packages
    
    .DESCRIPTION
    Retrieve vRA Content Packages
    
    .PARAMETER Id
    Specify the ID of a Content Package

    .PARAMETER Name
    Specify the Name of a Content Package

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAContentPackage
    
    .EXAMPLE
    Get-vRAContentPackage -Id "b2d72c5d-775b-400c-8d79-b2483e321bae"

    .EXAMPLE
    Get-vRAContentPackage -Name "ContentPackage01","ContentPackage02"
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,         

    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name,
    
    [parameter(Mandatory=$false,ValueFromPipeline=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100" 
    )

    try {                
        switch ($PsCmdlet.ParameterSetName) 
        { 
            "ById"  {                
                
                foreach ($ContentPackageId in $Id){

                    $URI = "/content-management-service/api/packages/$($ContentPackageId)"

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI
                    
                    if (-not $Response){
                    
                        throw "Unable to retrieve Content Package with Id $($Id)"
                    }              
                    
                    [pscustomobject]@{

                        Name = $Response.name
                        Id = $Response.id                
                        Description = $Response.description
                        TenantId = $Response.tenantId
                        SubtenantId = $Response.subtenantId
                        Contents = $Response.contents
                        CreatedDate = $Response.createdDate
                        LastUpdated = $Response.lastUpdated
                        version = $Response.version
                    }
                }                              
            
                break
            }

            "ByName"  {                

               foreach ($ContentPackageName in $Name){

                    $URI = "/content-management-service/api/packages?`$filter=name%20eq%20'$($ContentPackageName)'"

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI
                    
                    if (-not $Response.content){
                    
                        throw "Unable to retrieve Content Package with Name $($Name)"
                    }                  

                    foreach ($ContentPackage in $Response.content){

                        [pscustomobject]@{

                            Name = $ContentPackage.name
                            Id = $ContentPackage.id                
                            Description = $ContentPackage.description
                            TenantId = $ContentPackage.tenantId
                            SubtenantId = $ContentPackage.subtenantId
                            Contents = $ContentPackage.contents
                            CreatedDate = $ContentPackage.createdDate
                            LastUpdated = $ContentPackage.lastUpdated
                            version = $ContentPackage.version
                        }
                    }
                }  
                
                break
            }

            "Standard"  {

                $URI = "/content-management-service/api/packages"

                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method GET -URI $URI

                $ContentPackages = $Response.content

                foreach ($ContentPackage in $ContentPackages){

                    [pscustomobject]@{

                        Name = $ContentPackage.name
                        Id = $ContentPackage.id                
                        Description = $ContentPackage.description
                        TenantId = $ContentPackage.tenantId
                        SubtenantId = $ContentPackage.subtenantId
                        Contents = $ContentPackage.contents
                        CreatedDate = $ContentPackage.createdDate
                        LastUpdated = $ContentPackage.lastUpdated
                        version = $ContentPackage.version
                    }
                }
                
                break
            }
        }
    }
    catch [Exception]{

        throw
    }
}