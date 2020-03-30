[![Build Status](https://jakkulabs.visualstudio.com/Lab/_apis/build/status/PowervRA?branchName=master)](https://jakkulabs.visualstudio.com/Lab/_build/latest?definitionId=3&branchName=master) ![](https://img.shields.io/powershellgallery/v/PowervRA) ![](https://img.shields.io/powershellgallery/dt/PowervRA)

# Welcome to PowervRA
PowervRA is a PowerShell module built on top of the services exposed by the vRealize Automation REST API.

**Note: this module is a community project and is not in any way supported by VMware.**

## Compatibility

### vRealize Automation

**PowervRA 4.x and above is only compatible with vRA 8.x and the Cloud version. The API was completely changed after vRA 7.x and PowervRA has been re-written to support that going forward.**

| Version | Tested |
| --- | --- |
|8.0| :white_check_mark: |
|Cloud API: 2019-01-15 | :white_check_mark: |


For vRA versions prior to 8.0 / Cloud, the following are supported when using PowervRA release 3.x, currently 3.6.0. To install that version from the PowerShell Gallery use:

```PowerShell
Install-Module -Name PowervRA -RequiredVersion 3.6.0 -Scope CurrentUser
```


| Version | Tested |
| --- | --- |
|6.2.4*| :white_check_mark: |
|7.0| :white_check_mark: |
|7.0.1| :white_check_mark: |
|7.1| :white_check_mark: |
|7.2| :white_check_mark: |
|7.3| :white_check_mark: |


* Support for 6.2.4 is limited given API restrictions. Functions which don't support 6.2.4 will exit early and cleanly.

### PowerShell Editions

|Edition|Version|Tested|
| --- | --- | --- |
|PowerShell|7, 6.2.4| :white_check_mark: |
|Windows PowerShell|5.1| :white_check_mark: |


## Download

You can grab the latest version of the module from the PowerShell Gallery by running the following command:

```PowerShell
Install-Module -Name PowervRA -Scope CurrentUser
```

For vRA 7.x and earlier compatibilty, be sure to use the latest 3.x version of PowervRA, currently 3.6.0:

```PowerShell
Install-Module -Name PowervRA -RequiredVersion 3.6.0 -Scope CurrentUser
```

## Quick Start

### PowervRA 4.x

Once you have installed and imported PowervRA, use Connect-vRAServer to connect to your vRA instance:

**vRA 8 On-Premises**

```PowerShell
Connect-vRAServer -Server vraappliance01.domain.local -Credential (Get-Credential)
```

If your instance has a self signed certificate you must use the **IgnoreCertRequirements** switch:

```PowerShell
Connect-vRAServer -Server vraappliance01.domain.local -Credential (Get-Credential) -IgnoreCertRequirements
```

**vRA Cloud**

```PowerShell
Connect-vRAServer -Server api.mgmt.cloud.vmware.com -APIToken 'CuIKrjQgI6htiyRgIyd0ZtQM91fqg6AQyQhwPFJYgzBsaIKxKcWHLAGk81kknulQ'
```

### PowervRA 3.x

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
