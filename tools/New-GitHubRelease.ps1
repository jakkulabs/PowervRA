[CmdletBinding()]
Param(
    [Parameter()]
    [String]$AccountName,
    [Parameter()]
    [String]$RepositoryName,
    [Parametre()]
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

$null = Set-GitHubSessionInformation -UserName $AccountName -APIKey $ENV:GitHubApiKey

try {
    $GitHubRelease = Get-GitHubRelease -Repository $RepositoryName -Tag $Tag
}
catch {}

if ($GitHubRelease) {
    Write-Output "A release with tag $Tag already exists. Skipping task"
    return
}

$Asset = @{
    "Path" = $AssetPath
    "Content-Type" = "application/zip"
}

$GitHubReleaseManagerParameters = @{
    Repository = $RepositoryName
    Name = $ReleaseName
    Description = (Get-Content -Path $ReleaseNotesPath -Raw)
    Target = $Target
    Tag = $Tag
    Asset = $Asset
}

Write-Output "Creating GitHub release with the following parameters:`n $($GitHubReleaseManagerParameters | ConvertTo-Json)"
$null = New-GitHubRelease @GitHubReleaseManagerParameters -Verbose:$VerbosePreference -Confirm:$false