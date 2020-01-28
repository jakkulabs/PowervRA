function Get-vRAMachines {
<#
    .SYNOPSIS
    Retrieve vRA Machines

    .DESCRIPTION
    Retrieve a list of vRA Machines

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAMachines

#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param ()

    try {

        $URI = "/iaas/api/machines"
        $Response = Invoke-vRARestMethod -URI $URI -Method GET

        foreach ($Record in $Response.content) {
            [PSCustomObject]@{
                Name = $Record.name
                PowerState = $Record.powerState
                IPAddress = $Record.address
                ExternalRegionId = $Record.externalRegionId
                CloudAccountIDs = $Record.cloudAccountIds
                ExternalId = $Record.externalId
                Id = $Record.id
                DateCreated = $Record.createdAt
                LastUpdated = $Record.updatedAt
                OrganizationId = $Record.organizationId
                Properties = $Record.customProperties
            }
        }
    }
    catch [Exception]{

        throw
    }
}
