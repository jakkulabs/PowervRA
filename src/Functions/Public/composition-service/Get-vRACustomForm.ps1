function Get-vRACustomForm {
<#
    .SYNOPSIS
    Retrieve vRA Custom Form for a Blueprint

    .DESCRIPTION
    Retrieve vRA Custom Form for a Blueprint

    .PARAMETER Id
    Specify the ID of a Blueprint

    .INPUTS
    System.String

    .OUTPUTS
    System.String

    .EXAMPLE
    Get-vRACustomForm -Id "309100fd-b8ce-4e8c-ac8c-a667b8ace54f"

    .EXAMPLE
    Get-vRABlueprint -Name "CentOS" | Get-vRACustomForm


#>
[OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id

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

            foreach ($BlueprintId in $Id){
                $URI = "/composition-service/api/blueprints/$($BlueprintId)/forms/requestform"

                # --- Run vRA REST Request
                Write-Verbose -Message "Getting vRA Custom Form for blueprint $($BlueprintId)"
                try {
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI
                    $ReturnedForm = $Response.TrimStart('"').TrimEnd('"').Replace('\"','"');
                    $CustomForm = StandardOutput($BlueprintId)($ReturnedForm)
                    return $CustomForm
                }
                catch {
                    Write-Warning -Message "Blueprint $($BlueprintId) does not have a custom form"
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
