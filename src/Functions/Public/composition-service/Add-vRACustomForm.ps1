function Add-vRACustomForm {
<#
    .SYNOPSIS
    Add a vRA Custom Form for a Blueprint

    .DESCRIPTION
    Add a vRA Custom Form for a Blueprint

    .PARAMETER BlueprintId
    Specify the ID of a Blueprint

    .PARAMETER Body
    The JSON string containing the custom form

    .INPUTS
    System.String

    .OUTPUTS
    System.String

    .EXAMPLE
    $JSON = Get-Content -Path ~/CentOS.json -Raw
    Add-vRACustomForm -BlueprintId "CentOS" -Body $JSON

    .EXAMPLE
    $JSON = Get-Content -Path ~/CentOS.json -Raw
    Get-vRABlueprint -Name "CentOS" | Add-vRACustomForm -Body $JSON

    .EXAMPLE
    $Form = Get-vRABlueprint -Name "CentOS" | Get-vRACustomForm
    Add-vRACustomForm -BlueprintId "RHEL7" | Add-vRACustomForm -Body $Form.JSON


#>
[OutputType('System.Management.Automation.PSObject')]

    Param (

      [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
      [Alias("id")]
      [ValidateNotNullOrEmpty()]
      [String[]]$BlueprintId,

      [parameter(Mandatory=$true,ValueFromPipeline=$false)]
      [ValidateNotNullOrEmpty()]
      [String]$Body

    )
    begin {
      #Initialize
      Write-Verbose -Message "Initializing..."

      #Create PSObject for Output
      function StandardOutput ($Blueprint,$CustomFormId){
          [pscustomobject]@{

            BlueprintID = $Blueprint
            CustomFormId = $CustomFormId

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
                $JSON = $Body
                # --- Run vRA REST Request
                Write-Verbose -Message "Removing vRA Custom Form for blueprint $($bp)"
                $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $JSON
                return StandardOutput($bp)($Response)

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
