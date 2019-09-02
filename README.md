[![Build Status](https://jakkulabs.visualstudio.com/Lab/_apis/build/status/PowervRA?branchName=master)](https://jakkulabs.visualstudio.com/Lab/_build/latest?definitionId=3&branchName=master) ![](https://img.shields.io/powershellgallery/v/PowervRA) ![](https://img.shields.io/powershellgallery/dt/PowervRA)

# Welcome to PowervRA
PowervRA is a PowerShell module built on top of the services exposed by the vRealize Automation 7 REST API.

Note: this module is not in any way developed or supported by anyone officially affiliated with VMware

## Compatibility

### vRealize Automation

|||||||
| --- | --- | --- | --- | --- | --- |
|6.2.4*|7.0|7.0.1|7.1|7.2|7.3|


* Support for 6.2.4 is limited given API restrictions. Functions which don't support 6.2.4 will exit early and cleanly.

### PowerShell Editions

|Edition|Version|
| --- | --- |
|Desktop|5.1|
|Core|6.x|

## Download

PowerShell v5.1 & v6 users: You grab the latest version of the module from the PowerShell Gallery by running the following command:

```
Install-Module -Name PowervRA -Scope CurrentUser
```

## Quick Start

Once you have installed and imported PowervRA, use Connect-vRAServer to connect to your vRA instance:

```PowerShell
Connect-vRAServer -Server vra.corp.local -Tenant tenant01 -Credential (Get-Credential)
```

If your instance has a self signed certificate you must use the **IgnoreCertRequirements** switch:

```PowerShell
Connect-vRAServer -Server vra.corp.local -Tenant tenant01 -Credential (Get-Credential) -IgnoreCertRequirements
```

## Running Locally
When developing, use the provided build script and import the module that is inside the Release directory.

You **do not** have to manually edit src\PowervRA.psd1 when adding new functions

```PowerShell
# --- Run the build script
.\tools\build.ps1

# --- Import release module
Import-Module .\Release\PowervRA\PowervRA.psd1 -Force
```
The default build will run some quick tests to catch any errors before you push your changes.

## Documentation

Documentation for each command can be viewed with Get-Help, e.g.:

```
Get-Help Get-vRAEntitlement
```

### Updating the documentation
To update the documentation you first need to ensure that the local module manifest is updated with any new functions

```PowerShell
.\tools\build.ps1 -Task UpdateModuleManifest
```

Once complete you can run the UpdateDocumentation task to create new markdown files and update any existing ones.

```PowerShell
.\tools\build.ps1 -Task UpdateDocumentation
```

The changes can then be committed back to the repository. Once pushed, they will be reflected in ReadTheDocs.
