function Get-vRABusinessGroup {
<#
    .SYNOPSIS
    Retrieve vRA Business Groups
    
    .DESCRIPTION
    Retrieve vRA Business Groups
    
    .PARAMETER TenantId
    Specify the ID of a Tenant

    .PARAMETER Name
    Specify the Name of a Business Group

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.
    
    .EXAMPLE
    Get-vRABusinessGroup

    .EXAMPLE
    Get-vRABusinessGroup -TenantId Tenant01 -Name BusinessGroup01,BusinessGroup02
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$TenantId = $Global:vRAConnection.Tenant,
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name,     
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100"
    )
                
try {

    # --- Check the TenantId
    if ($PSBoundParameters.ContainsKey("TenantId")) {

        $TenantId = (Get-vRATenant -Id $TenantId).Id
    }

    # --- Get business group by name
    if ($PSBoundParameters.ContainsKey("Name")) {

        foreach ($BusinessGroupName in $Name){

            $URI = "/identity/api/tenants/$($TenantId)/subtenants?`$filter=name%20eq%20'$($BusinessGroupName)'"

            # --- Run vRA REST Request
            $Response = Invoke-vRARestMethod -Method GET -URI $URI
            
            $BusinessGroup = $Response.content
            
            if (-not $BusinessGroup){

                Write-Warning "Did not find Business Group $BusinessGroupName"
                break
            }

            # --- Get the role details
            $BusinessGroupRolesURI = "/identity/api/tenants/$($TenantId)/subtenants/$($BusinessGroup.id)/roles"

            # --- Run vRA REST Request
            $BusinessGroupRolesResponse = Invoke-vRARestMethod -Method GET -URI $BusinessGroupRolesURI

            $GroupManagerRole = $BusinessGroupRolesResponse.content | Where-Object {$_.name -eq "Business Group Manager"}
            $SupportUserRole = $BusinessGroupRolesResponse.content | Where-Object {$_.name -eq "Support User"}
            $UserRole = $BusinessGroupRolesResponse.content | Where-Object {$_.name -eq "Basic User"}

            [pscustomobject]@{

                Name = $BusinessGroup.name
                ID = $BusinessGroup.id
                Description = $BusinessGroup.description
                Roles = $BusinessGroup.subtenantRoles
                ExtensionData = $BusinessGroup.extensionData
                GroupManagerRole = $GroupManagerRole.principalId
                SupportUserRole = $SupportUserRole.principalId
                UserRole = $UserRole.principalId
                Tenant = $BusinessGroup.tenant
            }
        }
    }
    else {

        $URI = "/identity/api/tenants/$($TenantId)/subtenants?limit=$($Limit)"

        # --- Run vRA REST Request
        $Response = Invoke-vRARestMethod -Method GET -URI $URI

        foreach ($BusinessGroup in $Response.content){
            
            # --- Get the role details
            $BusinessGroupRolesURI = "/identity/api/tenants/$($TenantId)/subtenants/$($BusinessGroup.id)/roles"

            # --- Run vRA REST Request
            $BusinessGroupRolesResponse = Invoke-vRARestMethod -Method GET -URI $BusinessGroupRolesURI

            $GroupManagerRole = $BusinessGroupRolesResponse.content | Where-Object {$_.name -eq "Business Group Manager"}
            $SupportUserRole = $BusinessGroupRolesResponse.content | Where-Object {$_.name -eq "Support User"}
            $UserRole = $BusinessGroupRolesResponse.content | Where-Object {$_.name -eq "Basic User"}

            [pscustomobject]@{

                Name = $BusinessGroup.name
                ID = $BusinessGroup.id
                Description = $BusinessGroup.description
                Roles = $BusinessGroup.subtenantRoles
                ExtensionData = $BusinessGroup.extensionData
                GroupManagerRole = $GroupManagerRole.principalId
                SupportUserRole = $SupportUserRole.principalId
                UserRole = $UserRole.principalId
                Tenant = $BusinessGroup.tenant
            }
        }
    }
}
catch [Exception]{

    throw
}
}