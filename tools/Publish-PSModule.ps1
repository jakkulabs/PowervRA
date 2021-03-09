<#
    .SYNOPSIS
    Publish PowerShell Modules to the PowerShell Gallery from VSTS

    .DESCRIPTION
    Publish PowerShell Modules to the PowerShell Gallery from VSTS. This script exists because there is currently a bug
    with the following task which causes the task to fail when executed on a VS2017 hosted agent.

    https://github.com/kenakamu/vsts-tasks/tree/master/Tasks/PSGalleryPublisher

    All credit must go to kenakamu for the original script

    Further modifications have been made to this version to work around the bug and enhance the code.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [String]$ApiKey,
    [Parameter(Mandatory=$true)]
    [String]$Path,
    [Parameter(Mandatory=$false)]
    [Switch]$CheckForExistingVersion,
    [Parameter(Mandatory=$false)]
    [Switch]$PreRelease
)

try {
    $Repository = "PSGallery"

    if ($PreRelease.IsPresent){
        Register-PackageSource -Name PoshTestGallery -Location https://www.poshtestgallery.com/api/v2/ -ProviderName PowerShellGet
        $Repository = "PoshTestGallery"
    }

    # --- If a module with the same version exists in the PowerShell Gallery, gracefully exit
    if ($CheckForExistingVersion.IsPresent) {
        $ModuleManifestLocation = Get-ChildItem -Path "$Path\*.psd1"
        $ModuleManifest = Import-PowerShellDataFile -Path $ModuleManifestLocation
        $PSGalleryModule = Find-Module -Name $ModuleManifestLocation.BaseName -RequiredVersion $ModuleManifest.ModuleVersion -Repository $Repository -ErrorAction SilentlyContinue
        if ($PSGalleryModule) {
            Write-Host "$($ModuleManifestLocation.BaseName) version $($ModuleManifest.ModuleVersion) already exists in the PowerShell gallery. Skipping task."
            return
        }
    }

    Write-Verbose "Publishing module"
    Publish-Module -Path $Path -NuGetApiKey $ApiKey -Repository $Repository
}
catch {
    throw "$_"
}
