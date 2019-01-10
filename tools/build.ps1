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
    [ValidateSet("Test", "Analyze", "Build", "UpdateModuleManifest", "UpdateDocumentation")]
    [String]$Task
)

# --- Install dependencies
$RequiredModules = @("Psake", "PSScriptAnalyzer")
foreach ($Module in $RequiredModules) {
    if (!(Get-Module -Name $Module -ListAvailable)){
        Install-Module -Name $Module -Scope CurrentUser -Force        
    }
}

# --- Install build helpers separately to avoid current module errors
Install-Module -Name "BuildHelpers" -RequiredVersion 2.0.1 -Scope CurrentUser -Force        

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