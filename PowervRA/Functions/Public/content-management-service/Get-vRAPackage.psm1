function Get-vRAPackage {
<#
    .SYNOPSIS
    Retrieve vRA Packages
    
    .DESCRIPTION
    Retrieve vRA Packages
    
    .PARAMETER Id
    Specify the ID of a Package

    .PARAMETER Name
    Specify the Name of a Package

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100

    .PARAMETER Page
    The index of the page to display.

    .INPUTS
    System.String
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAPackage
    
    .EXAMPLE
    Get-vRAPackage -Id "b2d72c5d-775b-400c-8d79-b2483e321bae"

    .EXAMPLE
    Get-vRAPackage -Name "ContentPackage01","ContentPackage02"
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,         

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,
        
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100

    )

    # --- Test for vRA API version
    xRequires -Version 7.0
    
    try {                
        switch ($PsCmdlet.ParameterSetName) 
        { 
            "ById"  {                
                
                foreach ($PackageId in $Id){

                    $URI = "/content-management-service/api/packages/$($PackageId)"

                    # --- Run vRA REST Request
                    $Package = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference    
                    
                    [PSCustomobject]@{

                        Name = $Package.name
                        Id = $Package.id                
                        Description = $Package.description
                        TenantId = $Package.tenantId
                        SubtenantId = $Package.subtenantId
                        Contents = $Package.contents
                        CreatedDate = $Package.createdDate
                        LastUpdated = $Package.lastUpdated
                        version = $Package.version
                    }
                }                              
            
                break
            }

            "ByName"  {                

               foreach ($PackageName in $Name){

                    $URI = "/content-management-service/api/packages?`$filter=name eq '$($PackageName)'"

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference
                    
                    if (-not $Response.content){
                    
                        throw "Unable to retrieve Package with Name $($Name)"
                    }                  

                    foreach ($Package in $Response.content){

                        [PSCustomobject]@{

                            Name = $Package.name
                            Id = $Package.id                
                            Description = $Package.description
                            TenantId = $Package.tenantId
                            SubtenantId = $Package.subtenantId
                            Contents = $Package.contents
                            CreatedDate = $Package.createdDate
                            LastUpdated = $Package.lastUpdated
                            version = $Package.version
                        }
                    }
                }  
                
                break
            }

            "Standard"  {

                $URI = "/content-management-service/api/packages?limit=$($Limit)&page=$($Page)&`$orderby=name asc"

                $EscapedURI = [uri]::EscapeUriString($URI)

                $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                foreach ($Package in $Response.content){

                    [PSCustomobject]@{

                        Name = $Package.name
                        Id = $Package.id                
                        Description = $Package.description
                        TenantId = $Package.tenantId
                        SubtenantId = $Package.subtenantId
                        Contents = $Package.contents
                        CreatedDate = $Package.createdDate
                        LastUpdated = $Package.lastUpdated
                        version = $Package.version
                    }
                }

                Write-Verbose -Message "Total: $($Response.metadata.totalElements) | Page: $($Response.metadata.number) of $($Response.metadata.totalPages) | Size: $($Response.metadata.size)"
                
                break
            }
        }
    }
    catch [Exception]{

        throw
    }
}