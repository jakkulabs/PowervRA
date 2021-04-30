function New-vRAProject {
<#
    .SYNOPSIS
    Create a vRA Cloud Project

    .DESCRIPTION
    Create a vRA Cloud Project

    .PARAMETER Name
    The name of the Project

    .PARAMETER Description
    A description of the Project

    .PARAMETER Zones
    PSCustomObject(s) with properties for a Cloud Zone

    .PARAMETER Viewers
    Viewers to add to the Project

    .PARAMETER Members
    Members to add to the Project

    .PARAMETER Administrators
    Administrators to add to the Project

    .PARAMETER OperationTimeout
    Operation Timeout

    .PARAMETER SharedResources
    Deployments are shared between all users in the project

    .PARAMETER PlacementPolicy
    Placement Policy

    .PARAMETER CustomProperties
    Specify the custom properties that should be added to all requests in this project

    .PARAMETER JSON
    A JSON string with the body payload

    .INPUTS
    System.String
    System.Switch
    PSCustomObject

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    $CloudZone = [PSCustomObject] @{

        zoneId = 'e6b9d1r2d2115a7558039ae2387c'
        priority = 1
        maxNumberInstances = 10
        memoryLimitMb = 107374
    }

    $CustomProperties = @{}
    $CustomProperties.Add('Property1', "Value1")
    $CustomProperties.Add('Property2', "Value2")

    $ProjectArguments = @{

        Name = 'Test Project'
        Description = 'Test Project'
        Zones = $CloudZone
        Viewers = 'viewer1@test.com'
        Members = 'user1@test.com','user2@test.com'
        Administrators = 'admin1@test.com','admin2@test.com'
        OperationTimeout = 3600
        SharedResources = $true
        CustomProperties = $CustomProperties
    }

    New-vRAProject @ProjectArguments

    .EXAMPLE
    $JSON = @"
        {
            "name": "Test Project",
            "description": "Test Project",
            "zones": [
                {
                    "zoneId": "e6b9d1r2d2115a7558039ae2387c",
                    "priority": 1,
                    "maxNumberInstances": 10,
                    "memoryLimitMB": 107374
                },
                {
                    "zoneId": "r2d2026e33c3648334bcb67eac669",
                    "priority": 2,
                    "maxNumberInstances": 100,
                    "memoryLimitMB": 107374
                }
            ],
            "members": [
                {
                    "email": "user1@test.com"
                },
                {
                    "email": "user2@test.com"
                }
            ],
            "administrators": [
                {
                    "email": "admin1@test.com"
                },
                {
                    "email": "admin2@test.com"
                }
            ],
            "constraints": {},
            "operationTimeout": 3600,
            "sharedResources": true
        }
"@

    $JSON | New-vRAProject
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject[]]$Zones,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Viewers,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Members,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Administrators,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$OperationTimeout,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [Switch]$SharedResources,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateSet("DEFAULT", "SPREAD", IgnoreCase = $false)]
        [String]$PlacementPolicy,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$CustomProperties,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

    )

    begin {

        if ($SharedResources.IsPresent) {

            $SharedResourcesStatus = 'true'
        }
        else {

            $SharedResourcesStatus = 'false'
        }
    }

    process {

            if ($PSBoundParameters.ContainsKey("JSON")) {

                $Data = ($JSON | ConvertFrom-Json)

                $Body = $JSON
                $Name = $Data.name
            }
            else {


                $Body = @"
                    {
                        "name": "$($Name)",
                        "description": "$($Description)",
                        "zoneAssignmentConfigurations": [],
                        "viewers": [],
                        "members": [],
                        "administrators": [],
                        "operationTimeout": $($OperationTimeout),
                        "sharedResources": $($SharedResourcesStatus)
                    }
"@

                $JSONObject = $Body | ConvertFrom-Json

                # --- Add Cloud Zones
                foreach ($Zone in $Zones){

                    $JSONObject.zoneAssignmentConfigurations += $Zone
                }

                # --- Add Viewers
                if ($PSBoundParameters.ContainsKey("Viewers")){

                    foreach ($Viewer in $Viewers){

                        $Addition = @"
                        {
                            "email": "$($Viewer)"
                        }
"@
                        $AdditionObject = $Addition | ConvertFrom-Json
                        $JSONObject.viewers += $AdditionObject
                    }
                }

                # --- Add Members
                if ($PSBoundParameters.ContainsKey("Members")){

                    foreach ($Member in $Members){

                        $Addition = @"
                        {
                            "email": "$($Member)"
                        }
"@
                        $AdditionObject = $Addition | ConvertFrom-Json
                        $JSONObject.members += $AdditionObject
                    }
                }

                # --- Add Administrators
                if ($PSBoundParameters.ContainsKey("Administrators")){

                    foreach ($Administrator in $Administrators){

                        $Addition = @"
                        {
                            "email": "$($Administrator)"
                        }
"@
                        $AdditionObject = $Addition | ConvertFrom-Json
                        $JSONObject.administrators += $AdditionObject
                    }
                }

                # --- Add Placement Policy
                if ($PSBoundParameters.ContainsKey("PlacementPolicy")){

                    $JSONObject | Add-Member -MemberType NoteProperty -Name 'placementPolicy' -Value $PlacementPolicy
                }

                # --- Add Custom Properties
                if ($PSBoundParameters.ContainsKey("CustomProperties")){

                    $JSONObject | Add-Member -MemberType NoteProperty -Name 'customProperties' -Value $CustomProperties
                }

                $Body = $JSONObject | ConvertTo-Json -Depth 5
            }

        # --- Create new Project
        try {
            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/iaas/api/projects"
                $Project = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference

                [PSCustomObject] @{

                    Name = $Project.name
                    Description = $Project.description
                    Id = $Project.id
                    Administrators = $Project.administrators
                    Members = $Project.members
                    Viewers = $Project.viewers
                    Zones = $Project.zones
                    SharedResources = $Project.sharedResources
                    OperationTimeout = $Project.operationTimeout
                    PlacementPolicy = $Project.placementPolicy
                    CustomProperties = $Project.customProperties
                    OrganizationId = $Project.organizationId
                    Links = $Project._links
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