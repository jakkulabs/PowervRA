function Update-vRACodeStreamVariable {
    <#
        .SYNOPSIS
        Update a vRealize Automation Code Stream Variable

        .DESCRIPTION
        Update a vRealize Automation Code Stream Variable

        .PARAMETER Id
        vRealize Automation Code Stream Variable Id

        .PARAMETER Name
        Name of the vRealize Automation Code Stream Variable

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
        Update-vRACodeStreamVariable -Name "My Variable" -Type REGULAR -Id 05352fc5-24c2-4ead-b6c0-5373e60a1b3d -Description "Updated from PowervRA!" -Value "New value"

        .EXAMPLE
         -Variable "My Variable" | Update-vRACodeStreamVariable -Value "New value" -Description "New Description"

        .EXAMPLE
        $JSON = @"
            {
                "name": "My Variable",
                "description": "My variable description"
                "type": "REGULAR",
                "value": "testing1"
            }
    "@

        $JSON | Update-vRACodeStreamVariable -Id 05352fc5-24c2-4ead-b6c0-5373e60a1b3d


    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

        Param (

            [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName,ParameterSetName="Standard")]
            [ValidateNotNullOrEmpty()]
            [String]$Name,

            [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName,ParameterSetName="Standard")]
            [parameter(ParameterSetName = "JSON")]
            [ValidateNotNullOrEmpty()]
            [String]$Id,

            [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName,ParameterSetName="Standard")]
            [ValidateNotNullOrEmpty()]
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
                            "description": "$($Description)",
                            "type": "$($Type)",
                            "value": "$($Value)"
                        }
"@
                    } else {
                    $Body = @"
                        {
                            "name": "$($Name)",
                            "type": "$($Type)",
                            "value": "$($Value)"
                        }
"@
                    }
                }

            # --- Update the Variable
            try {
                if ($PSCmdlet.ShouldProcess($Id)){

                    $URI = "/pipeline/api/variables/$($Id)"
                    $Variable = Invoke-vRARestMethod -Method PUT -URI $URI -Body $Body -Verbose:$VerbosePreference

                    [PSCustomObject] @{
                        Name = $Variable.name
                        Description = $Variable.description
                        Id = $Variable.id
                        Type = $Variable.type
                        Value = $Variable.value
                        Project = $Variable.project
                    }
                }
            }
            catch [Exception] {

                throw
            }
        }
        end {

        }
    }