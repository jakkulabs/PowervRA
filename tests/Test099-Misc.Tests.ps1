# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$ConnectionPassword = ConvertTo-SecureString $JSON.Connection.Password-AsPlainText -Force
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Username $JSON.Connection.Username -Password $ConnectionPassword -IgnoreCertRequirements

# --- Tests
Describe -Name 'Misc Tests' -Fixture {

    It -Name "Return named Authorization Role $($JSON.Misc.AuthorizationRole)" -Test {

        $AuthorizationRoleA = Get-vRAAuthorizationRole -Id $JSON.Misc.AuthorizationRole
        $AuthorizationRoleA.Id | Should Be $JSON.Misc.AuthorizationRole
    }

    It -Name "Return Metrics for a named Resource $($JSON.Misc.MetricsVM)" -Test {

        $MetricsA = Get-vRAResourceMetric -Name $JSON.Misc.MetricsVM

        $MetricsA | Should Not Be $null

    }

}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false
