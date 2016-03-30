function New-vRAContentPackage {
<#
    .SYNOPSIS
    Create a vRA Content Package
    
    .DESCRIPTION
    Create a vRA ContentPackage
    
    .PARAMETER Name
    Content Package Name
    
    .PARAMETER Description
    Content Package Description

    .PARAMETER BlueprintId
    Blueprint Ids to include in the Content Package

    .PARAMETER BlueprintName
    Blueprint Names to include in the Content Package

    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRAContentPackage -Name ContentPackage01 -Description "This is Content Package 01" -BlueprintId "58e10956-172a-48f6-9373-932f99eab37a","0c74b085-dbc1-4fea-9cbf-a1601f668a1f"

    .EXAMPLE
    New-vRAContentPackage -Name ContentPackage01 -Description "This is Content Package 01" -BlueprintName "Blueprint01","Blueprint02"
    
    .EXAMPLE
    $JSON = @"
    {
        "name":"ContentPackage01",
        "description":"This is Content Package 01",
        "contents":[ "58e10956-172a-48f6-9373-932f99eab37a","0c74b085-dbc1-4fea-9cbf-a1601f668a1f" ]
    }
    "@
    $JSON | New-vRAContentPackage
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="ById")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ParameterSetName="ById")]
    [parameter(Mandatory=$true,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Description,

    [parameter(Mandatory=$true,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$BlueprintId,

    [parameter(Mandatory=$true,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$BlueprintName,

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
    [ValidateNotNullOrEmpty()]
    [String]$JSON
    )    

    begin {
    
    }
    
    process {

        switch ($PsCmdlet.ParameterSetName) 
        { 
            "ById"  {                

                $Object = [pscustomObject] @{

                    name = $Name
                    description = $Description
                    contents = @()
                }

                foreach ($Id in $BlueprintId) {

                    $Object.contents += $Id

                }

                $Body = $Object | ConvertTo-Json                    

                break
            }

            "ByName"  {
                
                $Object = [pscustomObject] @{

                    name = $Name
                    description = $Description
                    contents = @()
                }

                foreach ($BPName in $BlueprintName) {

                    $Id = (Get-vRABlueprint -Name $BPName).Id

                    $Object.contents += $Id

                }

                $Body = $Object | ConvertTo-Json 
                
                break
            }

            "JSON"  {

                $Data = ($JSON | ConvertFrom-Json)
        
                $Body = $JSON
                $Name = $Data.name  
                
                break
            }
        }

        if ($PSCmdlet.ShouldProcess($Name)){

            $URI = "/content-management-service/api/packages"

            # --- Run vRA REST Request
            $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body

            # --- Output the Successful Result
            Get-vRAContentPackage -Name $Name
        } 
    }
    end {
        
    }
}