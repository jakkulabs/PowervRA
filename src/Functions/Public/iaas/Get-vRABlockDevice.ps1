function Get-vRABlockDevice {
    <#
        .SYNOPSIS
        Retrieve vRA Block Device(s)[Hard Disks] depending on input

        .DESCRIPTION
        Retrieve a list of vRA Block Devices or a single Block Device depending on input

        .PARAMETER Id
        The ID of the vRA Block Device

        .PARAMETER Name
        The Name of the Block Device

        .OUTPUTS
        System.Management.Automation.PSObject.

        .EXAMPLE
        Get-vRABlockDevice

        .EXAMPLE
        Get-vRABlockDevice -Id 'b1dd48e71d74267559bb930934470'

        .EXAMPLE
        Get-vRABlockDevice -Name 'my-disk'

    #>
    [CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

        Param (

            [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
            [ValidateNotNullOrEmpty()]
            [String[]]$Id,

            [Parameter(Mandatory=$true,ParameterSetName="ByName")]
            [ValidateNotNullOrEmpty()]
            [String[]]$Name

        )
        Begin {

            $APIUrl = "/iaas/api/block-devices"

            function CalculateOutput([PSCustomObject]$Response) {

                foreach ($Record in $Response.content) {
                    [PSCustomObject]@{
                        Owner = $Record.owner
                        Links = $Record._links
                        ExternalZoneId = $Record.externalZoneId
                        ExternalRegionId = $Record.externalRegionId
                        Description = $Record.description
                        ExternalId = $Record.externalId
                        OrgId = $Record.orgId
                        Tags = $Record.tags
                        OrganizationId = $Record.organizationId
                        CapacityInGB = $Record.capacityInGB
                        CreatedAt = $Record.createdAt
                        CloudAccountIds = $Record.cloudAccountIds
                        CustomProperties = $Record.customProperties
                        DeploymentId = $Record.deploymentId
                        Name = $Record.name
                        Id = $Record.id
                        Persistent = $Record.persistent
                        ProjectId = $Record.projectId
                        UpdatedAt = $Record.updatedAt
                        Status = $Record.status
                    }
                }
            }
        }
        Process {

            try {

                switch ($PsCmdlet.ParameterSetName) {

                    # --- Get Machine by its id
                    'ById' {
                        foreach ($machineId in $Id) {
                            $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=id eq '$machineId'" -Method GET
                            CalculateOutput $Response
                        }

                        break
                    }

                    # --- Get Machine by its name
                    'ByName' {
                        foreach ($machineName in $Name) {
                            $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$machineName'" -Method GET
                            CalculateOutput $Response
                        }

                        break
                    }

                    # --- No parameters passed so return all machines
                    'Standard' {
                        $Response = Invoke-vRARestMethod -URI $APIUrl -Method GET
                        CalculateOutput $Response
                    }

                }


            }
            catch [Exception]{

                throw
            }
        }
        End {

        }
    }
