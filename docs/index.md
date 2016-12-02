[![Build status](https://ci.appveyor.com/api/projects/status/na25wbus68wb24y3?svg=true)](https://ci.appveyor.com/project/chelnak/powervra)

# Welcome to PowervRA
PowervRA is a PowerShell module built on top of the services exposed by the vRealize Automation 7 REST API.

Note: this module is not in any way developed or supported by anyone officially affiliated with VMware

## Compatibility

**vRA: version 6.2.4, 7.0, 7.0.1 and 7.1** - Note: support for 6.2.4 is limited given API restrictions. Functions which don't support 6.2.4 will exit early and cleanly.

**PowerShell: version 4 and 5**

## Download

PowerShell v5 users: You grab the latest version of the module from the PowerShell Gallery by running the following command:

```
Install-Module -Name PowervRA
```

PowerShell v4 users: Try this handy one liner to download and install the module:

```
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/jakkulabs/PowervRA/master/Get-PowervRA.ps1") | iex
```
## Documentation

Documentation for each command can be viewed with Get-Help, e.g.:

```
Get-Help Get-vRAEntitlement
```

Alternatively check out our [Read the Docs site](http://powervra.readthedocs.org/en/latest/ "Title")
