function Update-ModuleManifestVersion {
<#

.SYNOPSIS
Bump the version of a module manifest file

.DESCRIPTION
Increment the version number of a module manifest file by following the Semantic Versioning standard -> http://semver.org/

It is possible to update either the MAJOR,MINOR or PATCH patch version of the module depending on what changes have been made
to the module.

.PARAMETER Path
The path to the module manifest file

.PARAMETER Major
Increase the major version of the module by 1

.PARAMETER Minor
Increase the minor version of the module by 1

.PARAMETER Patch
Increase the patch version of the module by 1

.INPUTS
System.String
System.Diagnostics.Switch

.OUTPUTS
None

.EXAMPLE
Update-ModuleManifestVersion -Path .\ModuleManifest.psd1 -Major

.EXAMPLE
Update-ModuleManifestVersion -Path .\ModuleManifest.psd1 -Minor

.EXAMPLE
Update-ModuleManifestVersion -Path .\ModuleManifest.psd1 -Patch

#>

[CmdletBinding(SupportsShouldProcess, ConfirmImpact="High", DefaultParameterSetName="Patch")]

    Param (

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Path,

        [Parameter(Mandatory=$true, ParameterSetName="Major")]
        [ValidateNotNullOrEmpty()]
        [Switch]$Major,

        [Parameter(Mandatory=$true, ParameterSetName="Minor")]
        [ValidateNotNullOrEmpty()]
        [Switch]$Minor,

        [Parameter(Mandatory=$true, ParameterSetName="Patch")]
        [ValidateNotNullOrEmpty()]
        [Switch]$Patch

    )

    if (!(Test-Path -Path $Path)) {

        throw "Could not find file: $($Path)"

    }

    # --- Ge the fully qualified path of the file
    $ResolvedPath = Resolve-Path -Path $Path -ErrorAction Stop | Select-Object -ExpandProperty Path

    Write-Verbose -Message "Resolved path: $($ResolvedPath)"

    # --- Get the current version of the module
    $ModuleManifest = Invoke-Expression -Command (Get-Content -Path $ResolvedPath | Out-String)
    $CurrentModuleVersion = $ModuleManifest.ModuleVersion

    Write-Verbose -Message "Current module version is $($CurrentModuleVersion)"

    [Int]$MajorVersion = $CurrentModuleVersion.Split(".")[0]
    [Int]$MinorVersion = $CurrentModuleVersion.Split(".")[1]
    [Int]$PatchVersion = $CurrentModuleVersion.Split(".")[2]

    switch ($PSCmdlet.ParameterSetName) {

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

        if ($PSCmdlet.ShouldProcess($ResolvedPath)){

            try {

                Update-ModuleManifest -Path $ResolvedPath -ModuleVersion $ModuleVersion

                Write-Verbose -Message "Module version updated to $($ModuleVersion)"

            }
            catch [Exception] {

                throw "An error occured while updating the module manifest: $($_.Exception.Message)"

            }

        }

    }

}