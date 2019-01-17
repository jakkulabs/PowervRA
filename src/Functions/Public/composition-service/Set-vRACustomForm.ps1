function Set-vRACustomForm {
<#
    .SYNOPSIS
    Enable or Disable vRA Custom Form for a Blueprint

    .DESCRIPTION
    Enable or Disable a vRA Custom Form to a Blueprint

    .PARAMETER blueprintId
    The objectId of the blueprint

    .PARAMETER action
    The action to take on the Custom Form of the Blueprint

    .INPUTS
    System.String

    .OUTPUTS
    System.String

    .EXAMPLE
    Set-vRACustomForm -blueprintId "CentOS" -action Enabled

    .EXAMPLE
    Set-vRACustomForm -blueprintId "CentOS" -action Disabled

    .EXAMPLE
    Get-vRABlueprint -Name "CentOS" | Set-vRACustomForm -action Enabled


#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.String')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNullOrEmpty()]
    [Alias("id")]
    [String[]]$blueprintId

    [parameter(Mandatory=$true,ValueFromPipeline=$false))]
    [ValidateSet("Enable","Disable")]
    [String]$action

    )
    begin {
      #Initialize
      Write-Verbose -Message "Initializing..."

      #Change action to lower
      $action = $action.ToLower()

      #Test vRA API version
      xRequires -Version 7.4

    }
    process {
      #Process
      Write-Verbose -Message "Processing..."

        try {

            foreach ($bp in $blueprintId){
                Write-Verbose -Message "Executing action $($action) on blueprint $($bp)"
                $URI = "/composition-service/api/blueprints/$($BlueprintId)/forms/requestform/$($action)"

                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method GET -URI $URI
                return $Response

            }

        }
        catch [Exception]{
            throw
        }
    }
    end {
      #Finalize
      Write-Verbose -Message "Finalizing..."

    }
}
