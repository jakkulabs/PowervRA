function Remove-vRAConnectionProfile {

[CmdletBinding(DefaultParametersetName="Username")]
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name
    )

    try {

        # --- Root is always going to be in the users profile
        $ProfilePath = "$ENV:USERPROFILE\.PowervRA"
        $ProfileConfigurationPath = "$ProfilePath\$($Name)_profile.json"
        
        # --- If .PowervRA directory doesn't exist, throw
        if (!(Test-Path -Path $ProfilePath)) {
            throw "$ProfilePath does not exist. Have you created a connection profile yet?"
        }

        # --- If profile doesn't exists, direct user to New-vRAConnectionProfile
        if (!(Test-Path -Path $ProfileConfigurationPath)) {
            throw "A profile called $Name does not exist. Try creating it first with New-vRAConnectionProfile"
        }

        $null = Remove-Item -Path $ProfileConfigurationPath -Force

    } catch [Exception] {
        throw
    }
}