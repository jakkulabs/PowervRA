function New-vRACodeStreamVariable {
    <#
        .SYNOPSIS
        Create a vRealize Automation Code Stream Variable

        .DESCRIPTION
        Create a vRealize Automation Code Stream Variable

        .PARAMETER Name
        Name of the vRealize Automation Code Stream Variable

        .PARAMETER Project
        Name of the vRealize Automation Code Stream Project

        .PARAMETER Description
        A description of the vRealize Automation Code Stream Variable

        .PARAMETER Value
        vRealize Automation Code Stream Variable Value

        .PARAMETER Type
        vRealize Automation Code Stream Variable Type

        .PARAMETER JSON
        A JSON string with the body payload

        .INPUTS
        System.String

        .OUTPUTS
        System.Management.Automation.PSObject

        .EXAMPLE
        New-vRACodeStreamVariable -Name "My Variable" -Type REGULAR -Project "Development" -Description "Create from PowervRA!" -Value "New value"

        .EXAMPLE
        $JSON = @"
            {
                "name": "My Variable",
                "project": "Development",
                "description": "My variable description"
                "type": "REGULAR",
                "value": "testing1"
            }
    "@

        $JSON | New-vRACodeStreamVariable


    #>
    [CmdletBinding(ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

        Param (

            [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName,ParameterSetName="Standard")]
            [ValidateNotNullOrEmpty()]
            [String]$Name,
            
            [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName,ParameterSetName="Standard")]
            [ValidateNotNullOrEmpty()]
            [String]$Project,

            [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName,ParameterSetName="Standard")]
            [String]$Description,

            [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName,ParameterSetName="Standard")]
            [ValidateSet("REGULAR","SECRET","RESTRICTED")] 
            [ValidateNotNullOrEmpty()]
            [String]$Type,

            [Parameter(Mandatory=$true,ParameterSetName="Standard")]
            [ValidateNotNullOrEmpty()]
            [String]$Value,

            [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
            [ValidateNotNullOrEmpty()]
            [String]$JSON

        )

        begin { }

        process {

                if ($PSBoundParameters.ContainsKey("JSON")) {
                    $Body = $JSON
                } else {
                    if($Description) {
                        $Body = @"
                        {
                            "name": "$($Name)",
                            "project": "$($Project)",
                            "description": "$($Description)",
                            "type": "$($Type)",
                            "value": "$($Value)"
                        }
"@
                    } else {
                    $Body = @"
                        {
                            "name": "$($Name)",
                            "project": "$($Project)",
                            "type": "$($Type)",
                            "value": "$($Value)"
                        }
"@
                    }
                }
            # --- Create the Variable
            try {
                $URI = "/pipeline/api/variables/"
                $Variable = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference

                [PSCustomObject]@{
                    Name = $Variable.name
                    Description = $Variable.description
                    Id = $Variable.id
                    Type = $Variable.type
                    Value = $Variable.value
                    Project = $Variable.project
                }
            }
            catch [Exception] {

                throw
            }
        }
        end {

        }
    }