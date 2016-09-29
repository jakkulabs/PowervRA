# Export-vRAContentPackage

## SYNOPSIS
    
Export a vRA Content Package

## SYNTAX
 Export-vRAContentPackage -Id <String[]> [-Path <String>] [<CommonParameters>]  Export-vRAContentPackage -Name <String[]> [-Path <String>] [<CommonParameters>]     

## DESCRIPTION

Export a vRA Content Package

## PARAMETERS


### Id

Specify the ID of a Content Package

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByPropertyName)

### Name

Specify the Name of a Content Package

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Path

The resulting path. If this parameter is not passed the action will be exported to
the current working directory.

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.IO.FileInfo

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Export-vRAContentPackage -Id "b2d72c5d-775b-400c-8d79-b2483e321bae" -Path C:\Packages\ContentPackage01.zip






-------------------------- EXAMPLE 2 --------------------------

PS C:\>Export-vRAContentPackage -Name "ContentPackage01" -Path C:\Packages\ContentPackage01.zip






-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAContentPackage | Export-vRAContentPackage






-------------------------- EXAMPLE 4 --------------------------

PS C:\>Get-vRAContentPackage -Name "ContentPackage01" | Export-vRAContentPackage -Path C:\Packages\ContentPackage01.zip
```

