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

$ErrorActionPreference = "Stop"

Set-StrictMode -Version 3.0

$Requirements = @(
    @{
        Name = "PSake"
        Version = "4.9.0"
    },
    @{
        Name = "PSScriptAnalyzer"
        Version = "1.20.0"
    },
    @{
        Name = "BuildHelpers"
        Version = "2.0.16"
    },
    @{
        Name = "Pester"
        Version = "5.3.1"
    },
    @{
        Name = "platyPS"
        Version = "0.14.2"
    }
)

# --- Configure default PowerShell Gallery Repository if not present
if (-not (Get-PSRepository)){

    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

# --- Install dependencies
Write-Host "Installing required modules:"
foreach ($RequiredModule in $Requirements) {

    $ModuleParams = @{
        Name = $RequiredModule.Name
        RequiredVersion = $RequiredModule.Version
        Scope = "CurrentUser"
        Force = $True
    }

    $InstalledModule = Get-Module -Name $RequiredModule.Name -ListAvailable

    # Update module if installed version is lower than required version
    if ($InstalledModule -and ($InstalledModule[0].Version -lt [Version]$RequiredModule.Version)) {
        Write-Host "    -> Updating $($RequiredModule.Name)"
        Update-Module @ModuleParams
    }

    # Install module if installed version is greater than required version
    if ($InstalledModule -and ($InstalledModule[0].Version -gt [Version]$RequiredModule.Version)) {
        Write-Host "    -> Installing required version of $($RequiredModule.Name)"
        Install-Module @ModuleParams
    }

    # Install module if not present
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
