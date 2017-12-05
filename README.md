![Build status](https://jakkulabs.visualstudio.com/_apis/public/build/definitions/b9938934-bc30-4bf9-8ee8-91138dde4db8/1/badge)

# Welcome to PowervRA
PowervRA is a PowerShell module built on top of the services exposed by the vRealize Automation 7 REST API.

Note: this module is not in any way developed or supported by anyone officially affiliated with VMware

## Compatibility

### vRealize Automation

* 6.2.4**
* 7.0
* 7.0.1
* 7.1

** Support for 6.2.4 is limited given API restrictions. Functions which don't support 6.2.4 will exit early and cleanly.

### PowerShell Editions

#### Desktop

* 4.0
* 5.0
* 5.1

#### Core

* 6.0.0-rc**

** To get up and running with PowerShell Core follow the instructions for your operating system [here](https://github.com/PowerShell/PowerShell/blob/master/README.md#get-powershell).

## Download

PowerShell v5 & v6 users: You grab the latest version of the module from the PowerShell Gallery by running the following command:

```
Install-Module -Name PowervRA
```

PowerShell v4 users: Try this handy one liner to download and install the module:

```
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/jakkulabs/PowervRA/master/Get-PowervRA.ps1") | iex
```

## Docker

As of version 2.0.0 we now have our own [docker image](https://hub.docker.com/r/jakkulabs/powervra/).

Getting started is easy, just run the following commands:

```
docker pull jakkulabs/powervra
docker run --rm -it jakkulabs/powervra
```

For more information see [this readme](docker/README.md).

## Quick Start

Once you have installed and imported PowervRA, use Connect-vRAServer to connect to your vRA instance:

```
Connect-vRAServer -Server vra.corp.local -Tenant tenant01 -Credential (Get-Credential) 
```

If your instance has a self signed certificate you must use the **IgnoreCertRequirements** switch:

```
Connect-vRAServer -Server vra.corp.local -Tenant tenant01 -Credential (Get-Credential) -IgnoreCertRequirements
```

## Documentation

Documentation for each command can be viewed with Get-Help, e.g.:

```
Get-Help Get-vRAEntitlement
```

Alternatively check out our [Read the Docs site](https://powervra.readthedocs.org/en/latest/ "Title")
