function Set-vRAConnectionProfile {

[CmdletBinding(DefaultParametersetName="Username")][OutputType('System.Management.Automation.PSObject')]

    Param (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Tenant,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Server,      
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Username,
        [Parameter(Mandatory=$false)]
        [switch]$IgnoreCertRequirements,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Ssl3', 'Tls', 'Tls11', 'Tls12')]
        [String]$SslProtocol
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

        # --- Assuming that the connection profile exists, retrieve it
        $ProfileObject = Get-Content -Path $ProfileConfigurationPath -Raw | ConvertFrom-Json

        # --- Update the profile based on available parmeters
        if ($PSBoundParameters.ContainsKey("Tenant")){
            $ProfileObject.Tenant = $Tenant
        }

        if ($PSBoundParameters.ContainsKey("Server")){
            $ProfileObject.Server = $Server
        }

        if ($PSBoundParameters.ContainsKey("Username")){
            $ProfileObject.Username = $Server
        }

        if ($PSBoundParameters.ContainsKey("IgnoreCertRequirements")){
            $ProfileObject.IgnoreCertRequirements = $IgnoreCertRequirements.IsPresent
        }

        if ($PSBoundParameters.ContainsKey("SslProtocol")){
            $ProfileObject.SslProtocol = $SslProtocol
        }

        ($ProfileObject | ConvertTo-Json) | Set-Content -Path $ProfileConfigurationPath -Force
        
        Write-Output $ProfileObject

    } catch [Exception] {
        throw
    }
}