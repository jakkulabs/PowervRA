function Get-vRABlueprint {
<#
    .SYNOPSIS
    Retrieve vRA Blueprints

    .DESCRIPTION
    Retrieve vRA Blueprints

    .PARAMETER Id
    Specify the ID of a Blueprint

    .PARAMETER Name
    Specify the Name of a Blueprint

    .PARAMETER ExtendedProperties
    Return Blueprint Extended Properties. Performance will be slower since
    additional API requests may be required

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRABlueprint

    .EXAMPLE
    Get-vRABlueprint -Id "309100fd-b8ce-4e8c-ac8c-a667b8ace54f"

    .EXAMPLE
    Get-vRABlueprint -Name "Blueprint01","Blueprint02"

    .EXAMPLE
    Get-vRABlueprint -Name "Blueprint01","Blueprint02" -ExtendedProperties
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,

    [parameter(Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name,

    [parameter(Mandatory=$false,ValueFromPipeline=$false)]
    [Switch]$ExtendedProperties,

    [parameter(Mandatory=$false,ValueFromPipeline=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100"
    )

    # --- Add begin, process, end
    # -- Functions for standard and extended output
    begin {

        # --- Test for vRA API version
        xRequires -Version 7.0

        function StandardOutput ($Blueprint) {

            [pscustomobject]@{

                Name = $Blueprint.name
                Id = $Blueprint.id
                Description = $Blueprint.description
                CreatedDate = $Blueprint.createdDate
                LastUpdated = $Blueprint.lastUpdated
                Version = $Blueprint.version
                PublishStatus = $Blueprint.publishStatusName
            }
        }
        function ExtendedOutput ($Blueprint) {

            [pscustomobject]@{

                Name = $Blueprint.name
                Id = $Blueprint.id
                Description = $Blueprint.description
                CreatedDate = $Blueprint.createdDate
                LastUpdated = $Blueprint.lastUpdated
                Version = $Blueprint.version
                PublishStatus = $Blueprint.publishStatusName
                Components = $Blueprint.components
                Properties = $Blueprint.properties
                PropertyGroups = $Blueprint.propertyGroups
                ExternalId = $Blueprint.externalId
                Layout = $Blueprint.layout
                SnapshotVersion = $Blueprint.snapshotVersion
            }
        }
    }

    process {

        try {
            switch ($PsCmdlet.ParameterSetName)
            {
                "ById"  {

                    foreach ($BlueprintId in $Id){

                        $URI = "/composition-service/api/blueprints/$($BlueprintId)"

                        # --- Run vRA REST Request
                        $ReturnedBlueprint = Invoke-vRARestMethod -Method GET -URI $URI

                        if ($PSBoundParameters.ContainsKey('ExtendedProperties')){

                            ExtendedOutput($ReturnedBlueprint)
                        }
                        else {
                            StandardOutput($ReturnedBlueprint)
                        }
                    }

                    break
                }

                "ByName"  {

                foreach ($BlueprintName in $Name){

                        $URI = "/composition-service/api/blueprints?`$filter=name%20eq%20'$($BlueprintName)'"

                        # --- Run vRA REST Request
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI
                        $Blueprints = $Response.content

                        if (-not $Blueprints){

                            throw "Unable to find vRA Blueprint: $($BlueprintName)"
                        }

                        foreach ($ReturnedBlueprint in $Blueprints){

                            if ($PSBoundParameters.ContainsKey('ExtendedProperties')){

                                $URI = "/composition-service/api/blueprints/$($ReturnedBlueprint.id)"

                                # --- Run vRA REST Request
                                $ReturnedExtendedBlueprint = Invoke-vRARestMethod -Method GET -URI $URI

                                ExtendedOutput($ReturnedExtendedBlueprint)
                            }
                            else {

                                StandardOutput($ReturnedBlueprint)
                            }
                        }
                    }

                    break
                }

                "Standard"  {

                    $URI = "/composition-service/api/blueprints?limit=$($Limit)"

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method GET -URI $URI
                    $Blueprints = $Response.content

                    foreach ($ReturnedBlueprint in $Blueprints){

                        if ($PSBoundParameters.ContainsKey('ExtendedProperties')){

                            $URI = "/composition-service/api/blueprints/$($ReturnedBlueprint.id)"

                            # --- Run vRA REST Request
                            $ReturnedExtendedBlueprint = Invoke-vRARestMethod -Method GET -URI $URI

                            ExtendedOutput($ReturnedExtendedBlueprint)
                        }
                        else {

                            StandardOutput($ReturnedBlueprint)
                        }
                    }

                    break
                }
            }
        }
        catch [Exception]{

            throw
        }
    }
    end {

    }
}