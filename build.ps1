#Requires -Modules Psake, Pester, PSScriptAnalyzer
#Requires -RunAsAdministrator

<#
  .SYNOPSIS
  Wrapper for PSake build file
  Resolve-Module borrowed from https://github.com/stefanstranger/Wunderlist/blob/master/build.ps1
#>

[Cmdletbinding()]

Param (

    [Parameter(Mandatory=$false)]
    [ValidateSet('Build','Release')]
    [String]$Task = 'Build',

    [Parameter(Mandatory=$false, ParameterSetName="BumptVersion")]
    [ValidateNotNullOrEmpty]
    [Switch]$BumpVersion, 

    [Parameter(Mandatory=$false, ParameterSetName="BumptVersion")]
    [ValidateSet('Major','Minor','Patch')]
    [String]$BuildVersion = 'Patch'

)

# --- Build Parameters
$Parameters = @{

    BaseDirectory = $PSScriptRoot
    BinDirectory = "$($BaseDirectory)\bin"
    ModulePath = "$($BaseDirectory)\PowervRA"
    ModuleManifest = "$($ModulePath)\PowervRA.psd1"
    BuildVersion = $BuildVersion

}

Write-Verbose -Message $Parameters

$LocalDependencies = @(

    "$($BinDirectory)\Update-MKDocsYML.psm1",
    "$($BinDirectory)\Update-ModuleDocumentation.psm1",
    "$($BinDirectory)\Update-ModuleManifestVersion.psm1",
    "$($BinDirectory)\Update-ModuleManifestFunctions.psm1"

)

$LocalDependencies | % {Import-Module -Name $_ -Force}

# --- Start Build
Invoke-psake -buildFile "$($PSScriptRoot)\bin\psake.build.ps1" -taskList $Task -parameters $Parameters -nologo -Verbose:$VerbosePreference

exit ( [int]( -not $psake.build_success ) )