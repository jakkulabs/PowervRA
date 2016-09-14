function Update-ModuleDocumentation {
<#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .PARAMETER Id

    .PARAMETER Name

    .PARAMETER Limit

    .INPUTS
    System.String

    .OUTPUTS
    None

#>
[CmdletBinding(DefaultParameterSetName="Standard")]

    Param (

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Module,
        
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$DocumentsRoot,
        
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Template,               
        
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Switch]$NewOnly      

    )

    try {                
            
        Write-Verbose -Message "Importing module"
        
        $ModuleObject = Import-Module -Name $Module -PassThru -Force
        
        if (!(Test-Path -Path $DocumentsRoot)) {
            
            Write-Verbose -Message "Creating documents directory $($DocumentsRoot)"
            
            New-Item -Path $DocumentsRoot -ItemType directory -Force | Out-Null           
                        
        }

        $DocumentsRootObject = Get-Item -Path "$DocumentsRoot"

        $HelpObjects = Get-Command -Module $ModuleObject.Name | Get-Help -Full            

        foreach ($Help in $HelpObjects) {

            $FilePath = "$($DocumentsRootObject.FullName)\$($Help.Name).md"                

            $Document = Invoke-Expression -Command "& `'$($Template)`'" -Verbose:$VerbosePreference
            
            Write-Verbose -Message "Creating help $($FilePath) with template $($Template)"
            
            [IO.File]::WriteAllLines($FilePath, $Document)                 
            
        }

    }
    catch [Exception]{

        throw
    }
    
}