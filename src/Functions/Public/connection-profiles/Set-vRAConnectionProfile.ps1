function Set-vRAConnectionProfile {
    <#
    .SYNOPSIS
    Set a vRA connection profile

    .DESCRIPTION
    Set a vRA connection profile

    .PARAMETER Name
    The name of the connection profile

    .PARAMETER Tenant
    Tenant to connect to

    .PARAMETER Server
    vRA Server to connect to

    .PARAMETER Username
    Username to connect with

    .PARAMETER IgnoreCertRequirements
    Ignore requirements to use fully signed certificates

    .PARAMETER SslProtocol
    Alternative Ssl protocol to use from the default
    Requires vRA 7.x and above
    Windows PowerShell: Ssl3, Tls, Tls11, Tls12
    PowerShell Core: Tls, Tls11, Tls12

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    $ConnectionProfileParameters = @{
        Name = "vRAProfile-01"
        Tenant = "Tenant01"
        Server = "vra01.corp.local"
        Username = "user01@vsphere.local"
        IgnoreCertRequirements = $true
        SslProtocol = "Tls12"
    }
    Set-vRAConnectionProfile @ConnectionProfileParameters

    .EXAMPLE
    Set-vRAConnectionProfile -Name vRAProfile-01 -Tenant "Tenant02"

    .EXAMPLE
    Get-vRAConnectionProfile -Name vRAProfile-01 | Set-vRAConnectionProfile -Tenant "Tenant02"
#>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High")][OutputType('System.Management.Automation.PSObject')]

    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Tenant,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Server,      
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Username,
        [Parameter(Mandatory = $false)]
        [switch]$IgnoreCertRequirements,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Ssl3', 'Tls', 'Tls11', 'Tls12', 'Default')]
        [String]$SslProtocol
    )

    try {

        # --- Root is always going to be in the users profile
        $ProfilePath = "$ENV:USERPROFILE\.PowervRA"
        Write-Verbose -Message "Profile path is: $ProfilePath"

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

        # --- Update the profile based on available parameters
        if ($PSBoundParameters.ContainsKey("Tenant")) {
            Write-Verbose -Message "Updating Tenant: $($ProfileObject.Tenant) > $Tenant"
            $ProfileObject.Tenant = $Tenant
        }

        if ($PSBoundParameters.ContainsKey("Server")) {
            Write-Verbose -Message "Updating Server: $($ProfileObject.Server) > $Server"
            $ProfileObject.Server = $Server
        }

        if ($PSBoundParameters.ContainsKey("Username")) {
            Write-Verbose -Message "Updating Username: $($ProfileObject.Username) > $Username"
            $ProfileObject.Username = $Username
        }

        if ($PSBoundParameters.ContainsKey("IgnoreCertRequirements")) {
            Write-Verbose -Message "Updating IgnoreCertRequirements: $($ProfileObject.IgnoreCertRequirements) > $IgnoreCertRequirements"
            $ProfileObject.IgnoreCertRequirements = $IgnoreCertRequirements.IsPresent
        }

        if ($PSBoundParameters.ContainsKey("SslProtocol")) {
            Write-Verbose -Message "Updating SslProtocol: $($ProfileObject.SslProtocol) > $SslProtocol"
            $ProfileObject.SslProtocol = $SslProtocol
        }

        # --- Update profile with new settings
        if ($PSCmdlet.ShouldProcess($Name, "Update Profile")) {
            Write-Verbose "Updating Profile: $ProfileConfigurationPath"
            ($ProfileObject | ConvertTo-Json) | Set-Content -Path $ProfileConfigurationPath -Force
            Write-Output $ProfileObject
        }
    }
    catch [Exception] {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}