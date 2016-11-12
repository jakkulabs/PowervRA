# --- Dot source build.settings.ps1
. $PSScriptRoot\build.settings.ps1

# --- Define the build tasks
Task Default -depends Build
Task Build -depends Analyze, UpdateModuleManifest, UpdateDocumentation
Task Release -depends Build, Test, BumpVersion

Task Analyze {

    $Results = Invoke-ScriptAnalyzer -Path $ModuleDirectory -Recurse  -Settings $ScriptAnalyzerSettingsPath -Verbose:$VerbosePreference
    $Results | Select RuleName, Severity, ScriptName, Line, Message | Format-List

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

        $PublicFunctions = Get-ChildItem -Path "$($ModuleDirectory)\Functions\Public" -Filter "*.psm1" -Recurse | Sort-Object
        $PrivateFunctions = Get-ChildItem -Path "$($ModuleDirectory)\Functions\Private" -Filter "*.ps1" -Recurse | Sort-Object

        $ModuleManifest = Import-PowerShellDataFile -Path $ModuleManifestPath -Verbose:$VerbosePreference

        # --- Scripts To Process
        Write-Verbose -Message "Processing ScriptsToProcess"
        $ModuleManifest.ScriptsToProcess = $PrivateFunctions | ForEach-Object {$_.FullName.Substring($_.FullName.LastIndexOf($ModuleName)+$ModuleName.Length).Trim("\")}

        # --- Functions To Export
        Write-Verbose -Message "Processing FunctionsToExport"
        $FunctionsToExportRaw  = $PublicFunctions | Select-Object -ExpandProperty BaseName | Sort-Object
        $ModuleManifest.FunctionsToExport = $FunctionsToExportRaw | ForEach-Object {if ($_.StartsWith("DEPRECATED-")) { $_.SubString("DEPRECATED-".length)}else{$_} }
        
        # --- Nested Modules   
        Write-Verbose -Message "Processing NestedModules"
        $ModuleManifest.NestedModules = $PublicFunctions | ForEach-Object {$_.FullName.Substring($_.FullName.LastIndexOf($ModuleName)+$ModuleName.Length).Trim("\")}

        # --- Private Data  
        Write-Verbose -Message "Processing PrivateData"
        if ($ModuleManifest.ContainsKey("PrivateData") -and $ModuleManifest.PrivateData.ContainsKey("PSData")) {

            foreach ($node in $ModuleManifest.PrivateData["PSData"].GetEnumerator()) {

                $key = $node.Key

                if ($node.Value.GetType().Name -eq "Object[]") {

                    $value = $node.Value | ForEach-Object {$_}

                }
                else {

                    $value = $node.Value    

                }
                
                $ModuleManifest[$key] = $value
            }

            $ModuleManifest.Remove("PrivateData")

        }

        New-ModuleManifest -Path $ModuleManifestPath @ModuleManifest -Verbose:$VerbosePreference

    }
    catch [System.Exception] {

        Write-Error -Message "An error occured when updating manifest functions: $_.Message"

    }

}

Task UpdateDocumentation {

    $ModuleInfo = Import-Module $ModuleManifestPath -Global -Force -PassThru

    # --- Create or update existing MD documentation
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
    New-MarkdownHelp -Module $ModuleName -Locale $DefaultLocale -OutputFolder $DocsDirectory -NoMetadata `
                    -ErrorAction SilentlyContinue -Verbose:$VerbosePreference | Out-Null

    # --- Ensure that index.md is present and up to date
    Copy-Item -Path "$($PSScriptRoot)\README.md" -Destination "$($DocsDirectory)\index.md" -Force -Verbose:$VerbosePreference | Out-Null

    # --- Update mkdocs.yml with new functions
    $Mkdocs = "$($PSScriptRoot)\mkdocs.yml"

    if (!(Test-Path -Path $Mkdocs)) {
        
        Write-Verbose -Message "Creating MKDocs.yml"
        
        New-Item -Path $Mkdocs -ItemType File -Force | Out-Null           

    }
        
    $Functions = $ModuleInfo.ExportedCommands.Keys | % {"    - $($_) : $($_).md"}
    
    $Template = @"
---

site_name: $($ModuleName)
pages:
- 'Home' : 'index.md'
- 'Functions': 
$($Functions -join "`r`n")
"@

    $Template | Out-File -FilePath $Mkdocs -Force

}

Task BumpVersion {

    # --- Get the current version of the module
    $ModuleManifest = Import-PowerShellDataFile -Path $ModuleManifestPath -Verbose:$VerbosePreference

    $CurrentModuleVersion = $ModuleManifest.ModuleVersion

    $ModuleManifest.Remove("ModuleVersion")

    Write-Verbose -Message "Current module version is $($CurrentModuleVersion)"

    [Int]$MajorVersion = $CurrentModuleVersion.Split(".")[0]
    [Int]$MinorVersion = $CurrentModuleVersion.Split(".")[1]
    [Int]$PatchVersion = $CurrentModuleVersion.Split(".")[2]

    $ModuleManifest.ScriptsToProcess = $ModuleManifest.ScriptsToProcess | ForEach-Object {$_}
    $ModuleManifest.FunctionsToExport = $ModuleManifest.FunctionsToExport | ForEach-Object {$_}
    $ModuleManifest.NestedModules = $ModuleManifest.NestedModules | ForEach-Object {$_}
    $ModuleManifest.RequiredModules = $ModuleManifest.RequiredModules | ForEach-Object {$_}
    $ModuleManifest.ModuleList = $ModuleManifest.ModuleList | ForEach-Object {$_}
    
    if ($ModuleManifest.ContainsKey("PrivateData") -and $ModuleManifest.PrivateData.ContainsKey("PSData")) {

        foreach ($node in $ModuleManifest.PrivateData["PSData"].GetEnumerator()) {

            $key = $node.Key

            if ($node.Value.GetType().Name -eq "Object[]") {

                $value = $node.Value | ForEach-Object {$_}

            }
            else {

                $value = $node.Value

            }
            
            $ModuleManifest[$key] = $value

        }

        $ModuleManifest.Remove("PrivateData")
    }


    switch ($BumpVersion) {

        'Major' {

            Write-Verbose -Message "Bumping module major release number"

            $MajorVersion++
            $MinorVersion = 0
            $PatchVersion = 0

            break

        }

        'Minor' {

            Write-Verbose -Message "Bumping module minor release number"

            $MinorVersion++
            $PatchVersion = 0

            break

        }

        'Patch' {

            Write-Verbose -Message "Bumping module patch release number"

            $PatchVersion++

            break
        }

    }

    # --- Build the new version string
    $ModuleVersion = "$($MajorVersion).$($MinorVersion).$($PatchVersion)"

    if ($ModuleVersion -gt $CurrentModuleVersion) {

        # --- Fix taken from: https://github.com/RamblingCookieMonster/BuildHelpers/blob/master/BuildHelpers/Public/Step-ModuleVersion.ps1
        New-ModuleManifest -Path $ModuleManifestPath -ModuleVersion $ModuleVersion @ModuleManifest -Verbose:$VerbosePreference
        Write-Verbose -Message "Module version updated to $($ModuleVersion)"

    }

}

Task Test {

    $Result = Invoke-Pester -Verbose:$VerbosePreference -PassThru

    if ($Result) {

        $Result | ConvertTo-Json -Depth 100 | Out-File -FilePath $ResultsFile
        Write-Error -Message "Pester Tests Failed. See $($ResultsFile) for more information"

    }

}