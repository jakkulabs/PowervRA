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
    Get-vRACustomForm -Id "309100fd-b8ce-4e8c-ac8c-a667b8ace54f"

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id

    )
    begin {
      #Initialize
      Write-Verbose -Message "Initializing..."

    }
    process {
      #Process
      Write-Verbose -Message "Processing..."

        try {

            foreach ($BlueprintId in $Id){
                $URI = "/composition-service/api/blueprints/$($BlueprintId)/forms/requestform"

                # --- Run vRA REST Request
                Write-Verbose -Message "Getting vRA Custom Form for blueprint $($BlueprintId)"
                $Response = Invoke-vRARestMethod -Method GET -URI $URI
                $CustomForm = $Response.TrimStart('"').TrimEnd('"').Replace('\"','"');
                $CustomForm
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
