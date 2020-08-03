#Requires -Version 5

<#
    .SYNOPSIS
    A wrapper script for build.psake.ps1

    .DESCRIPTION
    This script is a wrapper for the processes defined in build.ps
    ake.ps1.

    .PARAMETER Task
    The build task that needs to be executed.

    .INPUTS
    System.String

    .OUTPUTS
    None

    .EXAMPLE
    .\build.ps1

    .Example
    .\build.ps1 -Task Build
#>

[Cmdletbinding()]
Param (
    [Parameter()]
    [ValidateSet("BuildWithTests", "Build", "UpdateModuleManifest", "UpdateDocumentation")]
    [String]$Task
)

$Requirements = @(
    @{
        Name = "PSake"
        Version = 4.9.0
    },
    @{
        Name = "PSScriptAnalyzer"
        Version = 1.19.1
    },
    @{
        Name = "BuildHelpers"
        Version = 2.0.15
    },
    @{
        Name = "Pester"
        Version = 5.0.2
    }
)

# --- Install dependencies
Write-Host "Installing required modules:"
foreach ($Module in $Requirements) {

    $ModuleParams = @{
        Name = $Module.Name
        RequiredVersion = $Module.Version
        Scope = "CurrentUser"
    }

    if (Get-Module -Name $Module.Name -ListAvailable) {
        Write-Host "    -> Updating $($Module.Name)"
        Update-Module @ModuleParams
    } else {
        Write-Host "    -> Installing $($Module.Name)"
        Install-Module @ModuleParams
    }

    Import-Module -Name $Module.Name -Force
}

# --- Set Build Environment
Set-BuildEnvironment -Force

# --- Set Psake parameters
$PsakeBuildParameters = @{
    BuildFile = "$($PSScriptRoot)\build.psake.ps1"

    TaskList = $Task
    Nologo = $true
}

# --- Start Build
Invoke-Psake @PsakeBuildParameters -Verbose:$VerbosePreference
exit ([int](-not $psake.build_success))
