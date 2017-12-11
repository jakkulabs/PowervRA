function New-vRAConnectionProfile {

[CmdletBinding(DefaultParametersetName="Username")][OutputType('System.Management.Automation.PSObject')]

    Param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Tenant,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Server,      
        [Parameter(Mandatory=$true)]
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
        
        # --- If .PowervRA directory doesn't exist, create it
        if (!(Test-Path -Path $ProfilePath)) {
            $null = New-Item -Path $ProfilePath -ItemType Directory -Confirm:$false
        }

        # --- If profile exists, direct user to Set or Remove cmdlets
        if (Test-Path -Path $ProfileConfigurationPath) {
            throw "A profile called $Name already exists. Modify it with Set-vRAConnectionProfile or remove it with Remove-vRAConnectionProfile"
        }

        # --- Assuming that the connection profile is unique, create it
        $ProfileObject = [PSCustomObject]@{
            Name = $Name 
            Tenant = $Tenant
            Server = $Server
            Username = $Username
            IgnoreCertRequirements = $IgnoreCertRequirements.IsPresent
            SslProtocol = $SslProtocol
        }

        ($ProfileObject | ConvertTo-Json) | Out-File -FilePath $ProfileConfigurationPath -Force
        
        Write-Output $ProfileObject

    } catch [Exception] {
        throw
    }
}