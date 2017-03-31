#Requires -Modules Psake, Pester, PSScriptAnalyzer, PlatyPS, BuildHelpers
#Requires -Version 5

<#
    .SYNOPSIS
    A wrapper script for build.psake.ps1

    .DESCRIPTION
    This script is a wrapper for the processes defined in build.psake.ps1. For this process to be succesful the following modules are required:

    - Psake
    - Pester
    - PSScriptAnalyzer
    - PlatyPS
    - BuildHelpers

    Each task in build.psake.ps1 relies on settings provided in build.settings.ps1

    By default the build task will be executed but it is possible to select individual tasks. See the Task parameter for more information.

    .PARAMETER Task
    The build task that needs to be executed. The value of this parameter can be:

    - Build
    - PrepareRelease
    - Analyze
    - UpdateModuleManifest
    - UpdateDocumentation
    - BumpVersion
    - Test

    The default value is Build which will execute the following tasks: Analyze, UpdateModuleManifest, UpdateDocumentation

    .PARAMETER Version
    The part of the version you wish to bump for this release.

    Possible values are:

    - NONE
    - PATCH
    - MINOR
    - MAJOR

    .INPUTS
    System.String

    .OUTPUTS
    None
    
    .EXAMPLE
    .\build.ps1

    .Example 
    .\build.ps1 -Task PrepareRelease

    .Example 
    .\build.ps1 -Task Analyze

    .Example 
    .\build.ps1 -Task UpdateModuleManifest

    .Example 
    .\build.ps1 -Task UpdateDocumentation

    .Example 
    .\build.ps1 -Task BumpVersion

    .Example 
    .\build.ps1 -Task Test

#>

[Cmdletbinding()]

Param (

    [Parameter()]    
    [ValidateSet("Build", "PrepareRelease", "Analyze", "UpdateModuleManifest", "UpdateDocumentation", "UpdateChangelog", "IncrementVersion", "Test")]
    [String]$Task,

    [Parameter()]
    [ValidateSet("PATCH", "MINOR", "MAJOR")]
    [String]$Increment

)

# --- Set Build Environment
Set-BuildEnvironment

# --- Set Psake parameters
$PsakeBuildParameters = @{
    BuildFile = "$($PSScriptRoot)\build.psake.ps1"
    TaskList = $Task 
    Parameters = @{"Increment"= $Increment} 
    Nologo = $true   
}

# --- Determine the state of the build script
if ($ENV:BHBuildSystem -eq "github") {

    Switch -Regex ($ENV:BHCommitMessage) {

        "\[Build\]" {
            Write-Output "Build Phase: [Build]"
            $PsakeBuildParameters.TaskList = "Build"
            break
        }      
        "\[Build\.Major\]" {
            Write-Output "Build Phase: [Build.Major]"
            $PsakeBuildParameters.TaskList = "Build"
            $PsakeBuildParameters.Parameters.Increment = "Major"
            break
        }
        "\[Build\.Minor\]" {
            Write-Output "Build Phase: [Build.Minor]"            
            $PsakeBuildParameters.TaskList = "Build"            
            $PsakeBuildParameters.Parameters.Increment = "Minor"
            break
        }       
        "\[Build\.Patch\]" {
            Write-Output "Build Phase: [Build.Patch]"            
            $PsakeBuildParameters.TaskList = "Build"            
            $PsakeBuildParameters.Parameters.Increment = "Patch"
            break
        }
        "\[Release\]" {
            $PsakeBuildParameters.TaskList = "Release"            
            break
        }
        default {
            Write-Output "Trigger not found in commit message, continuing with default task"
        }
    }
}

# --- Start Build
Invoke-Psake @PsakeBuildParameters -Verbose:$VerbosePreference
exit ( [int]( -not $psake.build_success ) )