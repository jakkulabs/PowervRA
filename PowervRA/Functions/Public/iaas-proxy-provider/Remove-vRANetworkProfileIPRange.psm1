function Remove-vRANetworkProfileIPRange {
<#
    .SYNOPSIS
    Remove an ip range from a network profile
    
    .DESCRIPTION
    Remove an ip range from a network profile
        
    .PARAMETER NetworkProfileId
    The id of the network profile

    .PARAMETER Name
    The name of the network profile ip range

    .INPUTS
    System.String

    .EXAMPLE
    Get-vRANetworkProfile -Name "External" | Remove-vRANetworkProfileIPRange -Name "External-Range-01"

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param (

        [Alias("Id")]
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String]$NetworkProfileId,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name   
       
    )
    
    begin {

        xRequires -Version 7.1

    }
    
    process {    

        try {

            foreach ($NetworkProfileName in $Name) {

                # --- Get the network profile to modify
                $NetworkProfile = Invoke-vRARestMethod -Method GET -URI "/iaas-proxy-provider/api/network/profiles/$($NetworkProfileId)" -Verbose:$VerbosePreference

                #--- Test to see if the specified range exists

                if(!($NetworkProfile.definedRanges | Where-Object {$_.name -eq $NetworkProfileName})) {

                    throw "Could not find an IP Range with name $($NetworkProfileName)"

                }

                # --- Create a new array
                Write-Verbose -Message "Removing IP Range $($NetworkProfileName) From Network Profile $($NetworkProfile.name)"
                
                $NetworkProfile.definedRanges = @($NetworkProfile.definedRanges | Where-Object {$_.name -ne $NetworkProfileName})

                if ($PSCmdlet.ShouldProcess($NetworkProfileId)){

                    $URI = "/iaas-proxy-provider/api/network/profiles/$($NetworkProfileId)"
            
                    Invoke-vRARestMethod -Method PUT -URI $URI -Body ($NetworkProfile | ConvertTo-Json -Depth 20 -Compress) -Verbose:$VerbosePreference | Out-Null

                }
      
            }

        }
        catch [Exception]{
        
            throw

        }
        
    }   
     
}