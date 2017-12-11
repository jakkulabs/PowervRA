# --- Validate the module manifest
$ModulePath = (Resolve-Path -Path .\src\*.psd1).Path

Describe -Name 'Module Tests' -Fixture {
    It -Name "The module has a valid manifest file" -Test {
        {Test-ModuleManifest -Path $ModulePath} | Should Not Throw
    }
}

# --- Import Module once the manifest test has passed
Import-Module $ModulePath -Force -Global

# --- Ensure that each function has valid help
Describe "Help tests for PowervRA" -Tags Help {

    $Functions = Get-Command -Module PowervRA -CommandType Function

    foreach ($Function in $Functions) {

        $Help = Get-Help $Function.name

        Context $Help.name {

            It "Has a Synopsis" {
                $Help.synopsis | Should Not BeNullOrEmpty
            }

            It "Has a description" {
                $Help.description | Should Not BeNullOrEmpty
            }

            It "Has an example" {
                $Help.examples | Should Not BeNullOrEmpty
            }

            foreach ($Parameter in $Help.parameters.parameter) {

                if ($Parameter -notmatch 'whatif|confirm') {

                    It "Has a Parameter description for '$($Parameter.name)'" {
                        $Parameter.Description.text | Should Not BeNullOrEmpty
                    }
                }
            }
        }
    }
}