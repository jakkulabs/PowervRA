# --- Ensure that each function has valid help and parameter descriptions
Describe "Function Help -> " {

    BeforeAll {
        $ModulePath = (Resolve-Path -Path $ENV:BHProjectPath\Release\PowervRA\PowervRA.psd1).Path
        Import-Module $ModulePath -Force

        $Functions = @(Get-Command -Module PowervRA -CommandType Function | ForEach-Object { @{Name = $_.Name } })

    }

    AfterAll {
        Remove-Module -Name PowervRA -Force
    }


    It "<Name> has the required help entries" -TestCases $Functions {
        Param(
            [string]$Name
        )

        $Help = Get-Help -Name $Name

        $Help.Synopsis | Should -Not -BeNullOrEmpty
        $Help.Description | Should -Not -BeNullOrEmpty
        $Help.Examples | Should -Not -BeNullOrEmpt
    }

    It "<Name> has documentation for all parameters" -TestCases $Functions {
        Param(
            [string]$Name
        )

        $Help = Get-Help -Name $Name

        foreach ($Parameter in $Help.parameters.parameter) {
            if ($Parameter -notmatch 'whatif|confirm') {
                $Parameter.Description.text | Should -Not -BeNullOrEmpty
            }
        }
    }
}
