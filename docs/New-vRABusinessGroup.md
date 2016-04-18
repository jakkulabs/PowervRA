# New-vRABusinessGroup

## SYNOPSIS
    
Create a vRA Business Group

## SYNTAX
 New-vRABusinessGroup -TenantId <String> -Name <String> [-Description <String>] [-BusinessGroupManager <String[]>]  [-SupportUser <String[]>] [-User <String[]>] [-MachinePrefixId <String>] -SendManagerEmailsTo <String> [-WhatIf]  [-Confirm] [<CommonParameters>] New-vRABusinessGroup -TenantId <String> -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Create a vRA Business Group

## PARAMETERS


### TenantId

Tenant ID

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

Business Group Name

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Description

Business Group Description

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### BusinessGroupManager

Business Group Managers

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### SupportUser

Business Group Support Users

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### User

Business Group Users

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### MachinePrefixId

Machine Prefix Id

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### SendManagerEmailsTo

Send Manager Emails To

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### JSON

Body text to send in JSON format

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue)

### WhatIf


* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Confirm


* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

## INPUTS

System.String.

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>New-vRATenantBusinessGroup -TenantId Tenant01 -Name BusinessGroup01 -Description "Business Group 01" 
-BusinessGroupManager "busgroupmgr01@vrademo.local","busgroupmgr02@vrademo.local" -SupportUser 
"supportusers@vrademo.local" `


-User "basicusers@vrademo.local" -MachinePrefixId "87e99513-cbea-4589-8678-c84c5907bdf2" -SendManagerEmailsTo 
"busgroupmgr01@vrademo.local"




-------------------------- EXAMPLE 2 --------------------------

PS C:\>$JSON = @"


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
```

