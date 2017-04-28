function Check-PowerCliAssemblies {

<#
    .SYNOPSIS
    Checks to see if PowerCLI dependencies are installed. 
    
    .DESCRIPTION
    Checks for PowerCLI dependencies, loads them if available and errors out if not. Called by the vRA installation/deployment functions so that we can fail `
    early before attempting to deploy the OVA or copy scripts to the Windows Guest OS. 

    .EXAMPLE
    Check-PowerCLIAssemblies

    .LINK
    Credits to the PowerNSX team for this function (https://github.com/vmware/powernsx/)
#>

    $CoreRequiredModules = @("PowerCLI.ViCore")
    $CurrentModules = Get-Module 

    write-host -ForegroundColor Red $WarningString

    #Attempt to load PowerCLI modules required
    foreach ($Module in $CoreRequiredModules ) {
        if ( -not $CurrentModules.Name.Contains($Module)) {
            try {
                #Attempt to load the module automatically
                Import-Module $module -global -erroraction stop
            }
            catch {
                throw "Module $module could not be loaded.  Please ensure that PowerCLI is installed on this system."
            }
        }
else {
    #Attempt to load PowerCLI modules required
    foreach ($Module in $DesktopRequiredModules ) {
        if ( -not $CurrentModules.Contains($Module)) {
            try {
                #Attempt to load the module automatically
                Import-Module $module -global -erroraction stop
            }
            catch {
                throw "Module $module could not be loaded.  Please ensure that PowerCLI is installed on this system."
            }
        }
    }

}
    }
}   