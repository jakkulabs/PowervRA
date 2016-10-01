function Update-MKDocsYML {
<#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .PARAMETER Module

    .PARAMETER Path

    .INPUTS
    System.String

    .OUTPUTS
    None

#>
[CmdletBinding(DefaultParameterSetName="Standard")]

    Param (

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Module,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Path

    )

    try {

        $ModuleObject = Import-Module -Name $Module -PassThru -Force
        
        if (!(Test-Path -Path $Path)) {
            
            Write-Verbose -Message "Creating MKDocs.yml"
            
            New-Item -Path $Path -ItemType File -Force | Out-Null           

        }
        
        $Functions = $ModuleObject.ExportedCommands.Keys | % {"    - $($_) : $($_).md"}
        
        $ModuleName = ($ModuleObject | Where-Object {$_.ModuleType -eq "Manifest"}).Name

        $Template = @"
---

site_name: $($ModuleName)
pages:
- 'Home' : 'index.md'
- 'Functions': 
$($Functions -join "`r`n")
"@

        $Template | Out-File -FilePath $Path -Force

    }
    catch [Exception]{

        throw
    }
    
}