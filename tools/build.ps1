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
        Version = "4.9.0"
    },
    @{
        Name = "PSScriptAnalyzer"
        Version = "1.19.1"
    },
    @{
        Name = "BuildHelpers"
        Version = "2.0.15"
    },
    @{
        Name = "Pester"
        Version = "5.0.2"
    }
)

# --- Install dependencies
Write-Host "Installing required modules:"
foreach ($RequiredModule in $Requirements) {

    $ModuleParams = @{
        Name = $RequiredModule.Name
        RequiredVersion = $Module.Version
        Scope = "CurrentUser"
        Force = $True
    }

    $InstalledModule = (Get-Module -Name $RequiredModule.Name -ListAvailable)[0]

    if ($InstalledModule -and ($InstalledModule.Version -lt [Version]$RequiredModule.Version)) {
        Write-Host "    -> Updating $($RequiredModule.Name)"
        Update-Module @ModuleParams
    }

    if (!$InstalledModule) {
        Write-Host "    -> Installing $($RequiredModule.Name)"
        Install-Module @ModuleParams
    }

    Import-Module -Name $RequiredModule.Name -Force
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
