# How our build process works

## Overview

### Test
By default every commit or pull request against the development branch will trigger the default build task which is **Test**. This task
will execute PSScriptAnalyzer against each function in the module and also check that the help contains the required secions via a set 
of Pester tests. It's important that we catch any inconcistencies quickly and these tests do exactly that. No changes will be made to 
the repository when this task is executed.

### Build
We rely on tags in our commit messages to invoke our builds. This gives us flexibility in terms of what we execute and when. For example, the
[Build] tag will run our tests, update any documentation and our ModuleManifest but not increment any versions. 

```
git commit -m "Invoke a build [Build]"
``` 

As a precurser to our releases the version of the module must be incremented to reflect the nature of the update. We follow [Semantic Versioning](http://semver.org/) and reflect
this in our builds with the following tags [Build.Major], [Build.Minor], [Build.Patch]. For example, to invoke a build and increment the patch version the commit message
would be as follows:

```
git commit -m "Invoke a build [Build.Patch]"
``` 

There can only be one task per commit and therefore only one tag specified in the commit message. Each build task is covered in more detail below.

Upon a succesful build we automatically publish any new or changed documentation to our [ReadTheDocs.og](https://powervra.readthedocs.io/en/latest/) site. The build of the
documentation site is external to the PowervRA build.

### Release

**Not implemeneted**

Releases always happen from the **master** branch of our repository. We control the changes to this branch by using pull requests. Once a PR has been approved adding the 
[Release] tag to the commit message will instruct the build script to invoke the Release task. This task will only execute when the current branch is **master** and it's goal
is to create a new GitHub release and publish the module to the PowerShell Gallery.

## Tooling

* [GitHub](https://github.com/jakkulabs/PowervRA)
* [AppVeyor](https://appveyor.com)
* [PSake](https://github.com/psake/psake)
* [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)
* [Pester](https://github.com/pester/Pester)
* [BuildHelpers](https://github.com/RamblingCookieMonster/BuildHelpers)
* [PlatyPS](https://github.com/PowerShell/platyPS)
* [ReadTheDocs](https://readthedocs.org/)

## Commit message tags

Here is a list of commit message tags that are currently supported with our build process:

### [ci skip]
A default tag provided by AppVeyor. Adding this will stop any build process from being triggered.

#### Example
```
git add NewFile.ps1
git commit -m "Skip ci build [ci skip]"
```

### [Build]

* Run the Test task
* Update the Module Manifest FunctionsToExport section with any new functions
* Update/Add any markdown documents
* Commit any changes back to the repository

#### Example
```
git add NewFile.ps1
git commit -m "Invoke standard build [Build]"
```

### [Build.Major]

* Run the Test task
* Update the Module Manifest FunctionsToExport section with any new functions
* Update/Add any markdown documents
* Incremement the Major version of the module manifest
* Infremement the Major version of appveyor.yml
* Update the CHANGELOG.md from RELEASE.md
* Commit any changes back to the repository

#### Example
```
git add NewFile.ps1
git commit -m "Build and incremement the Major version of the module [Build.Major]"
```

### [Build.Minor]

* Run the Test task
* Update the Module Manifest FunctionsToExport section with any new functions
* Update/Add any markdown documents
* Incremement the Minor version of the module manifest
* Infremement the Minor version of appveyor.yml
* Update the CHANGELOG.md from RELEASE.md
* Commit any changes back to the repository

#### Example
```
git add NewFile.ps1
git commit -m "Build and incremement the Minor version of the module [Build.Minor]"
```

### [Build.Patch]

* Run the Test task
* Update the Module Manifest FunctionsToExport section with any new functions
* Update/Add any markdown documents
* Incremement the Patch version of the module manifest
* Infremement the Patch version of appveyor.yml
* Update the CHANGELOG.md from RELEASE.md
* Commit any changes back to the repository

#### Example
```
git add NewFile.ps1
git commit -m "Build and incremement the Patch version of the module [Build.Patch]"
```

### [Release]

**Not implemented**

* Will only run on the Master branch
* Creates GitHub tag and release with an asset
* Publish the module to the PowerShellGallery

#### Example
```
git add NewFile.ps1
git commit -m "Invoke a release [Release]"
```