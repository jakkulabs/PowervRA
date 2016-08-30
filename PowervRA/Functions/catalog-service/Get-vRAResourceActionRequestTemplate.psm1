function Get-vRAResourceActionRequestTemplate {
<#
    .SYNOPSIS
    Get the request template of a resource action that the user is entitled to see
    
    .DESCRIPTION
    Get the request template of a resource action that the user is entitled to see
    
    .PARAMETER Id
    The id of the resource action

    .PARAMETER Name
    The name of the resource action

    .INPUTS
    System.String

    .OUTPUTS
    System.String

    .EXAMPLE
    Get-vRAResourceActionRequestTemplate -ActionId "fae08c75-3506-40f6-9c9b-35966fe9125c" -ResourceName vm01
    
    .EXAMPLE
    Get-vRAResourceActionRequestTemplate -ActionId "fae08c75-3506-40f6-9c9b-35966fe9125c" -ResourceId 20402e93-fb1d-4bd9-8a51-b809fbb946fd

    .EXAMPLE
    Get-vRAResource -Name vm21 | Get-vRAResourceActionRequestTemplate -Id fae08c75-3506-40f6-9c9b-35966fe9125c
    
#>
[CmdletBinding(DefaultParameterSetName="ByResourceId")][OutputType('System.String')]

    Param (

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [String]$ActionId,
    
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName="ByResourceId")]
        [ValidateNotNullOrEmpty()]
        [String]$ResourceId,

        [Parameter(Mandatory=$true, ParameterSetName="ByResourceName")]
        [ValidateNotNullOrEmpty()]
        [String]$ResourceName
           
    )
    
    Begin {}
 
    Process {

        try {

            if ($PSBoundParameters.ContainsKey("ResourceName")) {

                # --- Get the resource id
                Write-verbose -Message "Retrieving Id for resource $($Name)"
                $Resource = Get-vRAResource -Name $ResourceName
                $ResourceId = $Resource.ResourceId

            }

            $URI = "/catalog-service/api/consumer/resources/$($ResourceId)/actions/$($ActionId)/requests/template"

            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

            $Response | ConvertTo-Json -Depth 100

        }
        catch [Exception]{

            throw

        }

    }

    End {}

}