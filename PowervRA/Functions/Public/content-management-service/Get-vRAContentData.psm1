function Get-vRAContentData {
<#
    .SYNOPSIS
    Get the raw data associated with vRA content
    
    .DESCRIPTION
    Get the raw data associated with vRA content

    .PARAMETER Id
    The id of the content

    .PARAMETER SecureValueFormat
    How secure data will be represented in the export

    .INPUTS
    System.String

    .OUTPUTS
    System.String

    .EXAMPLE
    Get-vRAContent -Name "Some Content" | Get-vRAContentData

    .EXAMPLE
    Get-vRAContent -Name "Some Content" | Get-vRAContentData | Out-File SomeContent.yml

#>
[CmdletBinding()][OutputType('System.String')]

    Param (
    
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [Parameter(Mandatory=$false)]
        [ValidateSet("BLANKOUT", "ENCRYPT", "DECRYPT")]
        [String]$SecureValueFormat = "BLANKOUT"

    )

    xRequires -Version 7.0

    Begin {

    }

    Process {

        try {
        
            foreach ($ContentId in $Id) {

                $URI = "/content-management-service/api/contents/$($ContentId)/data?secureValueFormat=$($SecureValueFormat)"

                $Content = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                if ($Content) {

                    Write-Output $Content

                }

            }

        }
        catch [Exception]{

            throw

        }

    }

    End {

    }

}