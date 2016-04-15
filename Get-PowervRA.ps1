function Get-PowervRA {
<#
    .SYNOPSIS
    Install PowervRA
    
    .DESCRIPTION
    Install powervRA
    
    .PARAMETER Global
    Install for all users
    
    .PARAMETER ImportAfterInstall
    Import the module after a succesfull installation

    .PARAMETER InstallFromRepo
    Install latest release from github repo 

    .INPUTS
    None

    .OUTPUTS
    None

    .EXAMPLE
    Get-PowervRA

    .EXAMPLE
    Get-PowervRA -Global

    .EXAMPLE
    Get-PowervRA -Global -ImportAfterInstall

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="Standard")]

    Param (

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$URI,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Switch]$Global,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Switch]$ImportAfterInstall

    )    

    begin {

     $Header = @"
 _____                             _____            
|  __ \                           |  __ \     /\    
| |__) |____      _____ _ ____   _| |__) |   /  \   
|  ___/ _ \ \ /\ / / _ \ '__\ \ / /  _  /   / /\ \  
| |  | (_) \ V  V /  __/ |   \ V /| | \ \  / ____ \ 
|_|   \___/ \_/\_/ \___|_|    \_/ |_|  \_\/_/    \_\                                                    
"@                                                                                                                

    Write-Output $Header
    Write-Output "Jakku Labs $([char]0x00A9) 2016"           
    
    }
    
    process {

        try {

            # --- Set the installtion directory
            $InstallationDir = "C:\Users\$($env:USERNAME)\Documents\WindowsPowerShell\Modules\PowervRA\"
    
            if ($PSBoundParameters.ContainsKey('Global')) {

                $InstallationDir = "C:\Program Files\WindowsPowerShell\Modules\PowervRA\"
        
            }

            Write-Verbose -Message "Intallation directory is: $($InstallationDir)"

            # --- Download and unpack the latest release

            Write-Verbose -Message "Downloading latest release from $($URI)"

            $Response = Invoke-RestMethod -Method Get -Uri $URI

            $ZipUrl = $Response.zipball_url

            $GUID = ([guid]::NewGuid()).ToString()

            $OutputFile = "$($env:TEMP)\powervra-$($GUID).zip"

            Invoke-RestMethod -Method Get -Uri $ZipUrl -OutFile $OutputFile

            Add-Type -assembly “system.io.compression.filesystem”

            $PowervRAModulePath = $OutputFile.Substring(0, $OutputFile.LastIndexOf('.'))

            Write-Verbose -Message "Unpacking module to $($PowervRAModulePath)"

            [io.compression.zipfile]::ExtractToDirectory($OutputFile, $PowervRAModulePath)
          
            if ($PSCmdlet.ShouldProcess($InstallationDir)){

                # --- Remove module if it is present
                if ((Test-Path -Path $InstallationDir)){

                    Write-Verbose -Message "Removing old module"    

                    Remove-Item -Path $InstallationDir -Recurse -Force

                }

                # --- Install PowervRA
                Write-Verbose -Message "Installing PowervRA to $($InstallationDir)"

                Copy-Item -Path "$($PowervRAModulePath)\*\PowervRA" -Destination $InstallationDir -Force -Recurse

                if ($PSBoundParameters.ContainsKey('ImportAfterInstall')) {

                    Write-Verbose -Message "Attempting to remove old module from session"
                    Remove-Module -Name "PowervRA" -Force -ErrorAction SilentlyContinue

                    Write-Verbose -Message "Importing module"
                    Import-Module -Name "PowervRA" -Force

                }

                Write-Verbose -Message "Installation complete"

            }
        }
        catch [Exception]{

            throw
        }
    }
    end {

        Write-Verbose -Message "Removing temporary file $($OutputFile)"
        Remove-item -Path $OutputFile -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false

        Write-Verbose -Message "Removing temporary directory $($PowervRAModulePath)"
        Remove-Item -Path $PowervRAModulePath -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false

        }            
 
}

# --- Install PowervRA for the current user
Get-PowervRA -URI "https://api.github.com/repos/jakkulabs/PowervRA/releases/latest" -ImportAfterInstall -Verbose