# New-vRAEntitlement

## SYNOPSIS
    
Create a new entitlement

## SYNTAX
 New-vRAEntitlement -Name <String> [-Description <String>] -BusinessGroup <String> [-Principals <String[]>]  [-EntitledCatalogItems <String[]>] [-EntitledResourceOperations <String[]>] [-EntitledServices <String[]>] [-WhatIf]  [-Confirm] [<CommonParameters>] New-vRAEntitlement -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Create a new entitlement

## PARAMETERS


### Name

The name of the entitlement

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Description

A description of the entitlement

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### BusinessGroup

The business group that will be associated with the entitlement

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Principals

Users or groups that will be associated with the entitlement

If this parameter is not specified, the entitlement will be created as DRAFT

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### EntitledCatalogItems

One or more entitled catalog item

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### EntitledResourceOperations

The externalId of one or more entitled resource operation (e.g. Infrastructure.Machine.Action.PowerOn)

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### EntitledServices

One or more entitled service

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

PS C:\>New-vRAEntitlement -Name "TestEntitlement" -Description "a test" -BusinessGroup "Test01" -Principals 
"user@vsphere.local" -EntitledCatalogItems "centos7","centos6" -EntitledServices "Default service" -Verbose







-------------------------- EXAMPLE 2 --------------------------

PS C:\>$JSON = @"


{
                  "description": "",
                  "entitledCatalogItems": [],
                  "entitledResourceOperations": [],
                  "entitledServices": [],
                  "expiryDate": null,
                  "id": null,
                  "lastUpdatedBy": null,
                  "lastUpdatedDate": null,
                  "name": "Test api 4",
                  "organization": {
                    "tenantRef": "Tenant01",
                    "tenantLabel": "Tenant",
                    "subtenantRef": "792e859a-8a5e-4814-bf04-e4489b27cada",
                    "subtenantLabel": "Default Business Group[Tenant01]"
                  },
                  "principals": [
                    {
                      "tenantName": "Tenant01",
                      "ref": "user@vsphere.local",
                      "type": "USER",
                      "value": "Test User"
                    }
                  ],
                  "priorityOrder": 2,
                  "status": "ACTIVE",
                  "statusName": "Active",
                  "localScopeForActions": true,
                  "version": null
                }
"@


$JSON | New-vRAEntitlement -Verbose
```

