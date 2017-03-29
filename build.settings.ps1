##########################
# PSake build properties #
##########################

Properties {

# ----------------------- Basic properties --------------------------------

    $RepoUrl = "https://github.com/jakkulabs/PowervRA"
    $ModuleAuthor = "JakkuLabs"
    $ModuleDirectory = "$($PSScriptRoot)\PowervRA"

    $ModuleName = Get-Item $ModuleDirectory/*.psd1 |
                      Where-Object { $null -ne (Test-ModuleManifest -Path $_ -ErrorAction SilentlyContinue) } |
                      Select-Object -First 1 | Foreach-Object BaseName

    $ModuleManifestPath = "$($ModuleDirectory)\$($ModuleName).psd1"    

    $DocsDirectory = "$PSScriptRoot\docs"

    $TestDirectory = "$PSScriptRoot\tests"

    $DefaultLocale = "en-US"

    [ValidateSet('Error', 'Warning', 'Any', 'None')]
    $ScriptAnalysisFailBuildOnSeverityLevel = 'Warning'

    # Path to the PSScriptAnalyzer settings file.
    $ScriptAnalyzerSettingsPath = "$PSScriptRoot\PSScriptAnalyzerSettings.psd1"

}