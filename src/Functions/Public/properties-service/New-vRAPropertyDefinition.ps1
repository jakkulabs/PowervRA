function New-vRAPropertyDefinition {
<#
    .SYNOPSIS
    Create a custom Property Definition

    .DESCRIPTION
    Create a custom Property Definition

    .PARAMETER Name
    The unique name (ID) of the Property

    .PARAMETER Label
    The text to display in forms for the Property

    .PARAMETER Description
    Description of the Property

    .PARAMETER Tenant
    The tenant in which to create the Property Definition (Defaults to the connection tenant )

    .PARAMETER Index
    The display index of the Property

    .PARAMETER Required
    Switch to flag the Property as required

    .PARAMETER Encrypted
    Switch to flag the Property as Encrypted

    .PARAMETER String
    Switch to flag the Property type as String

    .PARAMETER StringDisplay
    The form display option for the Property

    .PARAMETER Boolean
    Switch to flag the Property type as Boolean

    .PARAMETER BooleanDisplay
    The form display option for the Property

    .PARAMETER Integer
    Switch to flag the Property type as Integer

    .PARAMETER IntegerDisplay
    The form display option for Integer

    .PARAMETER Decimal
    Switch to flag the Property type as Decimal

    .PARAMETER DecimalDisplay
    The form display option for Decimal

    .PARAMETER Datetime
    Switch to flag the Property type as Datetime

    .PARAMETER DatetimeDisplay
    The form display option for Datetime

    .PARAMETER JSON
    Property Definition to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    # Create a string dropdown with defined values
    New-vRAPropertyDefinition -Name one -String -StringDisplay DROPDOWN -ValueType Static -Values @{Name1="Value1";Name2="Value2"}

    .EXAMPLE
    # Create an integer slider with min, max and increment
    New-vRAPropertyDefinition -Name IntegerName -Label "Select an Integer" -Integer -IntegerDisplay SLIDER -MinimumValue 1 -MaximumValue 10 -Increment 1

    .EXAMPLE
    # Create a boolean checkbox
    New-vRAPropertyDefinition -Name BooleanName -Label "Check this box" -Boolean -BooleanDisplay CHECKBOX

    .EXAMPLE
    # Create a new decimal slider with min, max and increment
    New-vRAPropertyDefinition -Name DecimalTest -Decimal -DecimalDisplay SLIDER -MinimumValue 0 -MaximumValue 10 -Increment 0.5

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")][OutputType('System.Management.Automation.PSObject')]

    Param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Label = $Name,

        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Tenant = $Script:vRAConnection.Tenant,

        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Int]$Index,

        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Switch]$Required,

        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Switch]$Encrypted,

        [parameter(Mandatory=$false,ParameterSetName="String")]
        [ValidateNotNullOrEmpty()]
        [Switch]$String,

        [parameter(Mandatory=$true,ParameterSetName="String")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("DROPDOWN","TEXTBOX","EMAIL","HYPERLINK","TEXTAREA")]
        [String]$StringDisplay,

        [parameter(Mandatory=$false,ParameterSetName="Boolean")]
        [ValidateNotNullOrEmpty()]
        [Switch]$Boolean,

        [parameter(Mandatory=$true,ParameterSetName="Boolean")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("CHECKBOX","YES_NO")]
        [String]$BooleanDisplay,

        [parameter(Mandatory=$false,ParameterSetName="Integer")]
        [ValidateNotNullOrEmpty()]
        [Switch]$Integer,

        [parameter(Mandatory=$true,ParameterSetName="Integer")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("DROPDOWN","SLIDER","TEXTBOX")]
        [String]$IntegerDisplay,

        [parameter(Mandatory=$false,ParameterSetName="Decimal")]
        [ValidateNotNullOrEmpty()]
        [Switch]$Decimal,

        [parameter(Mandatory=$true,ParameterSetName="Decimal")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("DROPDOWN","SLIDER","TEXTBOX")]
        [String]$DecimalDisplay,

        [parameter(Mandatory=$false,ParameterSetName="Datetime")]
        [ValidateNotNullOrEmpty()]
        [Switch]$Datetime,

        [parameter(Mandatory=$true,ParameterSetName="Datetime")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("DATE_TIME_PICKER")]
        [String]$DatetimeDisplay, # This is redundant, only one option

        [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

    )

    DynamicParam {
        if ($PSBoundParameters.ContainsKey("JSON")){
                # Do not evaluate dynamic parameters for JSON input
                return;
        } else {
            $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            if($StringDisplay -eq "DROPDOWN") {
                $ValueTypes = "Static","Dynamic"
                NewDynamicParam -Name "EnableCustomValues" -Type switch -ParameterSet "String" -DPDictionary $Dictionary
                NewDynamicParam -Name "ValueType" -Mandatory -ValidateSet $ValueTypes -ParameterSet "String" -DPDictionary $Dictionary
                NewDynamicParam -Name "Values" -Type hashtable -Mandatory -ParameterSet "String" -DPDictionary $Dictionary
            }

            if($Integer) {
                if($IntegerDisplay -eq "DROPDOWN") {
                    # Dropdown should have value type (static or dynamic) and a hashtable of values
                    $ValueTypes = "Static","Dynamic"
                    NewDynamicParam -Name "EnableCustomValues" -Type switch -ParameterSet "Integer" -DPDictionary $Dictionary
                    NewDynamicParam -Name "ValueType" -Mandatory -ValidateSet $ValueTypes -ParameterSet "Integer" -DPDictionary $Dictionary
                    NewDynamicParam -Name "Values" -Type hashtable -Mandatory -ParameterSet "Integer" -DPDictionary $Dictionary
                } elseif($IntegerDisplay -eq "SLIDER") {
                    # Min/Max value are mandatory for a slider
                    NewDynamicParam -Name "MinimumValue" -Mandatory -Type int -ParameterSet "Integer" -DPDictionary $Dictionary
                    NewDynamicParam -Name "MaximumValue" -Mandatory -Type int -ParameterSet "Integer" -DPDictionary $Dictionary
                    NewDynamicParam -Name "Increment" -Type decimal -ParameterSet "Integer" -DPDictionary $Dictionary
                } else {
                    # Otherwise add some optional for Integers
                    NewDynamicParam -Name "MinimumValue" -Type int -ParameterSet "Integer" -DPDictionary $Dictionary
                    NewDynamicParam -Name "MaximumValue" -Type int -ParameterSet "Integer" -DPDictionary $Dictionary
                    NewDynamicParam -Name "Increment" -Type decimal -ParameterSet "Integer" -DPDictionary $Dictionary
                }
            }

            if($Decimal) {
                if($DecimalDisplay -eq "DROPDOWN") {
                    # Dropdown should have value type (static or dynamic) and a hashtable of values
                    $ValueTypes = "Static","Dynamic"
                    NewDynamicParam -Name "EnableCustomValues" -Type switch -ParameterSet "Decimal" -DPDictionary $Dictionary
                    NewDynamicParam -Name "ValueType" -Mandatory -ValidateSet $ValueTypes -ParameterSet "Decimal" -DPDictionary $Dictionary
                    NewDynamicParam -Name "Values" -Type hashtable -Mandatory -ParameterSet "Decimal" -DPDictionary $Dictionary
                } elseif($IntegerDisplay -eq "SLIDER") {
                    # Min/Max value are mandatory for a slider
                    NewDynamicParam -Name "MinimumValue" -Mandatory -Type decimal -ParameterSet "Decimal" -DPDictionary $Dictionary
                    NewDynamicParam -Name "MaximumValue" -Mandatory -Type decimal -ParameterSet "Decimal" -DPDictionary $Dictionary
                    NewDynamicParam -Name "Increment" -Type decimal -ParameterSet "Decimal" -DPDictionary $Dictionary
                } else {
                    # Otherwise add some optional for Decimal
                    NewDynamicParam -Name "MinimumValue" -Type decimal -ParameterSet "Decimal" -DPDictionary $Dictionary
                    NewDynamicParam -Name "MaximumValue" -Type decimal -ParameterSet "Decimal" -DPDictionary $Dictionary
                    NewDynamicParam -Name "Increment" -Type decimal -ParameterSet "Decimal" -DPDictionary $Dictionary
                }
            }
            if($Datetime) {
                # TODO - Datetime needs to be a string as UniversalSortableDateTimePattern
                NewDynamicParam -Name "MinimumValue" -Type DateTime -ParameterSet "Datetime" -DPDictionary $Dictionary
                NewDynamicParam -Name "MaximumValue" -Type DateTime -ParameterSet "Datetime" -DPDictionary $Dictionary
            }
            return $Dictionary
        }
    }

    begin {

        # --- Test for vRA API version
        xRequires -Version 7.0

        #Get common parameters, pick out bound parameters not in that set
        Function intTemp { [cmdletbinding()] param() }
        $BoundKeys = $PSBoundParameters.keys | Where-Object { (get-command intTemp | Select-Object -ExpandProperty parameters).Keys -notcontains $_}
        foreach($param in $BoundKeys) {
            if (-not ( Get-Variable -name $param -scope 0 -ErrorAction SilentlyContinue ) ) {
                New-Variable -Name $Param -Value $PSBoundParameters.$param
                Write-Verbose "Adding variable for dynamic parameter '$param' with value '$($PSBoundParameters.$param)'"
            }
        }
    }

    process {

        try {
            # --- Set Body for REST request depending on ParameterSet
            if ($PSBoundParameters.ContainsKey("JSON")){
                $Body = $JSON
            }
            else {
                $MultiValued = if($IsMultiValued) { "true" } else { "false" }
                $Mandatory = if($Required) { "true" } else { "false" }
                $CustomValues = if($AllowCustomValues) { "true" } else { "false" }
                if($Index -eq 0) {
                    $IndexString = "null"
                } else {
                    $IndexString = $Index.ToString()
                }
                if($String) {
                    $DataType = "STRING"
                    $Display = $StringDisplay
                }
                if($Boolean) {
                    $DataType = "BOOLEAN"
                    $Display = $BooleanDisplay
                }
                if($Integer) {
                    $DataType = "INTEGER"
                    $Display = $IntegerDisplay
                }
                if($Decimal) {
                    $DataType = "DECIMAL"
                    $Display = $DecimalDisplay
                }
                if($Datetime) {
                    $DataType = "DATETIME"
                    $Display = $DatetimeDisplay
                }

                # $DataType BOOLEAN cannot be Required
                $facets = ""
                if($DataType -ne "BOOLEAN") {
                    $facets = @"
                        "mandatory": {
                            "type": "constant",
                            "value": {
                                "type": "boolean",
                                "value": $($Mandatory)
                            }
                        },
"@
                }
                     $facets += @"
                        "encrypted": {
                            "type": "constant",
                            "value": {
                                "type": "boolean",
                                "value": $($Encrypted.ToString().ToLower())
                            }
                        },
"@
               if($MinimumValue) {
                    $facets += @"
                        "minValue": {
                            "type": "constant",
                            "value": {
                                "type": "integer",
                                "value": $($MinimumValue)
                            }
                        },
"@
               }
               if($MaximumValue) {
                    $facets += @"
                        "maxValue": {
                            "type": "constant",
                            "value": {
                                "type": "integer",
                                "value": $($MaximumValue)
                            }
                        },
"@
               }
               if($Increment) {
                    $facets += @"
                        "increment": {
                            "type": "constant",
                            "value": {
                                "type": "decimal",
                                "value": $($Increment)
                            }
                        },
"@
               }

                # Build permissible values
                if($ValueTypes -eq "Static") {
                    $ValueJSON = ""
                    foreach($Value in $Values.GetEnumerator()) {
                        $ValueJSON += @"
                        {
                            "underlyingValue": {
                                "type": "$($DataType.ToLower())",
                                "value": "$($Value.Value)"
                            },
                            "label": "$($Value.Name)"
                        },
"@
                    }
                    $PermissibleValues = @"
                    "permissibleValues": {
                        "type": "static",
                        "customAllowed": $($CustomValues),
                        "values": [
$($ValueJSON.Trim(","))
                        ]
                    },
"@
            } elseif($ValueTypes -eq "Dynamic") {
                # Not implemented yet!!
                $PermissibleValues = @"
                    "permissibleValues": {
                        "type": "dynamic",
                        "customAllowed": false,
                        "dependencies": [],
                        "context": {
                            "providerEntityId": "com.vmware.library.vc.storage/listDatastores",
                            "parameterMappings": {
                                "params": [
                                    {
                                    "key": "host",
                                        "value": {
                                            "type": "constant",
                                            "value": {
                                                "type": "string",
                                                "value": ""
                                            }
                                        }
                                    }
                                ]
                            }
                        }
                    },
"@
                } else {
                    $PermissibleValues = @"
                    "permissibleValues": null,
"@
                }


                $Body = @"
                {
                    "id" : "$($Name)",
                    "label" : "$($Label)",
                    "description" : "$($Description)",
                    "dataType" : {
                        "type" : "primitive",
                        "typeId" : "$($DataType)"
                    },
                    "isMultiValued" : $($MultiValued),
                    "displayAdvice" : "$($Display)",
                    "tenantId" : "$($Tenant)",
                    "orderIndex": $($IndexString),
$($PermissibleValues)
                    "facets": {
$($facets.Trim(","))
                    }
                }
"@

            }

            $URI = "/properties-service/api/propertydefinitions"

            Write-Verbose -Message "Preparing POST to $($URI)"

            # --- Run vRA REST Request
            if ($PSCmdlet.ShouldProcess($Id)) {

                Invoke-vRARestMethod -Method POST -URI $URI -Body $Body | Out-Null
                Get-vRAPropertyDefinition -Id $Name
            }
        }
        catch [Exception]{

            throw
        }
    }
    end {

    }
}