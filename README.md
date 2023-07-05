![Process PS Module](https://github.com/jakkulabs/PowervRA/actions/workflows/ps-module.yml/badge.svg) ![](https://img.shields.io/powershellgallery/v/PowervRA) ![](https://img.shields.io/powershellgallery/dt/PowervRA)

# Welcome to PowervRA
PowervRA is a PowerShell module built on top of the services exposed by the vRealize Automation REST API.

**Note: this module is a community project and is not in any way supported by VMware.**

## Compatibility

### vRealize Automation

**PowervRA 4.x and above is only compatible with vRA 8.x and the Cloud version. The API was completely changed after vRA 7.x and PowervRA has been re-written to support that going forward.**  
**PowervRA 6.x is only compatible with vRA 8.12 and up**

| Version | Tested |
| --- | --- |
|8.0| :white_check_mark: |
|Cloud API: 2019-01-15 | :white_check_mark: |


For vRA versions prior to 8.0 / Cloud, the following are supported when using PowervRA release 3.x, currently 3.7.0. To install that version from the PowerShell Gallery use:

```PowerShell
Install-Module -Name PowervRA -RequiredVersion 3.7.0 -Scope CurrentUser
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


## Breaking Changes

Listed here are the breaking changes made which required the major version to be incremented

| PowervRA Version | Breaking Change |
| --- | --- |
|5.x -> 6.x| Switched to URL `/csp/gateway/am/api/login?access_token` for `Connect-vRAServer` required in vRA 8.12|
|4.x -> 5.x| Removed UserAttribute Parameter from `Connect-vRAServer` |
|3.x -> 4.x| Re-written module to work with new vRA 8.x and Cloud API |

## Download

You can grab the latest version of the module from the PowerShell Gallery by running the following command:

```PowerShell
Install-Module -Name PowervRA -Scope CurrentUser
```

For vRA 7.x and earlier compatibilty, be sure to use the latest 3.x version of PowervRA, currently 3.7.0:

```PowerShell
Install-Module -Name PowervRA -RequiredVersion 3.7.0 -Scope CurrentUser
```

## Quick Start

### PowervRA 4.x, 5.x

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
Get-Help Get-vRACloudAccount
```

or online [here](https://jakkulabs.github.io/PowervRA/).