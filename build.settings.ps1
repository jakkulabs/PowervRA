##########################
# PSake build properties #
##########################

Properties {

# ----------------- General -------------------------------------
    $DocsDirectory = "$ENV:BHProjectPath\docs"

# ----------------- Script Analyzer ------------------------------
    [ValidateSet('Error', 'Warning', 'Any', 'None')]
    $ScriptAnalysisFailBuildOnSeverityLevel = 'Warning'
    $ScriptAnalyzerSettingsPath = "$PSScriptRoot\PSScriptAnalyzerSettings.psd1"

# ----------------- MKdocs ---------------------------------------
    $RepoUrl = "https://github.com/jakkulabs/PowervRA"
    $ModuleAuthor = "JakkuLabs"
    $ModuleName = "PowervRA"

}