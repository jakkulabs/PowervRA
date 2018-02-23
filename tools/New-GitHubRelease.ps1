<#
    .SYNOPSIS
    A script used in releases to create a new release in GitHub and publish an artifact
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [String]$AccountName,
    [Parameter(Mandatory=$true)]
    [String]$APIKey,
    [Parameter(Mandatory=$true)]
    [String]$RepositoryName,
    [Parameter(Mandatory=$true)]
    [String]$Name,
    [Parameter(Mandatory=$false)]
    [String]$Tag,
    [Parameter(Mandatory=$true)]
    [String]$ReleaseNotesPath,
    [Parameter(Mandatory=$false)]
    [String]$Target = "master",
    [Parameter(Mandatory=$true)]
    [String]$AssetPath
)

# --- Install and import GithubReleaseManager
if (!(Get-Module -Name GitHubReleaseManager -ListAvailable)){
    Install-Module -Name GitHubReleaseManager -Scope CurrentUser -Confirm:$false -Force
}
Import-Module -Name GitHubReleaseManager -Force

# --- Set the Tag
if (!$PSBoundParameters.ContainsKey("Tag")){
    $Tag = "v$($ENV:BUILD_BUILDNUMBER.Split("-")[0])"
}

# --- Set TLS version
[System.Net.ServicePointManager]::SecurityProtocol += [System.Net.SecurityProtocolType]::Tls12

# --- Attempt to create a new release
try {

    $null = Set-GitHubSessionInformation -UserName $AccountName -APIKey $ApiKey

    try {
        $GitHubRelease = Get-GitHubRelease -Repository $RepositoryName -Tag $Tag
    }
    catch {}
    
    if ($GitHubRelease) {
        Write-Host "A release with tag $Tag already exists, skipping task."
        return
    }

    $Asset = @{
        "Path"         = $AssetPath
        "Content-Type" = "application/zip"
    }

    $ReleaseNotes = Get-Content -Path $ReleaseNotesPath -Raw

    $GitHubReleaseManagerParameters = @{
        Repository  = $RepositoryName
        Name        = $Name
        Description = $ReleaseNotes
        Target      = $Target
        Tag         = $Tag
        Asset       = $Asset
    }

    Write-Host "Creating Release $Tag of $Name"
    $null = New-GitHubRelease @GitHubReleaseManagerParameters -Verbose:$VerbosePreference -Confirm:$false
}
catch {
    throw "An error occurred while creating the release: $($_.Exception.Message)"
}