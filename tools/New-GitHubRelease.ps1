<#
    .SYNOPSIS
    A script used in releases to create a new release in GitHub and publish an artifact
#>
[CmdletBinding(SupportsShouldProcess=$true)]
Param(
    [Parameter()]
    [String]$AccountName,
    [Parameter()]
    [String]$RepositoryName,
    [Parameter()]
    [String]$Name,
    [Parameter()]
    [String]$Tag = "v$($ENV:Build_BuildNumber)",
    [Parameter()]
    [String]$ReleaseNotesPath,
    [Parameter()]
    [String]$Target = "master",
    [Parameter()]
    [String]$AssetPath

)

if (!(Get-Module -Name GitHubReleaseManager -ListAvailable)){
    Install-Module -Name GitHubReleaseManager -Scope CurrentUser -Confirm:$false -Force    
}
Import-Module -Name GitHubReleaseManager

try {

    $null = Set-GitHubSessionInformation -UserName $AccountName -APIKey $ENV:GitHubApiKey

    try {
        $GitHubRelease = Get-GitHubRelease -Repository $RepositoryName -Tag $Tag
    }
    catch {}
    
    if ($GitHubRelease) {
        throw "A release with tag $Tag already exists!"
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

    Write-Output "Creating Release $Tag of $Name"
    if ($PSCmdlet.ShouldProcess("$Name - Release $Tag","New-GithubRelease")){
        $null = New-GitHubRelease @GitHubReleaseManagerParameters -Verbose:$VerbosePreference -Confirm:$false
    }
}
catch {
    throw "An error occurred while creating the release: $($_.Exception.Message)"
}