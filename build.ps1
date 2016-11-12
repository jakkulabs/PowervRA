#Requires -Modules Psake, Pester, PSScriptAnalyzer, PlatyPS
#Requires -Version 5

[Cmdletbinding()]

Param (

    [Parameter(Mandatory=$false)]
    [String]$Task = 'Build'

)

# --- Start Build
Invoke-psake -buildFile "$($PSScriptRoot)\build.psake.ps1" -taskList $Task -nologo -Verbose:$VerbosePreference

exit ( [int]( -not $psake.build_success ) )