##########################
# PSake build properties #
##########################

Properties {

# ----------------- General -------------------------------------
    $DocsDirectory = "$ENV:BHProjectPath\docs"
    [ValidateSet('Error', 'Warning', 'Any', 'None')]

# ----------------- Script Analyzer ------------------------------
    $ScriptAnalysisFailBuildOnSeverityLevel = 'Error'
    $ScriptAnalyzerSettingsPath = "$PSScriptRoot\PSScriptAnalyzerSettings.psd1"

# ----------------- MKdocs ---------------------------------------
    $RepoUrl = "https://github.com/jakkulabs/PowervRA"
    $ModuleAuthor = "JakkuLabs"
    $ModuleName = "PowervRA"

}