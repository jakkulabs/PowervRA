## Breaking changes
* Functions that take a Password parameter now require a SecureString #106
  * **Connect-vRAServer** - Now requires a **SecureString** for the Password parameter if you are using a Username/Password combination

## Features
* Feature - Properties-service support #119 - Thanks to @sammcgeown
  * Get-vRAPropertyDefinition, New-vRAPropertyDefinition, Remove-vRAPropertyDefinition
* Feature - Support for updating icons (including the all services icon) #117 / #37:
  * Import-vRAIcon, Export-vRAIcon, Get-vRAIcon, Remove-vRAIcon, New-vRAService, Set-vRACatalogItem, Set-vRAService

## Fixes
* Fixed #68 - Set-vRAUserPrincipal Id parameter now has an alias of PrincipalId
* Fixed #76 - Add support for LocalScopeForActions to Set-vRAEntitlement/New-vRAEntitlement
* Fixed #77 - Actions are not applied when creating a new entitlement with New-vRAEntitlement
* Fixed #105 - Fix functions using String type for Password parameters
* Fixed #110 - Issue with "Get-vRAReservationComputeResource -Type vSphere
* Fixed #111 - Build | PSAvoidUsingPlainTextForPassword | Set-vRAUserPrincipal
* Fixed #112 - Build | PSUseDeclaredVarsMoreThanAssignments| Set-vRATenantDirectory
* Fixed #113 - Build | PSUseDeclaredVarsMoreThanAssignments | New-vRATenantDirectory
* Fixed #114 - Build | PSAvoidUsingPlainTextForPassword | New-vRAUserPrincipal
* Fixed #115 - Build | PSPossibleIncorrectComparisonWithNull | Invoke-vRARestMethod
* Fixed #116 - Build | PSPossibleIncorrectComparisonWithNull | Connect-vRAServer
* Fixed #120 - Clean up issues from Properties Service PR
* Fixed #121 - Get-vRABusinessGroupName filter by Name fails on special characters

## Other fixes and improvements
* Introduces stricter checks in our CI process. The analyze task will now fail on warnings
* Introduces Pester tests for function help
  * All functions are now required to have at least a synopsis, description, one or more example section(s) and every parameter must have a description.
* Lots of other fun improvements to our CI and build process - See [here for more information](http://powervra.readthedocs.io/en/latest/build/)