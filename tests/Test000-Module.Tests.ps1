$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force


# --- Tests
Describe -Name 'Module Tests' -Fixture {

    It -Name "Attempting to import the PowervRA Module" -Test {

        $Module = Import-Module -Name PowervRA -PassThru | Where-Object {$_.Name -eq 'PowervRA'}
        $Module.Name | Should be "PowervRA"
    }
}

Describe "Help tests for $moduleName" -Tags Help {
    
    $functions = Get-Command -Module $moduleName -CommandType Function

    foreach($Function in $Functions){

        $help = Get-Help $Function.name

        Context $help.name {

            it "Has a Synopsis" {
                $help.synopsis | Should Not BeNullOrEmpty
            }

            it "Has a description" {
                $help.description | Should Not BeNullOrEmpty
            }

            it "Has an example" {
                 $help.examples | Should Not BeNullOrEmpty
            }

            foreach($parameter in $help.parameters.parameter) {

                if($parameter -notmatch 'whatif|confirm') {

                    it "Has a Parameter description for '$($parameter.name)'" {
                        $parameter.Description.text | Should Not BeNullOrEmpty
                    }
                }
            }
        }
    }
}