﻿function Get-vRACatalogPrincipal {
<#
    .SYNOPSIS
    Finds catalog principals

    .DESCRIPTION
    Internal function to find users or groups and return them as the api type catalogPrincipal.

    DOCS: catalog-service/api/docs/ns0_catalogPrincipal.html

    [pscustomobject] is returned with lowercase property names to commply with expected payload

    .PARAMETER Id
    The Id of the group

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRACatalogPrincipal -Id group@vsphere.local

    .EXAMPLE
    Get-vRACatalogPrincipal -Id user@vsphere.local

    .EXAMPLE
    Get-vRACatalogPrincipal -Id group@vsphere.local

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Alias("Principal")]
        [String[]]$Id

    )

    Begin {

    }

    Process {

        try {

            foreach ($PrincipalId in $Id){
                $CatalogPrincipal = $null

                # -- Test for user first
                try {

                    Write-Verbose -Message "Searching for USER $($PrincipalId)"

                    $User = Get-vRAUserPrincipal -Id $PrincipalId

                    Write-Verbose "User found!"

                    $CatalogPrincipal = [pscustomobject] @{

                        tenantName = $($Script:vRAConnection.Tenant)
                        ref = $($User.Principalid)
                        type = "USER"
                        value = $($User.Name)

                    }

                }
                catch {

                    Write-Verbose -Message "User $($PrincipalId) not found.."

                }

                # --- Test for group if the user was not found
                if (!$CatalogPrincipal) {

                    try {

                        Write-Verbose -Message "Searching for GROUP $($PrincipalId)"

                        $Group = Get-vRAGroupPrincipal -Id $PrincipalId

                        Write-Verbose -Message "Group found!"

                        $CatalogPrincipal = [pscustomobject] @{

                            tenantName = $($Script:vRAConnection.Tenant)
                            ref =  $($Group.Principalid)
                            type = "GROUP"
                            value = $($Grop.Name)

                        }

                    }
                    catch {

                        Write-Verbose -Message "Group $($Id) not found.."

                    }

                }

                # --- Test to see if either search returned anything
                if (!$CatalogPrincipal) {

                    throw "$PrincipalId not found"

                    }

                # --- Return the catalogPrincipal
                $CatalogPrincipal

            }

        }
        catch [Exception]{

            throw

        }

    }

    End {

    }

}
