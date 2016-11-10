#Requires -Modules Psake, Pester, PSScriptAnalyzer, PlatyPS
#Requires -Version 5

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

$LocalDependencies = @(

    "$($PSScriptRoot)\bin\Update-MKDocsYML.psm1",
    "$($PSScriptRoot)\bin\Update-ModuleManifestVersion.psm1"

)

$LocalDependencies | % {Import-Module -Name $_ -Force}

# --- Start Build
Invoke-psake -buildFile "$($PSScriptRoot)\build.psake.ps1" -taskList $Task -parameters $Parameters -nologo -Verbose:$VerbosePreference

exit ( [int]( -not $psake.build_success ) )