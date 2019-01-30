function Get-vRACustomForm {
<#
    .SYNOPSIS
    Retrieve vRA Custom Form for a Blueprint

    .DESCRIPTION
    Retrieve vRA Custom Form for a Blueprint

    .PARAMETER BlueprintId
    Specify the ID of a Blueprint

    .INPUTS
    System.String

    .OUTPUTS
    System.String

    .EXAMPLE
    Get-vRACustomForm -BlueprintId "CentOS"

    .EXAMPLE
    Get-vRABlueprint -Name "CentOS" | Get-vRACustomForm


#>
[OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [Alias("id")]
    [ValidateNotNullOrEmpty()]
    [String[]]$BlueprintId

    )
    begin {
      #Initialize
      Write-Verbose -Message "Initializing..."

      #Create PSObject for Output
      function StandardOutput ($Blueprint,$CustomForm){
          [pscustomobject]@{

            BlueprintID = $Blueprint
            JSON = $CustomForm

          }
      }

      #Test vRA API version
      xRequires -Version 7.4

    }
    process {
      #Process
      Write-Verbose -Message "Processing..."

        try {

            foreach ($bp in $BlueprintId){
                $URI = "/composition-service/api/blueprints/$($bp)/forms/requestform"

                # --- Run vRA REST Request
                Write-Verbose -Message "Getting vRA Custom Form for blueprint $($bp)"
                try {
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI
                    $ReturnedForm = $Response.TrimStart('"').TrimEnd('"').Replace('\"','"');
                    StandardOutput($bp)($ReturnedForm)
                }
                catch {
                    Write-Warning -Message "Blueprint $($bp) does not have a custom form"
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
