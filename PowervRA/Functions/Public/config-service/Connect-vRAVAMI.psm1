function Connect-vRAVAMI {
<#
    .SYNOPSIS
    Connect to a vRA Appliance
    
    .DESCRIPTION
    Connect to a vRA Appliance and generate a connection object with Servername, Token etc
    
    .PARAMETER Server
    vRA Appliance to connect to

    .PARAMETER Username
    Username to connect with

    .PARAMETER Password
    Password to connect with

    .PARAMETER Credential
    Credential object to connect with

    .PARAMETER IgnoreCertRequirements
    Ignore requirements to use fully signed certificates

    .INPUTS
    System.String
    Management.Automation.PSCredential
    Switch

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Connect-vRAVAMI -Server vraappliance01.domain.local -Username root -Password P@ssword -IgnoreCertRequirements

    .EXAMPLE
    Connect-vRAVAMI -Server vraappliance01.domain.local -Credential (Get-Credential)
#>
[CmdletBinding(DefaultParametersetName="Username")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Server,
    
    [parameter(Mandatory=$true,ParameterSetName="Username")]
    [ValidateNotNullOrEmpty()]
    [String]$Username,

    [parameter(Mandatory=$true,ParameterSetName="Username")]
    [ValidateNotNullOrEmpty()]
    [String]$Password,

    [Parameter(Mandatory=$true,ParameterSetName="Credential")]
	[ValidateNotNullOrEmpty()]
	[Management.Automation.PSCredential]$Credential,

    [parameter(Mandatory=$false)]
    [Switch]$IgnoreCertRequirements
    )       

if ($PSBoundParameters.ContainsKey("Credential")){

    $Username = $Credential.UserName
    $Password = $Credential.GetNetworkCredential().Password
}        
       
try {

    # --- Create Invoke-RestMethod Parameters
    $base64cred = [system.convert]::ToBase64String(
        [system.text.encoding]::UTF8.Getbytes(
            "$($Username):$($Password)"
        )
    )
    $Method = "GET"
    $URI = "https://$($Server):5480/config/version"
    $Headers = @{
        "Authorization"="Basic $($base64cred)";
        "Accept"="application/json";
        "Content-Type" = "application/json"
    }

 
    # --- Run vRA REST Request

    $Response = Invoke-RestMethod -Method $Method -Uri $URI -Headers $Headers -ErrorAction Stop
      
    # --- Create Output Object
                
    $Global:vRAVAMIConnection = [pscustomobject]@{                        
        Token = $base64cred          
        Appliance = "https://$($Server):5480/config"
        Username = $Username
        APIVersion = $Response
        SignedCertificates = $SignedCertificates
    }
}
catch [Exception]{

    throw
}
}
