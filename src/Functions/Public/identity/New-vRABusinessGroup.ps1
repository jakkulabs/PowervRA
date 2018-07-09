function New-vRABusinessGroup {
<#
    .SYNOPSIS
    Create a vRA Business Group
    
    .DESCRIPTION
    Create a vRA Business Group

    .PARAMETER TenantId
    Tenant ID
    
    .PARAMETER Name
    Business Group Name
    
    .PARAMETER Description
    Business Group Description

    .PARAMETER BusinessGroupManager
    Business Group Managers

    .PARAMETER SupportUser
    Business Group Support Users

    .PARAMETER SharedAccessUser
    Business Group Shared Access Users

    .PARAMETER User
    Business Group Users

    .PARAMETER MachinePrefixId
    Machine Prefix Id
    
    .PARAMETER SendManagerEmailsTo
    Send Manager Emails To

    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRABusinessGroup -TenantId Tenant01 -Name BusinessGroup01 -Description "Business Group 01" -BusinessGroupManager "busgroupmgr01@vrademo.local","busgroupmgr02@vrademo.local" -SupportUser "supportusers@vrademo.local" `
     -User "basicusers@vrademo.local" -MachinePrefixId "87e99513-cbea-4589-8678-c84c5907bdf2" -SendManagerEmailsTo "busgroupmgr01@vrademo.local"
    
    .EXAMPLE
    New-vRABusinessGroup -TenantId Tenant01 -Name BusinessGroup02 -Description "Business Group 02" -BusinessGroupManager "busgroupmgr02@vrademo.local" -SharedAccessUser "sharedaccess01@vrademo.local" `
     -SendManagerEmailsTo "busgroupmgr02@vrademo.local"
    
    .EXAMPLE
    $JSON = @"
    {
      "name": "BusinessGroup01",
      "description": "Business Group 01",
      "subtenantRoles": [ {
        "name": "Business Group Manager",
        "scopeRoleRef" : "CSP_SUBTENANT_MANAGER",
        "principalId": [
          {
            "domain": "vrademo.local",
            "name": "busgroupmgr01"
          },
          {
            "domain": "vrademo.local",
            "name": "busgroupmgr02"
          }
        ]
      },
      {
      "name": "Basic User",
          "scopeRoleRef": "CSP_CONSUMER",
          "principalId": [
            {
              "domain": "vrademo.local",
              "name": "basicusers"
            }
          ] 
      } ,
      {
      "name": "Support User",
          "scopeRoleRef": "CSP_SUPPORT",
          "principalId": [
            {
              "domain": "vrademo.local",
              "name": "supportusers"
            }
          ] 
      } ],
      "extensionData": {
        "entries": [
          {
            "key": "iaas-machine-prefix",
            "value": {
              "type": "string",
              "value": "87e99513-cbea-4589-8678-c84c5907bdf2"
            }
          },
          {
            "key": "iaas-manager-emails",
            "value": {
              "type": "string",
              "value": "busgroupmgr01@vrademo.local"
            }
          }
        ]
      },
      "tenant": "Tenant01"
    }
    "@
    $JSON | New-vRABusinessGroup -TenantId Tenant01
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$TenantId = $Global:vRAConnection.Tenant,
    
    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Description,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$BusinessGroupManager,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$SupportUser,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$SharedAccessUser,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$User,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$MachinePrefixId,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$SendManagerEmailsTo,

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
    [ValidateNotNullOrEmpty()]
    [String]$JSON
    )    

    begin {
        # --- Test for vRA API version
        xRequires -Version 7.0

        # --- Test for API 7.3 if SharedAccessUser parameter specified
        if ($PSBoundParameters.ContainsKey("SharedAccessUser")){

            if ($vRAConnection.APIVersion -lt 7.3){

                throw "vRA BusinessGroup Shared Access feature requires vRA version 7.3 or greater"
            }
        }
    }
    
    process {

        try {
    
        # --- Set Body for REST request depending on ParameterSet
        if ($PSBoundParameters.ContainsKey("JSON")){

            $Data = ($JSON | ConvertFrom-Json)
        
            $Body = $JSON
            $Name = $Data.name
        }
        else {
        
            $Body = @"
            {
              "name": "$($Name)",
              "description": "$($Description)",
              "subtenantRoles": [ {
                "name": "Business Group Manager",
                "scopeRoleRef" : "CSP_SUBTENANT_MANAGER",
                "principalId": [

                ]
              },
              {
              "name": "Basic User",
                  "scopeRoleRef": "CSP_CONSUMER",
                  "principalId": [

                  ] 
              } ,
              {
              "name": "Support User",
                  "scopeRoleRef": "CSP_SUPPORT",
                  "principalId": [

                  ] 
              } ],
              "extensionData": {
                "entries": [
                  {
                    "key": "iaas-manager-emails",
                    "value": {
                      "type": "string",
                      "value": "$($SendManagerEmailsTo)"
                    }
                  }
                ]
              },
              "tenant": "$($TenantId)"
            }
"@

            $BodySharedAccess = @"
            {
                "name": "com.vmware.csp.core.cafe.identity@csp.scoperole.sharedaccess.user.name",
                "scopeRoleRef": "CSP_CONSUMER_WITH_SHARED_ACCESS",
                "principalId": [
                
                ] 
            }
"@

            # --- If certain parameters are specified, ConvertFrom-Json, update, then ConvertTo-Json
            if ($PSBoundParameters.ContainsKey("BusinessGroupManager") -or $PSBoundParameters.ContainsKey("SupportUser") -or $PSBoundParameters.ContainsKey("SharedAccessUser") -or $PSBoundParameters.ContainsKey("User") -or $PSBoundParameters.ContainsKey("MachinePrefixId")){

                $JSONObject = $Body | ConvertFrom-Json
                
                # --- Add Shared Access feature from vRA 7.3
                if ($vRAConnection.APIVersion -ge 7.3){

                    $JSONObject.subtenantRoles += ($BodySharedAccess | ConvertFrom-Json)
                }

                if ($PSBoundParameters.ContainsKey("BusinessGroupManager")){

                    foreach ($Entity in $BusinessGroupManager){

                        $Domain = ($Entity -split "@")[1]
                        $Username = ($Entity -split "@")[0]
                
                        $Addition = @"
                        {
                            "domain": "$($Domain)",
                            "name": "$($Username)"
                        }
"@
                
                        $AdditionObject = $Addition | ConvertFrom-Json
                
                        $BusinessGroupManagerRole = $JSONObject.subtenantRoles | Where-Object {$_.Name -eq "Business Group Manager"}
                        $BusinessGroupManagerRole.principalId += $AdditionObject
                
                    }
                }

                if ($PSBoundParameters.ContainsKey("SupportUser")){

                    foreach ($Entity in $SupportUser){

                        $Domain = ($Entity -split "@")[1]
                        $Username = ($Entity -split "@")[0]
                
                        $Addition = @"
                        {
                            "domain": "$($Domain)",
                            "name": "$($Username)"
                        }
"@
                
                        $AdditionObject = $Addition | ConvertFrom-Json
                
                        $SupportUserRole = $JSONObject.subtenantRoles | Where-Object {$_.Name -eq "Support User"}
                        $SupportUserRole.principalId += $AdditionObject
                
                    }
                }

                if ($PSBoundParameters.ContainsKey("SharedAccessUser")){

                    foreach ($Entity in $SharedAccessUser){

                        $Domain = ($Entity -split "@")[1]
                        $Username = ($Entity -split "@")[0]
                
                        $Addition = @"
                        {
                            "domain": "$($Domain)",
                            "name": "$($Username)"
                        }
"@
                
                        $AdditionObject = $Addition | ConvertFrom-Json
                
                        $SupportUserRole = $JSONObject.subtenantRoles | Where-Object {$_.Name -eq "com.vmware.csp.core.cafe.identity@csp.scoperole.sharedaccess.user.name"}
                        $SupportUserRole.principalId += $AdditionObject
                
                    }
                }

                if ($PSBoundParameters.ContainsKey("User")){

                    foreach ($Entity in $User){

                        $Domain = ($Entity -split "@")[1]
                        $Username = ($Entity -split "@")[0]
                
                        $Addition = @"
                        {
                            "domain": "$($Domain)",
                            "name": "$($Username)"
                        }
"@
                
                        $AdditionObject = $Addition | ConvertFrom-Json
                
                        $UserRole = $JSONObject.subtenantRoles | Where-Object {$_.Name -eq "Basic User"}
                        $UserRole.principalId += $AdditionObject
                
                    }
                }
            
                if ($PSBoundParameters.ContainsKey("MachinePrefixId")){

                
                    $Addition = @"
                    {
                        "key": "iaas-machine-prefix",
                        "value": {
                          "type": "string",
                          "value": "$($MachinePrefixId)"
                        }
                   }
"@
                
                    $AdditionObject = $Addition | ConvertFrom-Json
                
                    $MachinePrefix = $JSONObject.extensionData
                    $MachinePrefix.entries += $AdditionObject
                

                }

                $Body = $JSONObject | ConvertTo-Json -Depth 5
            }  
        }

        if ($PSCmdlet.ShouldProcess($TenantId)){

            $URI = "/identity/api/tenants/$($TenantId)/subtenants"  

            # --- Run vRA REST Request
            Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference | Out-Null

            # --- Output the Successful Result
            Get-vRABusinessGroup -TenantId $TenantId -Name $Name
        }

        }
        catch [Exception]{

            throw
        }
    }
    end {
        
    }
}