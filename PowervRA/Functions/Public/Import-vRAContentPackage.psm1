function Import-vRAContentPackage {
<#
    .SYNOPSIS
    Imports a vRA Content Package    

    .DESCRIPTION
    Imports a vRA Content Package  

    .PARAMETER File
    The content package file

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Import-vRAContentPackage -File C:\Packages\ContentPackage100.zip

    .EXAMPLE
    Get-ChildItem -Path C:\Packages\ContentPackage100.zip| Import-vRAContentPackage -Confirm:$false

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelinebyPropertyName=$true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$File

    )

    begin {

        # --- Set Set Line Feed
        $LF = "`r`n"
   
    }

    process {

        foreach ($FilePath in $File){

            try {

                # --- Resolve the file path
                $FileInfo = [System.IO.FileInfo](Resolve-Path $FilePath).Path

                # --- Create the multi-part form
                $Boundary = [guid]::NewGuid().ToString()
                $FileBin = [System.IO.File]::ReadAllBytes($FileInfo.FullName)
                $Encoding = [System.Text.Encoding]::GetEncoding("iso-8859-1")
                $EncodedFile = $Encoding.GetString($FileBin)

                $Form = (
                    "--$($Boundary)",
                    "Content-Disposition: form-data; name=`"file`"; filename=`"$($FileInfo.Name)`"",
                    "Content-Type:application/octet-stream$($LF)",
                    $EncodedFile,
                    "--$($Boundary)--$($LF)"
                ) -join $LF

                $URI = "/content-management-service/api/packages/"

                # --- Set custom headers for the request
                $Headers = @{
                
                    "Authorization" = "Bearer $($Global:vRAConnection.Token)";
                    "Accept" = "Application/json"
                    "Accept-Encoding" = "gzip,deflate,sdch";
                    "Content-Type" = "multipart/form-data; boundary=$($Boundary)"
                }

                if ($PSCmdlet.ShouldProcess($FileInfo.FullName)){

                    # --- Run vRA REST Request
                    Write-Verbose -Message "POST : $($URI)"

                    Invoke-vRARestMethod -Method POST -Uri $URI -Body $Form -Headers $Headers -Verbose:$VerbosePreference

                    Write-Verbose -Message "SUCCESS"
                }

            }
            catch [Exception]{

                throw

            }
        }
    }

    end {

    }
}