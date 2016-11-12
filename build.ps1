#Requires -Modules Psake, Pester, PSScriptAnalyzer, PlatyPS
#Requires -Version 5

[Cmdletbinding()]

Param (

    [Parameter(Mandatory=$false)]
    [String]$Task = 'Build',

    [Parameter(Mandatory=$false, ParameterSetName="BumptVersion")]
    [ValidateNotNullOrEmpty]
    [Switch]$BumpVersion, 

    [Parameter(Mandatory=$false, ParameterSetName="BumptVersion")]
    [ValidateSet('Major','Minor','Patch')]
    [String]$BuildVersion = 'Patch'

)

# --- Import local depenencies
Import-Module -Name "$($PSScriptRoot)\BuildHelpers\Update-ModuleManifestVersion.psm1"

# --- Start Build
Invoke-psake -buildFile "$($PSScriptRoot)\build.psake.ps1" -taskList $Task -parameters $Parameters -nologo -Verbose:$VerbosePreference

exit ( [int]( -not $psake.build_success ) )