# Set-vRAEntitlement

## SYNOPSIS
    
Update an existing entitlement

## SYNTAX
 Set-vRAEntitlement -Id <String> [-Name <String>] [-Description <String>] [-Principals <String[]>]  [-EntitledCatalogItems <String[]>] [-EntitledResourceOperations <String[]>] [-EntitledServices <String[]>] [-Status  <String>] [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Update an existing entitlement

## PARAMETERS


### Id

The id of the entitlement

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByPropertyName)

### Name

The name of the entitlement

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Description

A description of the entitlement

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Principals

Users or groups that will be associated with the entitlement

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

### Status

The status of the entitlement. Accepted values are ACTIVE and INACTIVE

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

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

PS C:\>Set-vRAEntitlement -Id "e5cd1c84-3b76-4ae9-9f2e-35114da6cfd2" -Name "Updated Name"







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Set-vRAEntitlement -Id "e5cd1c84-3b76-4ae9-9f2e-35114da6cfd2" -Name "Updated Name" -Description "Updated 
Description" -Principals "user@vsphere.local" -EntitledCatalogItems "Centos" -EntitledServices "A service" 
-EntitledResourceOperations "Infrastructure.Machine.Action.PowerOff" -Status ACTIVE







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAEntitlement -Name "Entitlement 1" | Set-vRAEntitlement -Description "Updated description!"
```

