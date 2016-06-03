# Welcome to PowervRA
PowervRA is a PowerShell module built on top of the services exposed by the vRealize Automation 7 REST API.

Note: this module is not in any way developed or supported by anyone officially affiliated with VMware

## Compatibility

**vRA: version 7.0 and 7.0.1** - some of the functions may work with version 6.2.x, but we haven't tested them (yet).

**PowerShell: version 4** is required.  We haven't tested yet with version 5, although we wouldn't expect significant issues.

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
