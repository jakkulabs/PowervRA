function Get-vRANetwork {
<#
    .SYNOPSIS
    Retrieve vRA Network(s) depending on input

    .DESCRIPTION
    Retrieve a list of vRA Networks or a single network depending on input

    .PARAMETER Id
    The ID of the vRA Machine

    .PARAMETER Name
    The Name of the vRA Machine

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRANetwork

    .EXAMPLE
    Get-vRANetwork -Id 'b1dd48e71d74267559bb930934470'

    .EXAMPLE
    Get-vRANetwork -Name 'my-porgroup'

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

        $APIUrl = "/iaas/api/networks"

        function CalculateOutput {

            foreach ($Record in $Response.content) {
                [PSCustomObject]@{
                    Name = $Record.name
                    ExternalZoneId = $Record.externalZoneId
                    Description = $Record.description
                    DeploymentId = $Record.DeploymentId
                    CIDR = $Record.cidr
                    ProjectId = $Record.projectId
                    ExternalRegionId = $Record.externalRegionId
                    CloudAccountIDs = $Record.cloudAccountIds
                    ExternalId = $Record.externalId
                    Id = $Record.id
                    DateCreated = $Record.createdAt
                    LastUpdated = $Record.updatedAt
                    OrganizationId = $Record.organizationId
                    Properties = $Record.customProperties
                    Tags = $Record.tags
                }
            }
        }
    }
    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Network by its id
                'ById' {
                    foreach ($networkId in $Id) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=id eq '$networkId'" -Method GET
                        CalculateOutput
                    }

                    break
                }

                # --- Get Network by its name
                'ByName' {
                    foreach ($networkName in $Name) {
                        $Response = Invoke-vRARestMethod -URI "$APIUrl`?`$filter=name eq '$networkName'" -Method GET
                        CalculateOutput
                    }

                    break
                }

                # --- No parameters passed so return all machines
                'Standard' {
                    $Response = Invoke-vRARestMethod -URI $APIUrl -Method GET
                    CalculateOutput
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
