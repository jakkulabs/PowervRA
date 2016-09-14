<#
.SYNOPSIS
Wrapper for PSake build file
Resolve-Module borrowed from https://github.com/stefanstranger/Wunderlist/blob/master/build.ps1
#>

[Cmdletbinding()]

Param (

    [Parameter(Mandatory=$false)]
    [ValidateSet('Build','Release')]
    [String]$Task = 'Build', 

    [Parameter(Mandatory=$false)]
    [ValidateSet('Major','Minor','Patch')]
    [String]$BuildVersion = 'Patch'

)

function Resolve-Module {

  [Cmdletbinding()]

  param (
    [Parameter(Mandatory=$true)]
    [string[]]$Name
  )

  Process {
    foreach ($ModuleName in $Name) {

      $Module = Get-Module -Name $ModuleName -ListAvailable
      Write-Verbose -Message "Resolving Module $($ModuleName)"
            
      if ($Module) {

        $Version = $Module |
        Measure-Object -Property Version -Maximum |
        Select-Object -ExpandProperty Maximum

        $GalleryVersion = Find-Module -Name $ModuleName -Repository PSGallery |
        Measure-Object -Property Version -Maximum |
        Select-Object -ExpandProperty Maximum

        if ($Version -lt $GalleryVersion) {

          if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {

            Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

          }

          Write-Verbose -Message "$($ModuleName) Installed Version [$($Version.tostring())] is outdated. Installing Gallery Version [$($GalleryVersion.tostring())]"
                    
          Install-Module -Name $ModuleName -Force -SkipPublisherCheck #skip
          Import-Module -Name $ModuleName -Force -RequiredVersion $GalleryVersion

        }
        else {

          Write-Verbose -Message "Module Installed, Importing $($ModuleName)"
          Import-Module -Name $ModuleName -Force -RequiredVersion $Version

        }

      }
      else {

        Write-Verbose -Message "$($ModuleName) Missing, installing Module"
        Install-Module -Name $ModuleName -Force
        Import-Module -Name $ModuleName -Force -RequiredVersion $Version

      }

    }

  }

}

# --- Build Parameters
$BaseDirectory = $PSScriptRoot #(Resolve-Path -Path .).Path
$BinDirectory = "$($BaseDirectory)\bin"
$ModulePath = "$($BaseDirectory)\PowervRA"
$ModuleManifest = "$($ModulePath)\PowervRA.psd1"

$Parameters = @{

    BaseDirectory = $BaseDirectory
    BinDirectory = $BinDirectory
    ModulePath = $ModulePath
    ModuleManifest = $ModuleManifest
    BuildVersion = $BuildVersion

}

Write-Output $Parameters

Resolve-Module Psake, Pester, PSScriptAnalyzer -Verbose:$VerbosePreference

$LocalDependencies = @(

    "$($BinDirectory)\Update-MKDocsYML.psm1",
    "$($BinDirectory)\Update-ModuleDocumentation.psm1",
    "$($BinDirectory)\Update-ModuleManifestVersion.psm1",
    "$($BinDirectory)\Update-ModuleManifestFunctions.psm1"

)

$LocalDependencies | % {Import-Module -Name $_ -Force}

# --- Start Build
Invoke-psake -buildFile "$($PSScriptRoot)\bin\psake.build.ps1" -taskList $Task -parameters $Parameters -nologo -Verbose:$VerbosePreference

exit ( [int]( -not $psake.build_success ) )