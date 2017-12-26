function Get-vRAConnectionProfile {
    <#
    .SYNOPSIS
    Get a vRA connection profile

    .DESCRIPTION
    Get a vRA connection profile

    DYNAMIC PARAMETERS 
        -Name <String>
            The name of the connection profile

            Required?                    false
            Position?                    0
            Default value
            Accept pipeline input?       false
            Accept wildcard characters?  false

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAConnectionProfile

    .EXAMPLE
    Get-vRAConnectionProfile -Name profile01

#>
    [CmdletBinding(DefaultParametersetName = "Username")][OutputType('System.Management.Automation.PSObject')]
    Param ()
    DynamicParam {
        $Profiles = (Get-ChildItem -Path "$ENV:USERPROFILE\.PowervRA" -File -Filter "*_profile.json" -ErrorAction SilentlyContinue) | ForEach-Object {
            $_.BaseName.Split("_")[0]
        } 
        NewDynamicParam -Name Name -ValidateSet $Profiles -Type String
    }

    Process {
        try {
            # --- Root is always going to be in the users profile
            $ProfilePath = "$ENV:USERPROFILE\.PowervRA"
            Write-Verbose -Message "Profile path is: $ProfilePath"
    
            # --- If .PowervRA directory doesn't exist, throw
            if (!(Test-Path -Path $ProfilePath)) {
                throw "$ProfilePath does not exist. Have you created a connection profile yet?"
            }
    
            # --- Set var if parameter is included
            if ($PSBoundParameters.ContainsKey("Name")) {
                $ProfileConfigurationPath = "$ProfilePath\$($PSBoundParameters.Name)_profile.json"
                Write-Verbose -Message "Retrieving profile: $ProfileConfigurationPath"
                
                # --- If profile doesn't exists, direct user to New-vRAConnectionProfile
                if (!(Test-Path -Path $ProfileConfigurationPath)) {
                    throw "A profile called $Name does not exist. Try creating it first with New-vRAConnectionProfile"
                }
    
                # --- Grab the named Profile and return it as a psobject
                Get-Content -Path $ProfileConfigurationPath -Raw | ConvertFrom-Json
            }
            else {
                # --- Grab all profiles and return them as psobjects
                $Profiles = Get-ChildItem -Path $ProfilePath -File -Filter "*_profile.json"
    
                foreach ($ProfileName in $Profiles) {
                    Write-Verbose -Message "Retrieving profile: $($ProfileName.FullName)"
                    Get-Content -Path $ProfileName.FullName -Raw | ConvertFrom-Json
                }
            }
        }
        catch [Exception] {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}