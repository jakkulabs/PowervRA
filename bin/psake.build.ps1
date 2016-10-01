Properties {

    $BaseDirectory = $BaseDirectory
    $BinDirectory = $BinDirectory
    $ModulePath = $ModulePath
    $ModuleManifest = $ModuleManifest
    $BuildVersion = $BuildVersion

}

Task Default -depends Build
Task Build -depends Analyze, UpdateFunctions, UpdateDocumentation, 
Task Release -depends Build, BumpVersion

Task UpdateFunctions {

    try {

        Update-ModuleManifestFunctions -Path $ModuleManifest -Verbose:$VerbosePreference

    }
    catch [System.Exception] {

        Write-Error -Message "An error occured when updating manifest functions: $_.Message"

    }

}

Task UpdateDocumentation {

    try {

	    Update-ModuleDocumentation -Module $ModuleManifest -DocumentsRoot "$($BaseDirectory)\docs" -Template "$($BinDirectory)\DocumentTemplates\md-function-template.ps1" -Verbose:$VerbosePreference
	    Update-MKDocsYML -Module $ModuleManifest -Path "$($BaseDirectory)\mkdocs.yml" -Verbose:$VerbosePreference

    }
    catch [System.Exception] {

        Write-Error -Message "An error occured when updating module documentation: $_.Message"

    }

}

Task Analyze {

    $Exclusions = "PSAvoidUsingUserNameAndPassWordParams"

    $Results = Invoke-ScriptAnalyzer -Path $ModulePath  -ExcludeRule $Exclusions -Severity Error -Recurse -Verbose:$VerbosePreference

    if ($Results) {

        Write-Error -Message "PSScriptAnalyzer has found some errors:"
        $Results | Format-Table

    }

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
    Set-Location -Path $BaseDirectory
    $Result = Invoke-Pester -Verbose:$VerbosePreference -PassThru

    if ($Result) {

        $Result | ConvertTo-Json -Depth 100 | Out-File -FilePath $ResultsFile
        Write-Error -Message "Pester Tests Failed. See $($ResultsFile) for more information"

    }

}