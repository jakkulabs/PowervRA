function New-vRAConnectionProfile {
    <#
    .SYNOPSIS
    Create a vRA connection profile

    .DESCRIPTION
    Create a vRA connection profile

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
    New-vRAConnectionProfile @ConnectionProfileParameters
#>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Low", DefaultParametersetName = "Username")][OutputType('System.Management.Automation.PSObject')]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Tenant,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Server,      
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Username,
        [Parameter(Mandatory = $false)]
        [switch]$IgnoreCertRequirements,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Ssl3', 'Tls', 'Tls11', 'Tls12')]
        [String]$SslProtocol
    )

    try {
        # --- Root is always going to be in the users profile
        $ProfilePath = "$ENV:USERPROFILE\.PowervRA"
        Write-Verbose -Message "Profile path is: $ProfilePath"

        $ProfileConfigurationPath = "$ProfilePath\$($Name.ToUpper())_profile.json"
        
        # --- If .PowervRA directory doesn't exist, create it
        if (!(Test-Path -Path $ProfilePath)) {
            Write-Verbose -Message "Creating profile store: $ProfilePath"
            $null = New-Item -Path $ProfilePath -ItemType Directory -Confirm:$false
        }

        # --- If profile exists, direct user to Set or Remove cmdlets
        if (Test-Path -Path $ProfileConfigurationPath) {
            throw "A profile called $Name already exists. Modify it with Set-vRAConnectionProfile or remove it with Remove-vRAConnectionProfile"
        }

        # --- If SslProtocol hasn't been specified, set it to Default
        $SslProtocolResult = "Default"
        if ($PSBoundParameters.ContainsKey("SslProtocol")) {
            $SslProtocolResult = $SslProtocol
        }

        if ($PSCmdlet.ShouldProcess($Name, "Create Profile")) {
            # --- Assuming that the connection profile is unique, create it
            $ProfileObject = [PSCustomObject]@{
                Name                   = $Name 
                Tenant                 = $Tenant
                Server                 = $Server
                Username               = $Username
                IgnoreCertRequirements = $IgnoreCertRequirements.IsPresent
                SslProtocol            = $SslProtocolResult
            }

            Write-Verbose -Message "Creating profile: $ProfileConfigurationPath"
            ($ProfileObject | ConvertTo-Json) | Out-File -FilePath $ProfileConfigurationPath -Force
            
            Write-Output $ProfileObject
        }
    }
    catch [Exception] {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}