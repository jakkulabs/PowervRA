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

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id

    )
        try {

                $URI = "/composition-service/api/blueprints/$($id)/forms/requestform"

                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method GET -URI $URI
                $CustomForm = $Response.TrimStart('"').TrimEnd('"').Replace('\"','"');
                $CustomForm
                            
        }
        catch [Exception]{

            throw
        }
}
