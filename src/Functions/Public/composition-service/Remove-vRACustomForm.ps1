function Remove-vRACustomForm {
<#
    .SYNOPSIS
    Remove a vRA Custom Form for a Blueprint

    .DESCRIPTION
    Remove a vRA Custom Form for a Blueprint

    .PARAMETER BlueprintId
    Specify the ID of a Blueprint

    .INPUTS
    System.String

    .EXAMPLE
    Remove-vRACustomForm -BlueprintId "CentOS"

    .EXAMPLE
    Get-vRABlueprint -Name "CentOS" | Remove-vRACustomForm


#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param (

      [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
      [Alias("id")]
      [ValidateNotNullOrEmpty()]
      [String[]]$BlueprintId

    )
    begin {
      #Initialize
      Write-Verbose -Message "Initializing..."

      #Test vRA API version
      xRequires -Version 7.4

    }
    process {
      #Process
      Write-Verbose -Message "Processing..."

        try {
            foreach ($bp in $blueprintId){
                if($PSCmdlet.ShouldProcess($bp)){
                    $URI = "/composition-service/api/blueprints/$($bp)/forms/requestform"

                    # --- Run vRA REST Request
                    Write-Verbose -Message "Removing vRA Custom Form for blueprint $($bp)"
                    $Response = Invoke-vRARestMethod -Method DELETE -URI $URI
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
