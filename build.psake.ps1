# --- Dot source build.settings.ps1
. $PSScriptRoot\build.settings.ps1

# --- Add any parameters from build.ps1
properties {
    $CurrentVersion = [version](Get-Metadata -Path $env:BHPSModuleManifest)

    if ($Increment) {
        $StepVersion = [version](Step-Version $CurrentVersion -By $Increment)
    }
}

# --- Define the build tasks
Task Default -depends Test
Task Test -depends Init, Analyze, TestHelp
Task Build -depends Test, UpdateModuleManifest, UpdateDocumentation, IncrementVersion, CommitChanges, CreateArtifact
Task Release -depends CreateArtifact, CreateGitHubRelease, PublishToPSGallery

Task Init {

    Write-Output "Build System Details:"
    foreach ($Item in (Get-Item -Path ENV:BH*)){
        Write-Output "$($Item.Name): $($Item.Value)"
    }
    Write-Output "ScriptAnalyzerSeverityLevel: $($ScriptAnalysisFailBuildOnSeverityLevel)"
    Write-Output "Current Module Version: $($CurrentVersion)"
    Write-Output "Increment: $($Increment)"
}

##############
# Task: Test #
##############

Task Analyze {

    $Results = Invoke-ScriptAnalyzer -Path $ENV:BHPSModulePath -Recurse -Settings $ScriptAnalyzerSettingsPath -Verbose:$VerbosePreference
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

Task TestHelp {

    # --- Run Tests. Currently limited to help tests
    $Timestamp = Get-date -uformat "%Y%m%d-%H%M%S"
    $TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"
    $Parameters = @{
        Script = "$ENV:BHProjectPath\tests\Test000-Module.Tests.ps1"
        Tag = 'Help'
        PassThru = $true
        OutputFormat = 'NUnitXml'
        OutputFile = "$ENV:BHProjectPath\$TestFile"
    }

    $TestResults = Invoke-Pester @Parameters

    If ($ENV:BHBuildSystem -eq 'AppVeyor') {
        "Uploading $ENV:BHProjectPath\$TestFile to AppVeyor"
        "JobID: $env:APPVEYOR_JOB_ID"
        (New-Object 'System.Net.WebClient').UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path "$ENV:BHProjectPath\$TestFile"))
    }
    
    Remove-Item "$ENV:BHProjectPath\$TestFile" -Force -ErrorAction SilentlyContinue

    if ($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }

}

###############
# Task: Build #
###############

Task UpdateModuleManifest {

    $PublicFunctions = Get-ChildItem -Path "$($ENV:BHPSModulePath)\Functions\Public" -Filter "*.ps1" -Recurse | Sort-Object

    $ExportFunctions = @()

    foreach ($FunctionFile in $PublicFunctions) {
        $AST = [System.Management.Automation.Language.Parser]::ParseFile($FunctionFile.FullName, [ref]$null, [ref]$null)        
        $Functions = $AST.FindAll({
                $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]
            }, $true)
        if ($Functions.Name) {
            $ExportFunctions += $Functions.Name
        }        
    }

    Set-ModuleFunctions -Name $ENV:BHPSModuleManifest -FunctionsToExport $ExportFunctions -Verbose:$VerbosePreference
}

Task UpdateDocumentation {

    if ($ENV:BHBranchName -eq "master") {
        Write-Output "This task cannot be executed on the master branch. Skpping task"
    }

    Write-Output "Updating Markdown help"
    $ModuleInfo = Import-Module $ENV:BHPSModuleManifest -Global -Force -PassThru
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
    Copy-Item -Path "$($PSScriptRoot)\README.md" -Destination "$($DocsDirectory)\index.md" -Force -Verbose:$VerbosePreference | Out-Null

    # --- Update mkdocs.yml with new functions
    Write-Output "Updating mkdocs.yml"
    $Mkdocs = "$($PSScriptRoot)\mkdocs.yml"
    $Functions = $ModuleInfo.ExportedCommands.Keys | ForEach-Object {"    - $($_) : functions/$($_).md"}

    $Template = @"
---

site_name: $($ModuleName)
repo_url: $($RepositoryUrl)
site_author: $($ModuleAuthor)
edit_uri: edit/master/docs/
theme: readthedocs
copyright: "PowervRA is licenced under the <a href='$($RepositoryUrl)/raw/master/LICENSE'>MIT license"
pages:
- 'Home' : 'index.md'
- 'Change log' : 'CHANGELOG.md'
- 'Build' : 'build.md'
- 'Functions':
$($Functions -join "`r`n")
"@

    $Template | Set-Content -Path $Mkdocs -Force

}

Task IncrementVersion {

    if ($ENV:BHBranchName -eq "master") {
        Write-Output "This task cannot be executed on the master branch. Skpping task"
    }

    if (!$StepVersion) {
        Write-Output "StepVersion not specified. Skipping task"
    }

    if ([version]$StepVersion -gt [version]$CurrentVersion) {

        # --- Update module manifest version
        Update-Metadata -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -Value $StepVersion        
        Write-Output "Module version updated to $($StepVersion)"

        # --- Update appveyor build version
        $AppveyorYMLPath = "$($PSScriptRoot)\appveyor.yml"
        $AppveyorVersion = "$($StepVersion).{build}"
        $NewAppveyorYML = Get-Content -Path $AppveyorYMLPath | ForEach-Object { $_ -replace '^version: .+$', "version: $($AppveyorVersion)";}
        $NewAppveyorYML | Set-Content -Path $AppveyorYMLPath -Force
        Write-Output "Appveyor build version set to $($AppveyorVersion)"

        # --- Update change log
        $ReleaseNotes = "$ENV:BHProjectPath\RELEASE.md"
        $ChangeLog = "$DocsDirectory\CHANGELOG.md"
        $Header = "# Version $($StepVersion)`r"
        $Header, (Get-Content -Path $ReleaseNotes -Raw), "`r", (Get-Content $ChangeLog -Raw) | Set-Content $ChangeLog
    }
}

