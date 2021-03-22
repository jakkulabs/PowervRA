function Update-vRAProject {
<#
    .SYNOPSIS
    Update a vRA Cloud Project

    .DESCRIPTION
    Update a vRA Cloud Project

    .PARAMETER Id
    The ID of the Project to update

    .PARAMETER Name
    The Name of the Project to update

    .PARAMETER Description
    A description of the Project

    .PARAMETER Zones
    PSCustomObject(s) with properties for a Cloud Zone

    .PARAMETER Members
    Members to add to the Project

    .PARAMETER Administrators
    Administrators to add to the Project

    .PARAMETER OperationTimeout
    Operation Timeout

    .PARAMETER SharedResources
    Deployments are shared between all users in the project

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

    $ProjectArguments = @{
        Id = 'i84848484848484'
        Name = 'Test Project'
        Description = 'Test Project'
        Zones = $CloudZone
        Members = 'user1@test.com','user2@test.com'
        Administrators = 'admin1@test.com','admin2@test.com'
        OperationTimeout = 3600
        SharedResources = $true
    }

    Update-vRAProject @ProjectArguments

    .EXAMPLE
    $JSON = @"
        {
            "id": "i8585858585858"
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

    $JSON | Update-vRAProject
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="ById")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String]$Id,

        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject[]]$Zones,

        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Members,

        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Administrators,

        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [Int]$OperationTimeout,

        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [Switch]$SharedResources,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

    )

    begin {

        if ($PSBoundParameters.ContainsKey("SharedResources")) {

            $SharedResourcesStatus = 'true'
        }
        else {

            $SharedResourcesStatus = 'false'
        }

        function CalculateOutput([PSCustomObject]$Project) {
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
                OrganizationId = $Project.organizationId
                Links = $Project._links
            }
        }
    }

    process {

        switch ($PsCmdlet.ParameterSetName) {

            # --- Update Project by id
            'ById' {
                if ($null -eq $Name) {
                    # if the user does not provide a name keep the existing
                    $ExistingProject = Get-vRAProject -Id $Id
                    $Name = $ExistingProject.Name
                }
            }

            # --- Update Project by name
            'ByName' {
                # we need the id to do the patch
                $ExistingProject = Get-vRAProject -Name $Name
                $Id = $ExistingProject.Id
            }

            # --- Update Project by JSON
            'JSON' {
                $Data = ($JSON | ConvertFrom-Json)

                $Body = $JSON
                $Name = $Data.name

                if ([bool]($myObject.PSobject.Properties.name -match "Id")) {
                    $Id = $Data.Id
                } else {
                    $ExistingProject = Get-vRAProject -Name $Name
                    $Id = $ExistingProject.Id
                }
                
            }
        }

            if (-not $PSBoundParameters.ContainsKey("JSON")) {


                $Body = @"
                    {
                        "name": "$($Name)",
                        "description": "$($Description)",
                        "zoneAssignmentConfigurations": [],
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

                $Body = $JSONObject | ConvertTo-Json -Depth 5
            }

        # --- Update The Project
        try {
            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/iaas/api/projects"
                $Response = Invoke-vRARestMethod -Method PATCH -URI "$URI`/$Id" -Body $Body -Verbose:$VerbosePreference

                CalculateOutput $Response
            }
        }
        catch [Exception] {

            throw
        }
    }
    end {

    }
}