function Remove-vRAConnectionProfile {
    <#
    .SYNOPSIS
    Remove a vRA connection profile

    .DESCRIPTION
    Remove a vRA connection profile

    .PARAMETER Name
    The name of the connection profile

    .INPUTS
    System.String

    .OUTPUTS
    None

    .EXAMPLE
    Remove-vRAConnectionProfile -Name Profile01

    .EXAMPLE
    Get-vRAConnectionProfile -Name Profile01 | Remove-vRAConnectionProfile

    .EXAMPLE
    Get-vRAConnectionProfile | Remove-vRAConnectionProfile
#>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High")]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name
    )

    Begin {
        # --- Root is always going to be in the users profile
        $ProfilePath = "$ENV:USERPROFILE\.PowervRA"
        Write-Verbose -Message "Profile path is: $ProfilePath"

        # --- If .PowervRA directory doesn't exist, throw
        if (!(Test-Path -Path $ProfilePath)) {
            throw "$ProfilePath does not exist. Have you created a connection profile yet?"
        }
    }
    Process {
        try {
            foreach ($ProfileName in $Name) {
                # --- Set ProfileConfigurationPath
                $ProfileConfigurationPath = "$ProfilePath\$($ProfileName)_profile.json"

                Write-Verbose -Message "Removing profile: $ProfileConfigurationPath"

                if ($PSCmdlet.ShouldProcess($ProfileName, "Remove Profile")) {
                    # --- If profile doesn't exist, direct user to New-vRAConnectionProfile
                    if (!(Test-Path -Path $ProfileConfigurationPath)) {
                        throw "A profile called $Name does not exist. Try creating it first with New-vRAConnectionProfile"
                    }
            
                    $null = Remove-Item -Path $ProfileConfigurationPath -Force
                }
            }
        }
        catch [Exception] {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
    End {
    }

}