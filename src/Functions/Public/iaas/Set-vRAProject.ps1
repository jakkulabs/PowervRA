function Set-vRAProject {
<#
    .SYNOPSIS
    Update a vRA Cloud Project

    .DESCRIPTION
    Update a vRA Cloud Project

    .PARAMETER Id
    The ID of the Project to update

    .PARAMETER Name
    The Name of the Project to update

    .PARAMETER NewName
    The Name to rename the Project to

    .PARAMETER Description
    A description of the Project

    .PARAMETER Zones
    PSCustomObject(s) with properties for a Cloud Zone

    .PARAMETER Members
    Members to set to the Project

    .PARAMETER Administrators
    Administrators to set to the Project

    .PARAMETER Viewers
    Viewers to set to the Project

    .PARAMETER OperationTimeout
    Operation Timeout in seconds

    .PARAMETER SharedResources
    Deployments are shared between all users in the project

    .PARAMETER PlacementPolicy
    Placement Policy

    .PARAMETER CustomProperties
    Specify the custom properties that should be added to all requests in this project
    Note the vRA API does not appear to support removing existing Custom Properties
    Custom Properties specifed here will be added to those already existing

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
        Id = 'i84848484848484'
        Name = 'Test Project'
        Description = 'Test Project'
        Zones = $CloudZone
        Members = 'user1@test.com','user2@test.com'
        Administrators = 'admin1@test.com','admin2@test.com'
        OperationTimeout = 3600
        SharedResources = 'true'
        CustomProperties = $CustomProperties
    }

    Set-vRAProject @ProjectArguments

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

    $JSON | Set-vRAProject
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="ById")][OutputType('System.Management.Automation.PSObject')]
[Alias("Update-vRAProject")]

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
        [String]$NewName,

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
        [String[]]$Members,

        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [String[]]$Administrators,

        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [String[]]$Viewers,

        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [Int]$OperationTimeout,

        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [ValidateSet("true", "false", IgnoreCase = $false)]
        [String]$SharedResources,

        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [ValidateSet("DEFAULT", "SPREAD", IgnoreCase = $false)]
        [String]$PlacementPolicy,

        [Parameter(Mandatory=$false,ParameterSetName="ById")]
        [Parameter(Mandatory=$false,ParameterSetName="ByName")]
        [Hashtable]$CustomProperties,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON
    )

    begin {

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
                PlacementPolicy = $Project.placementPolicy
                CustomProperties = $Project.customProperties
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
                    # If the user does not provide a name keep the existing
                    $ExistingProject = Get-vRAProject -Id $Id
                    if (!$ExistingProject){

                        throw "Project with id $($Id) does not exist"
                    }
                    $Name = $ExistingProject.Name
                }
            }

            # --- Update Project by name
            'ByName' {
                # We need the id to do the patch
                $ExistingProject = Get-vRAProject -Name $Name
                if (!$ExistingProject){

                    throw "Project with name $($Name) does not exist"
                }
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
                    if (!$ExistingProject){

                        throw "Project with name $($Name) does not exist"
                    }
                    $Id = $ExistingProject.Id
                }

            }
        }

        if (-not $PSBoundParameters.ContainsKey("JSON")) {

            $Project = [PSCustomObject]@{}

            if ($PSBoundParameters.ContainsKey("NewName")){

                Write-Verbose -Message "Updating Name: $($ExistingProject.name) >> $($NewName)"
                $Project | Add-Member -MemberType NoteProperty -Name 'name' -Value $NewName
            }

            if ($PSBoundParameters.ContainsKey("Description")){

                Write-Verbose -Message "Updating Description: $($ExistingProject.description) >> $($Description)"
                $Project | Add-Member -MemberType NoteProperty -Name 'description' -Value $Description
            }

            if ($PSBoundParameters.ContainsKey("Zones")){

                Write-Verbose -Message "Updating Zones: $($ExistingProject.Zones) >> $($Zones)"
                if (!$Zones){

                    $EmptyZones = @()
                    $Project | Add-Member -MemberType NoteProperty -Name 'zoneAssignmentConfigurations' -Value $EmptyZones
                }
                else {

                    $Project | Add-Member -MemberType NoteProperty -Name 'zoneAssignmentConfigurations' -Value $Zones
                }
            }

            if ($PSBoundParameters.ContainsKey("Members")){

                Write-Verbose -Message "Updating Members: $($ExistingProject.Members.email) >> $($Members)"
                if (!$Members){

                    $Members = @()
                    $Project | Add-Member -MemberType NoteProperty -Name 'members' -Value $Members
                }
                else {
                    $MembersArray = @()
                    foreach ($Member in $Members){
                        $MembersArray += [PSCustomObject]@{email=$Member}
                    }
                    $Project | Add-Member -MemberType NoteProperty -Name 'members' -Value $MembersArray
                }
            }

            if ($PSBoundParameters.ContainsKey("Administrators")){

                Write-Verbose -Message "Updating Administrators: $($ExistingProject.Administrators.email) >> $($Administrators)"
                if (!$Administrators){

                    $Administrators = @()
                    $Project | Add-Member -MemberType NoteProperty -Name 'administrators' -Value $Administrators
                }
                else {
                    $AdministratorsArray = @()
                    foreach ($Administrator in $Administrators){
                        $AdministratorsArray += [PSCustomObject]@{email=$Administrator}
                    }
                    $Project | Add-Member -MemberType NoteProperty -Name 'administrators' -Value $AdministratorsArray
                }
            }

            if ($PSBoundParameters.ContainsKey("Viewers")){

                Write-Verbose -Message "Updating Viewers: $($ExistingProject.Viewers.email) >> $($Viewers)"
                if (!$Viewers){

                    $Viewers = @()
                    $Project | Add-Member -MemberType NoteProperty -Name 'viewers' -Value $Viewers
                }
                else {
                    $ViewersArray = @()
                    foreach ($Viewer in $Viewers){
                        $ViewersArray += [PSCustomObject]@{email=$Viewer}
                    }
                    $Project | Add-Member -MemberType NoteProperty -Name 'viewers' -Value $ViewersArray
                }
            }

            if ($PSBoundParameters.ContainsKey("OperationTimeout")){

                Write-Verbose -Message "Updating OperationTimeout: $($ExistingProject.OperationTimeout) >> $($OperationTimeout)"
                $Project | Add-Member -MemberType NoteProperty -Name 'operationTimeout' -Value $OperationTimeout
            }

            if ($PSBoundParameters.ContainsKey("SharedResources")){

                Write-Verbose -Message "Updating SharedResources: $($ExistingProject.SharedResources) >> $($SharedResources)"
                $Project | Add-Member -MemberType NoteProperty -Name 'sharedResources' -Value $SharedResources
            }

            if ($PSBoundParameters.ContainsKey("PlacementPolicy")){

                Write-Verbose -Message "Updating PlacementPolicy: $($ExistingProject.PlacementPolicy) >> $($PlacementPolicy)"
                $Project | Add-Member -MemberType NoteProperty -Name 'placementPolicy' -Value $PlacementPolicy
            }

            if ($PSBoundParameters.ContainsKey("CustomProperties")){

                $Project | Add-Member -MemberType NoteProperty -Name 'customProperties' -Value $CustomProperties
            }

            $Body = $Project | ConvertTo-Json -Depth 5
            Write-Verbose "JSON Body is : $($Body)"
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