# Set-vRABusinessGroup

## SYNOPSIS
    
Update a vRA Business Group

## SYNTAX
 Set-vRABusinessGroup -TenantId <String> -ID <String> [-Name <String>] [-Description <String>] [-MachinePrefixId  <String>] [-SendManagerEmailsTo <String>] [-WhatIf] [-Confirm] [<CommonParameters>] Set-vRABusinessGroup -TenantId <String> -ID <String> -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Update a vRA Business Group

## PARAMETERS


### TenantId

Tenant ID

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### ID

Business Group ID

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

Business Group Name

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Description

Business Group Description

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

* Required: false
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

PS C:\>Set-vRABusinessGroup -TenantId Tenant01 -Id "f8e0d99e-c567-4031-99cb-d8410c841ed7" -Name BusinessGroup01 
-Description "Business Group 01" -MachinePrefixId "87e99513-cbea-4589-8678-c84c5907bdf2" -SendManagerEmailsTo 
"busgroupmgr01@vrademo.local"







-------------------------- EXAMPLE 2 --------------------------

PS C:\>$JSON = @"


{
    "id": "f8e0d99e-c567-4031-99cb-d8410c841ed7",
    "name": "BusinessGroup01",
    "description": "Business Group 01",
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
$JSON | Set-vRABusinessGroup -ID Tenant01 -Id "f8e0d99e-c567-4031-99cb-d8410c841ed7"
```

