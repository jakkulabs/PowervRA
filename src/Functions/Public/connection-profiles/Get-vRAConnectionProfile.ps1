function Get-vRAConnectionProfile {

[CmdletBinding(DefaultParametersetName="Username")][OutputType('None')]

    Param (
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Name
    )

    try {

        # --- Root is always going to be in the users profile
        $ProfilePath = "$ENV:USERPROFILE\.PowervRA"

        # --- If .PowervRA directory doesn't exist, throw
        if (!(Test-Path -Path $ProfilePath)) {
            throw "$ProfilePath does not exist. Have you created a connection profile yet?"
        }

        # --- Set var if parameter is included
        if ($PSBoundParameters.ContainsKey("Name")) {
            $ProfileConfigurationPath = "$ProfilePath\$($Name)_profile.json"
            
            # --- If profile doesn't exists, direct user to New-vRAConnectionProfile
            if (!(Test-Path -Path $ProfileConfigurationPath)) {
                throw "A profile called $Name does not exist. Try creating it first with New-vRAConnectionProfile"
            }

            # --- Grab the named Profile and return it as a psobject
            Get-Content -Path $ProfileConfigurationPath -Raw | ConvertFrom-Json
        } else {
            # --- Grab all profiles and return them as psobjects
            $Profiles = Get-ChildItem -Path $ProfilePath -File -Filter "*_profile.json"

            foreach ($Profile in $Profiles){
                Get-Content -Path $Profile.FullName -Raw | ConvertFrom-Json    
          }            
        }
    } catch [Exception] {
        throw
    }
}