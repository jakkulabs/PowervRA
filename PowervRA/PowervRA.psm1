# --- Expose each Public and Private function as part of the module
foreach ($PrivateFunction in Get-ChildItem -Path "$($PSScriptRoot)\Functions\Private\*.ps1" -Recurse -Verbose:$VerbosePreference) {

    . $PrivateFunction.FullName
}

foreach ($Publicfunction in Get-ChildItem -Path "$($PSScriptRoot)\Functions\Public\*.ps1" -Recurse -Verbose:$VerbosePreference) {

    . $PublicFunction.FullName

    $BaseName = [System.IO.Path]::GetFileNameWithoutExtension($PublicFunction)
    
    # --- Support DEPRECATED functions. Ensure that we are exporting only the function name
    $DepricatedKeyword = "DEPRECATED-"
    if ($BaseName.StartsWith($DepricatedKeyword)) {

        $BaseName = $BaseName.Trim($DepricatedKeyword)
    }

    Export-ModuleMember -Function ($BaseName)
}

# --- Clean up variables on module removal
$ExecutionContext.SessionState.Module.OnRemove = {

    Remove-Variable -Name vRAConnection -Force -ErrorAction SilentlyContinue

}