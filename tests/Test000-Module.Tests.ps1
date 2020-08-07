BeforeAll {
    $ModulePath = (Resolve-Path -Path $ENV:BHProjectPath\Release\PowervRA\PowervRA.psd1).Path
    Import-Module $ModulePath -Force
}

# --- Ensure that each function has valid help
Describe "Function Help -> " -Tags Help {

    $Functions = @(Get-Command -Module PowervRA -CommandType Function | ForEach-Object { @{Name = $_.Name } })

    It "<Name> has the required help entries" -TestCases $Functions {
        Param(
            [string]$Name
        )
        (Get-Help -Name $Name).Synopsis | Should -Not -BeNullOrEmpty
        (Get-Help -Name $Name).Description | Should -Not -BeNullOrEmpty
        (Get-Help -Name $Name).Examples | Should -Not -BeNullOrEmpt
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
