# --- Dot source build.settings.ps1
. $PSScriptRoot\build.settings.ps1

# --- Define the build tasks
Task Default -depends Build
Task Build -depends Analyze, UpdateModuleManifest, UpdateDocumentation
Task Release -depends Build, BumpVersion

Task Analyze {

    $Results = Invoke-ScriptAnalyzer -Path $ModuleDirectory -Recurse  -Settings $ScriptAnalyzerSettingsPath -Verbose:$VerbosePreference
    $Results | Format-Table

    switch ($ScriptAnalysisFailBuildOnSeverityLevel) {

        'None' {

            return

        }
        'Error' {

            Assert -conditionToCheck (
                ($analysisResult | Where-Object Severity -eq 'Error').Count -eq 0
                ) -failureMessage 'One or more ScriptAnalyzer errors were found. Build cannot continue!'
                
        }
        'Warning' {

            Assert -conditionToCheck (
                ($analysisResult | Where-Object {
                    $_.Severity -eq 'Warning' -or $_.Severity -eq 'Error'
                }).Count -eq 0) -failureMessage 'One or more ScriptAnalyzer warnings were found. Build cannot continue!'

        }
        default {

            Assert -conditionToCheck ($analysisResult.Count -eq 0) -failureMessage 'One or more ScriptAnalyzer issues were found. Build cannot continue!'

        }

    }

}

Task UpdateModuleManifest {

    try {

        Update-ModuleManifestFunctions -Path $ModuleManifest -Verbose:$VerbosePreference

    }
    catch [System.Exception] {

        Write-Error -Message "An error occured when updating manifest functions: $_.Message"

    }

}

Task UpdateDocumentation {

    $ModuleInfo = Import-Module $ModuleDirectory\$ModuleName.psd1 -Global -Force -PassThru

    if ($ModuleInfo.ExportedCommands.Count -eq 0) {
        "No commands have been exported. Skipping $($psake.context.currentTaskName) task."
        return
    }

    if (!(Test-Path -LiteralPath $DocsDirectory)) {
        New-Item $DocsDirectory -ItemType Directory | Out-Null
    }

    if (Get-ChildItem -LiteralPath $DocsDirectory -Filter *.md -Recurse) {
        Get-ChildItem -LiteralPath $DocsDirectory -Directory | ForEach-Object {
            Update-MarkdownHelp -Path $_.FullName -Verbose:$VerbosePreference | Out-Null
        }
    }

    # --- ErrorAction set to SilentlyContinue so this command will not overwrite an existing MD file.
    New-MarkdownHelp -Module $ModuleName -Locale $DefaultLocale -OutputFolder $DocsDirectory `
                    -ErrorAction SilentlyContinue -Verbose:$VerbosePreference | Out-Null

    # --- Update mkdocs.yml
    Update-MKDocsYML -Module $ModuleManifest -Path "$($PSScriptRoot)\mkdocs.yml" -Verbose:$VerbosePreference

}

Task BumpVersion {

    switch ($BuildVersion) {

        'Major' {

            Update-ModuleManifestVersion -Path $ModuleManifest -Major -Confirm:$false

            break
        }

        'Minor' {

            Update-ModuleManifestVersion -Path $ModuleManifest -Minor -Confirm:$false

            break

        }

        'Patch' {

            Update-ModuleManifestVersion -Path $ModuleManifest -Patch -Confirm:$false

            break

        }

    }

}

Task Test {

    $ResultsFile = "$($BinDirectory)\Pester.Results-$(Get-Date -Format ddMMyyyHHMMSS).json"
    Set-Location -Path $PSScriptRoot
    $Result = Invoke-Pester -Verbose:$VerbosePreference -PassThru

    if ($Result) {

        $Result | ConvertTo-Json -Depth 100 | Out-File -FilePath $ResultsFile
        Write-Error -Message "Pester Tests Failed. See $($ResultsFile) for more information"

    }

}