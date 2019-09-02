# --- Dot source build.settings.ps1
. $PSScriptRoot\build.settings.ps1

# --- Add any parameters from build.ps1
properties {
}

# --- Define the build tasks
Task Default -depends Build
Task Test -depends Init, Analyze, ExecuteTest
Task Build -depends Test, UpdateModuleManifest, CreateArtifact, CreateArchive
Task Init {

    Write-Output "Build System Details:"
    foreach ($Item in (Get-Item -Path ENV:BH*)){
        Write-Output "$($Item.Name): $($Item.Value)"
    }
    Write-Output "ScriptAnalyzerSeverityLevel: $($ScriptAnalysisFailBuildOnSeverityLevel)"
}

##############
# Task: Test #
##############

Task Analyze {

    $Results = Invoke-ScriptAnalyzer -Path $ENV:BHModulePath -Recurse -Settings $ScriptAnalyzerSettingsPath -Verbose
    $Results | Select-Object RuleName, Severity, ScriptName, Line, Message | Format-List

    switch ($ScriptAnalysisFailBuildOnSeverityLevel) {

        'None' {

            return

        }
        'Error' {

            Assert -conditionToCheck (
                ($Results | Where-Object Severity -eq 'Error').Count -eq 0
                ) -failureMessage 'One or more ScriptAnalyzer errors were found. Build cannot continue!'

        }
        'Warning' {

            Assert -conditionToCheck (
                ($Results | Where-Object {
                    $_.Severity -eq 'Warning' -or $_.Severity -eq 'Error'
                }).Count -eq 0) -failureMessage 'One or more ScriptAnalyzer warnings were found. Build cannot continue!'

        }
        default {

            Assert -conditionToCheck ($analysisResult.Count -eq 0) -failureMessage 'One or more ScriptAnalyzer issues were found. Build cannot continue!'

        }

    }

}

Task ExecuteTest {

    # --- Run Tests. Currently limited to help tests
    $Timestamp = Get-date -uformat "%Y%m%d-%H%M%S"
    $TestFile = "TEST_PS$PSVersion`_$TimeStamp.xml"
    $Parameters = @{
        Script = "$ENV:BHProjectPath\tests\Test000-Module.Tests.ps1"
        PassThru = $true
        OutputFormat = 'NUnitXml'
        OutputFile = "$ENV:BHProjectPath\$TestFile"
    }

    Push-Location
    Set-Location -Path $ENV:BHProjectPath
    $TestResults = Invoke-Pester @Parameters
    Pop-Location

    if ($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
}

###############
# Task: Build #
###############

Task UpdateModuleManifest {

    $PublicFunctions = Get-ChildItem -Path "$($ENV:BHModulePath)\Functions\Public" -Filter "*.ps1" -Recurse | Sort-Object

    $ExportFunctions = @()

    foreach ($FunctionFile in $PublicFunctions) {
        $AST = [System.Management.Automation.Language.Parser]::ParseFile($FunctionFile.FullName, [ref]$null, [ref]$null)
        $Functions = $AST.FindAll({
            # --- Only export functions that contain a "-" and do not start with "int"
            $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] -and `
            $args[0].Name -match "-" -and `
            !$args[0].Name.StartsWith("int")
        },$true)
        if ($Functions.Name) {
            $ExportFunctions += $Functions.Name
        }
    }

    Set-ModuleFunctions -Name $ENV:BHPSModuleManifest -FunctionsToExport $ExportFunctions -Verbose:$VerbosePreference

}

#################
# Task: Release #
#################

Task CreateArtifact {

    # --- Clean any existing directory with the same name
    If (Test-Path -Path $ReleaseDirectoryPath) {
        Remove-Item -Path $ReleaseDirectoryPath -Recurse -Force
    }

    # --- Create release directory
    Write-Output "Creating Release Directory: $ReleaseDirectoryPath"
    $null = New-Item -Path $ReleaseDirectoryPath -ItemType Directory -Force

    # --- Copy across the updated psd1 file
    Write-Output "Copying Module Manifest"
    $ModuleManifestSource = Get-Item -Path $ENV:BHPSModuleManifest
    Copy-Item -Path $ModuleManifestSource.FullName -Destination "$($ReleaseDirectoryPath)\$($ModuleName).psd1" -Force

    # --- Set the psd1 module version
    if ($ENV:TF_BUILD){
        $ModuleManifestVersion = $ENV:BUILD_BUILDNUMBER.Split("-")[0]
    }
    Update-Metadata -Path "$($ReleaseDirectoryPath)\$($ModuleName).psd1" -PropertyName ModuleVersion -Value $ModuleManifestVersion

    # --- Create an empty psm1 file
    Write-Output "Creating base PSM1 file"
    $PSM1 = New-Item -Path "$($ReleaseDirectoryPath)\$($ModuleName).psm1" -ItemType File -Force

    $PSM1Header = Get-Content -Path $PSScriptRoot\template.psm1 -Raw

    Set-Content -Path $PSM1.FullName -Value $PSM1Header -Encoding UTF8

    # --- Process Functions
    $Functions = Get-ChildItem -Path ..\src\Functions -File -Recurse
    Write-Output "Processing function:"
    foreach ($Function in $Functions) {

        Write-Output "  - $($Function.BaseName)"
        $Content = Get-Content -Path $Function.FullName -Raw
        $Definition = @"
<#
    - Function: $($Function.BaseName)
#>

$($Content)
`n
"@

        $Body += $Definition
    }

    Add-Content -Path $PSM1.FullName -Value $Body -Encoding UTF8
}

Task CreateArchive {

    $Destination = "$($ReleaseDirectoryPath).zip"

    if ($ENV:TF_BUILD){
        $Destination = "$($ReleaseDirectoryPath).$($ENV:BUILD_BUILDNUMBER).zip"
    }

    if (Test-Path -Path $Destination) {
        Remove-Item -Path $Destination -Force
    }

    Add-Type -assembly "System.IO.Compression.Filesystem"
    [IO.Compression.ZipFile]::CreateFromDirectory($ReleaseDirectoryPath, $Destination)
}

Task UpdateDocumentation {

    Write-Output "Updating Markdown help"
    $FunctionsPath = "$DocsDirectory\functions"

    Remove-Item -Path $FunctionsPath -Recurse -Force -ErrorAction SilentlyContinue
    New-Item $FunctionsPath -ItemType Directory | Out-Null

    $PlatyPSParameters = @{
        Module = $ModuleName
        OutputFolder = $FunctionsPath
        NoMetadata = $true
    }

    New-MarkdownHelp @PlatyPSParameters -ErrorAction SilentlyContinue -Verbose:$VerbosePreference | Out-Null

    # --- Ensure that index.md is present and up to date
    Write-Output "Updating index.md"
    Copy-Item -Path "$ENV:BHProjectPath\README.md" -Destination "$($DocsDirectory)\index.md" -Force -Verbose:$VerbosePreference | Out-Null

}
