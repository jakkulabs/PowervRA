function New-vRAPropertyGroup {
    <#
    .SYNOPSIS
    Create a custom Property Group

    .DESCRIPTION
    Create a custom Property Group

    .PARAMETER Name
    The unique name (ID) of the Property

    .PARAMETER Label
    The text to display in forms for the Property

    .PARAMETER Description
    Description of the Property

    .PARAMETER Tenant
    The tenant in which to create the Property Group (Defaults to the connection tenant )

    .PARAMETER Properties
    A hashtable representing the properties you would like to build into this new property group

    .PARAMETER JSON
    Property Group to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    # Create a simple property group with no properties addded
    New-vRAPropertyGroup -Name one

    .EXAMPLE
    # Create a property group with a description and label
    New-vRAPropertyGroup -Name OneWithDescription -Label "On With Description" -Description "This is one with a label and description"

    .EXAMPLE
    # Create a property group with some properties added in simple form
    New-vRAPropertyGroup -Name OneWithPropetiesSimple -Label "One With Properties" -Properties @{"com.org.bool"=$false; "com.org.string"="string1"}

    .EXAMPLE
    # Create a property group with some properties added in the extended form
    New-vRAPropertyGroup -Name OneWithPropertiesExt -Label "One With Properties" -Properties @{"com.org.bool"=@{"mandatory"=$true; "defaultValue"=$false;}; "com.org.encryptedandshowonform"=@{"encrypted"=$true; "visibility"=$true; "defaultValue"="Un-encrypted string";};}

#>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact = "Low",DefaultParameterSetName = 'Default')][OutputType('System.Management.Automation.PSObject')]

    Param (
        [parameter(Mandatory = $true, ParameterSetName = "Default")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Label = $Name,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Tenant = $Script:vRAConnection.Tenant,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "Properties")]
        [ValidateNotNullOrEmpty()]
        [hashtable]$Properties,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

    )

    begin {

        # --- Test for vRA API version
        xRequires -Version 7.0
    }

    process {

        try {
            # --- Set Body for REST request depending on ParameterSet
            if ($PSBoundParameters.ContainsKey("JSON")) {
                $Body = $JSON
            }
            else {
                $propertiesRaw = ""

                # process properties sent in
                foreach ($propKey in $Properties.Keys) {
                    $prop = $Properties[$propKey]
                    switch ($prop.GetType()) {
                        "Hashtable" {
                            $facets = ""
                            foreach ($fKey in $prop.Keys) {
                                $f = $prop[$fKey]
                                switch ($fKey) {
                                    "visibility" {
                                        $facets += @"
                                        "visibility": {
                                            "type": "constant",
                                            "value": {
                                                "type": "boolean",
                                                "value": $($f.toString().toLower())
                                            }
                                },
"@
                                    }
                                    "encrypted" {
                                        $facets += @"
                                        "encrypted": {
                                            "type": "constant",
                                            "value": {
                                                "type": "boolean",
                                                "value": $($f.toString().toLower())
                                            }
                                },
"@
                                    }
                                    "mandatory" {
                                        $facets += @"
                                        "mandatory": {
                                            "type": "constant",
                                            "value": {
                                                "type": "boolean",
                                                "value": $($f.toString().toLower())
                                            }
                                },
"@
                                    }
                                    "defaultValue" {
                                        $facets += @"
                                        "defaultValue": {
                                            "type": "constant",
                                            "value": {
                                                "type": "string",
                                                "value": "$($f)"
                                            }
                                },
"@
                                    }
                                }
                            }
                            $propertiesRaw += @"
                            "$($propKey)": {
                                "facets": { $($facets.Trim(',')) }
                            },
"@
                            break
                        }
                        default {
                            $propertiesRaw += @"
                            "$($propKey)": {
                                "facets": {
                                    "defaultValue": {
                                        "type": "constant",
                                        "value": {
                                            "type": "string",
                                            "value": "$($prop)"
                                        }
                                    }
                                }
                            },
"@
                            break
                        }
                    }
                }
                # logic to build input
                $Body = @"
                {
                    "id" : "$($Name)",
                    "label" : "$($Label)",
                    "description" : "$($Description)",
                    "tenantId" : "$($Tenant)",
                    "version": 0,
                    "properties": { $($propertiesRaw.Trim(',')) }
                }
"@
            }

            $URI = "/properties-service/api/propertygroups"

            Write-Verbose -Message "Preparing POST to $($URI)"

            Write-Verbose -Message "Posting Body: $($Body)"

            # --- Run vRA REST Request
            if ($PSCmdlet.ShouldProcess($Id)) {
                Invoke-vRARestMethod -Method POST -URI $URI -Body $Body | Out-Null
                Get-vRAPropertyGroup -Id $Name
            }
        }
        catch [Exception] {

            throw
        }
    }
    end {

    }
}