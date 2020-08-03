# --- Validate the module manifest
BeforeAll {
    $ModulePath = (Resolve-Path -Path $ENV:BHProjectPath\Release\PowervRA\PowervRA.psd1).Path
    Import-Module $ModulePath -Force -Global
    $Functions = @(Get-Command -Module PowervRA -CommandType Function | ForEach-Object { @{Name = $_.Name}})
}

# --- Ensure that each function has valid help
Describe "Function Help -> " -Tags Help {

    It "<Name> has the required help entries" -TestCases $Functions {
        Param($Name)
        (Get-Help -Name $Name).Synopsis | Should -Not -BeNullOrEmpty
        (Get-Help -Name $Name).Description | Should -Not -BeNullOrEmpty
        (Get-Help -Name $Name).Examples | Should -Not -BeNullOrEmpt
    }

    It "<Name> has documentation for all parameters" -TestCases $Functions {
        Param($Name)
        $Help = Get-Help -Name $Name
        foreach ($Parameter in $Help.parameters.parameter) {

            if ($Parameter -notmatch 'whatif|confirm') {

                    $Parameter.Description.text | Should -Not -BeNullOrEmpty
            }
        }
    }

    # foreach ($Function in $Functions) {

    #     $Help = Get-Help $Function.name

    #     Context $Help.name {

    #         It "Has a Synopsis" {
    #             $Help.synopsis | Should Not BeNullOrEmpty
    #         }

    #         It "Has a description" {
    #             $Help.description | Should Not BeNullOrEmpty
    #         }

    #         It "Has an example" {
    #             $Help.examples | Should Not BeNullOrEmpty
    #         }


    #     }
    # }
}
