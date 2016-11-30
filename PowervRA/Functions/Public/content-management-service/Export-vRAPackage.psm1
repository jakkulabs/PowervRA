function Export-vRAPackage {
<#
    .SYNOPSIS
    Export a vRA Package
    
    .DESCRIPTION
    Export a vRA Package
    
    .PARAMETER Id
    Specify the ID of a Package

    .PARAMETER Name
    Specify the Name of a Package

    .PARAMETER Path
    The resulting path. If this parameter is not passed the action will be exported to
    the current working directory.

    .INPUTS
    System.String

    .OUTPUTS
    System.IO.FileInfo
    
    .EXAMPLE
    Export-vRAPackage -Id "b2d72c5d-775b-400c-8d79-b2483e321bae" -Path C:\Packages\Package01.zip

    .EXAMPLE
    Export-vRAPackage -Name "Package01" -Path C:\Packages\Package01.zip

    .EXAMPLE
    Get-vRAPackage | Export-vRAPackage

    .EXAMPLE
    Get-vRAPackage -Name "Package01" | Export-vRAPackage -Path C:\Packages\Package01.zip

#>
[CmdletBinding(DefaultParameterSetName="ById")][OutputType('System.IO.FileInfo')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,         

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,
        
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Path

    )

    # --- Test for vRA API version
    xRequires -Version 7.0

    Begin {

        function internalWorkings ($InternalPackage, $InternalId, $InternalPath) {
            
            $Headers = @{

                "Authorization" = "Bearer $($Global:vRAConnection.Token)";
                "Accept"="application/zip";
                "Content-Type" = "Application/zip";

            }
            
            $FileName = "$($InternalPackage.Name).zip"

            if (!$InternalPath) {

                Write-Verbose -Message "Path parameter not passed, exporting to current directory."
                $FullPath = "$($(Get-Location).Path)\$($FileName)"

            }
            else {

                Write-Verbose -Message "Path parameter passed."
                
                if ($InternalPath.EndsWith("\")) {

                    Write-Verbose -Message "Ends with"

                    $InternalPath = $InternalPath.TrimEnd("\")

                }
                
                $FullPath = "$($InternalPath)\$($FileName)"
            }

            # --- Run vRA REST Request
            $URI = "/content-management-service/api/packages/$($InternalId)"

            Invoke-vRARestMethod -Method GET -Headers $Headers -URI $URI -OutFile $FullPath -Verbose:$VerbosePreference

            # --- Output the result
            Get-ChildItem -Path $FullPath
        }
    }

    Process {

        try {    

            switch ($PsCmdlet.ParameterSetName) {
            
                'ByName' {

                    foreach ($PackageName in $Name) {

                        $Package = Get-vRAPackage -Name $PackageName
                        $Id = $Package.Id

                        internalWorkings -InternalPackage $Package -InternalId $Id -InternalPath $Path                   
                    }
                }
                'ById' {

                    foreach ($PackageId in $Id){

                        $Package = Get-vRAPackage -Id $PackageId

                        internalWorkings -InternalPackage $Package -InternalId $PackageId -InternalPath $Path
                    }
                }
            }
        }
        catch [Exception]{

            throw
        }
    }
}