function Set-vRACustomForm {
<#
    .SYNOPSIS
    Enable or Disable vRA Custom Form for a Blueprint

    .DESCRIPTION
    Enable or Disable a vRA Custom Form to a Blueprint

    .PARAMETER BlueprintId
    The objectId of the blueprint

    .PARAMETER Action
    The action to take on the Custom Form of the Blueprint

    .INPUTS
    System.String

    .OUTPUTS
    System.String

    .EXAMPLE
    Set-vRACustomForm -BlueprintId "CentOS" -Action Enable

    .EXAMPLE
    Set-vRACustomForm -BlueprintId "CentOS" -Action Disable

    .EXAMPLE
    Get-vRABlueprint -Name "CentOS" | Set-vRACustomForm -Action Enable


#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.String')]

    Param (

      [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
      [Alias("id")]
      [ValidateNotNullOrEmpty()]
      [String[]]$BlueprintId,

      [parameter(Mandatory=$true,ValueFromPipeline=$false)]
      [ValidateSet("Enable","Disable")]
      [String]$Action

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
                if($PSCmdlet.ShouldProcess($bp)){
                    Write-Verbose -Message "Executing action $($action) on blueprint $($bp)"
                    $URI = "/composition-service/api/blueprints/$($bp)/forms/requestform/$($action)"

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI
                    $Response
                }
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
