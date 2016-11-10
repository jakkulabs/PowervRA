##########################
# PSake build properties #
##########################

Properties {

# ----------------------- Basic properties --------------------------------

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ModuleDirectory = "$($PSScriptRoot)\PowervRA"

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ModuleManifest = "$($ModuleDirectory)\PowervRA.psd1"    

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ModuleName = Get-Item $ModuleDirectory/*.psd1 |
                      Where-Object { $null -ne (Test-ModuleManifest -Path $_ -ErrorAction SilentlyContinue) } |
                      Select-Object -First 1 | Foreach-Object BaseName

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $DocsDirectory = "$PSScriptRoot\docs"

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $TestDirectory = "$PSScriptRoot\tests"

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $BinDirectory = "$($PSScriptRoot)\bin"

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $DefaultLocale = "en-US"

# ------------------ Script analysis properties ---------------------------

    # Enable/disable use of PSScriptAnalyzer to perform script analysis.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ScriptAnalysisEnabled = $true

    # When PSScriptAnalyzer is enabled, control which severity level will generate a build failure.
    # Valid values are Error, Warning, Information and None.  "None" will report errors but will not
    # cause a build failure.  "Error" will fail the build only on diagnostic records that are of
    # severity error.  "Warning" will fail the build on Warning and Error diagnostic records.
    # "Any" will fail the build on any diagnostic record, regardless of severity.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    [ValidateSet('Error', 'Warning', 'Any', 'None')]
    $ScriptAnalysisFailBuildOnSeverityLevel = 'Error'

    # Path to the PSScriptAnalyzer settings file.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ScriptAnalyzerSettingsPath = "$PSScriptRoot\PSScriptAnalyzerSettings.psd1"    
    
}