Task CommitChanges {

    if ($ENV:BHBuildSystem -eq "Unknown"){
        Write-Output "Could not detect build system. Skipping task"
        return
    }

    if ($ENV:APPVEYOR_REPO_PROVIDER -notlike 'github') {
        Write-Output "Repo provider '$ENV:APPVEYOR_REPO_PROVIDER'. Skipping task"
        return
    }

    if ($ENV:BHBranchName -eq "master") {
        Write-Output "This task cannot be executed on the master branch. Skpping task"
    }

    If ($ENV:BHBuildSystem -eq 'AppVeyor') {
        Write-Output "git config --global credential.helper store"
        cmd /c "git config --global credential.helper store 2>&1"
        
        Add-Content "$ENV:USERPROFILE\.git-credentials" "https://$($ENV:gh_token):x-oauth-basic@github.com`n"
        
        Write-Output "git config --global user.email"
        cmd /c "git config --global user.email ""$($ENV:BHProjectName)-$($ENV:BHBranchName)-$($ENV:BHBuildSystem)@jakkulabs.com"" 2>&1"
        
        Write-Output "git config --global user.name"
        cmd /c "git config --global user.name ""AppVeyor"" 2>&1"
        
        Write-Output "git config --global core.autocrlf true"
        cmd /c "git config --global core.autocrlf true 2>&1"
    }
    
    Write-Output "git checkout $ENV:BHBranchName"
    cmd /c "git checkout $ENV:BHBranchName 2>&1"

    Write-Output "git pull recent commits from $ENV:BHBranchName"
    cmd /c "git pull 2>&1"
    
    Write-Output "git add -A"
    cmd /c "git add -A 2>&1"
    
    Write-Output "git commit -m"
    cmd /c "git commit -m ""AppVeyor post-build commit [ci skip]"" 2>&1"
    
    Write-Output "git status"
    cmd /c "git status 2>&1"
    
    Write-Output "git push origin $ENV:BHBranchName"    
    cmd /c "git push origin $ENV:BHBranchName 2>&1"
}

#################
# Task: Release #
#################

Task CreateArtifact {

    $ModuleManifestVersion = Get-Metadata -Path $ENV:BHPSModuleManifest -PropertyName "ModuleVersion"
    $ArtifactDestination = "$($ENV:BHProjectPath)\$($ENV:BHProjectName).v$($ModuleManifestVersion).zip"  

    if ((Test-Path -Path $ArtifactDestination)) {
        Remove-Item -Path $ArtifactDestination -Force | Out-Null
    }

    Write-Output "Compressing module: $($ArtifactDestination)"
    Compress-Archive -Path $ENV:BHPSModulePath -DestinationPath $ArtifactDestination -Force -Confirm:$false -Verbose:$VerbosePreference | Out-Null

    if ($ENV:BHBuildSystem -eq "AppVeyor") {
        Write-Output "Pushing asset to AppVeyor: $($ArtifactDestination)"
        Push-AppveyorArtifact $ArtifactDestination
    }
}

Task CreateGitHubRelease {

    if ($ENV:BHBuildSystem -eq "Unknown"){
        Write-Output "Could not detect build system. Skipping task"
        return
    }

    if ($ENV:APPVEYOR_REPO_PROVIDER -notlike 'github') {
        Write-Output "Repo provider '$ENV:APPVEYOR_REPO_PROVIDER'. Skipping task"
        return
    }

    if ($ENV:BHBranchName -ne "master") {
        Write-Output "Not in master branch. Skipping task"
    }

    Set-GitHubSessionInformation -UserName $OrgName -APIKey $ENV:gh_token -Verbose:$VerbosePreference | Out-Null

    $ModuleManifestVersion = Get-Metadata -Path $ENV:BHPSModuleManifest -PropertyName "ModuleVersion"
    $AssetPath = "$($ENV:BHProjectPath)\$($ENV:BHProjectName).v$($ModuleManifestVersion).zip"  
    
    $Asset = @{
        "Path" = $AssetPath
        "Content-Type" = "application/zip"
    }

    $GitHubReleaseManagerParameters = @{
        Repository = $RepositoryName
        Name = $ModuleName
        Description = (Get-Content -Path "$ENV:BHProjectPath\RELEASE.md" -Raw)
        Target = $ENV:BHBranchName
        Tag = "v$($ModuleManifestVersion)"
        Asset = $Asset
    }

    Write-Output "Creating GitHub release with the following parameters:"
    Write-Output $GitHubReleaseManagerParameters

    New-GitHubRelease @GitHubReleaseManagerParameters -Verbose:$VerbosePreference -Confirm:$false | Out-Null
}

Task PublishToPSGallery {

    if ($ENV:BHBranchName -ne "master") {
        Write-Output "Not in master branch. Skipping task"
    }

    Publish-Module -Path $ENV:BHPSModuleManifest -NuGetApiKey $ENV:psg_token -Confirm:$false -Verbose:$VerbosePreference | Out-Null
}