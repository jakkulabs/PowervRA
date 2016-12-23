# Expose each Public and Private function as part of the module
foreach ($privateScript in Get-ChildItem -Path "$($PSScriptRoot)\Functions\Private\*.ps1" -Recurse -Verbose:$VerbosePreference) {

    . $privateScript.FullName
}

foreach ($publicfunction in Get-ChildItem -Path "$($PSScriptRoot)\Functions\Public\*.ps1" -Recurse -Verbose:$VerbosePreference) {

    . $publicFunction.FullName
    Export-ModuleMember -Function ([System.IO.Path]::GetFileNameWithoutExtension($publicFunction))
}