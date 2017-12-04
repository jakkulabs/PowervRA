[CmdletBinding()]
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

Install-Module -Name GitHubReleaseManager -Scope CurrentUser -Confirm:$false -Force
Import-Module -Name GitHubReleaseManager

try {

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

    Write-Output "Creating GitHub release with the following parameters:`n $($GitHubReleaseManagerParameters | ConvertTo-Json)"
    $null = New-GitHubRelease @GitHubReleaseManagerParameters -Verbose:$VerbosePreference -Confirm:$false

}
catch {
    throw "An errlr occured while creating the release: $($_.Exception.Message)"
}