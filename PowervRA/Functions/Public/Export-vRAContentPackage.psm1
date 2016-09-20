function Export-vRAContentPackage {
<#
    .SYNOPSIS
    Export a vRA Content Package
    
    .DESCRIPTION
    Export a vRA Content Package
    
    .PARAMETER Id
    Specify the ID of a Content Package

    .PARAMETER Name
    Specify the Name of a Content Package

    .PARAMETER File
    Specify the Filename to export to

    .INPUTS
    System.String

    .OUTPUTS
    System.IO.FileInfo
    
    .EXAMPLE
    Export-vRAContentPackage -Id "b2d72c5d-775b-400c-8d79-b2483e321bae" -File C:\Packages\ContentPackage01.zip

    .EXAMPLE
    Export-vRAContentPackage -Name "ContentPackage01" -File C:\Packages\ContentPackage01.zip

    .EXAMPLE
    Get-vRAContentPackage | Export-vRAContentPackage

    .EXAMPLE
    Get-vRAContentPackage -Name "ContentPackage01" | Export-vRAContentPackage -File C:\Packages\ContentPackage01.zip

#>
[CmdletBinding(DefaultParameterSetName="ById")][OutputType('System.IO.FileInfo')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String]$Id,         

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
        
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$File

    )

    Begin {

        # --- Test for vRA API version
        xRequires -Version 7 -Context $MyInvocation

        $Headers = @{

            "Authorization" = "Bearer $($Global:vRAConnection.Token)";
            "Accept"="application/zip";
            "Content-Type" = "Application/zip";

        }        

    }

    Process {

        try {    

            if ($PsCmdlet.ParameterSetName -eq "ByName") {

                $ContentPackage = Get-vRAContentPackage -Name $Name

                $Id = $ContentPackage.Id

            }
            else {

                $ContentPackage = Get-vRAContentPackage -Id $Id

            }

            $FileName = "$($ContentPackage.Name).zip"

            if (!$PSBoundParameters.ContainsKey("File")) {

                $File =  "$($(Get-Location).Path)\$($Filename)"

            }

            # --- Run vRA REST Request
            $URI = "/content-management-service/api/packages/$($Id)"

            #$Response = Invoke-RestMethod -Method GET -Headers $Headers -URI $FullURI -OutFile $
            Invoke-vRARestMethod -Method GET -Headers $Headers -URI $URI -OutFile $File -Verbose:$VerbosePreference

            # --- Output the result
            Get-ChildItem -Path $File

        }
        catch [Exception]{

            throw
        }

    }

}