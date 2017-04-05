# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$ConnectionPassword = ConvertTo-SecureString $JSON.Connection.Password -AsPlainText -Force
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $ConnectionPassword -IgnoreCertRequirements

# --- Tests
Describe -Name 'Blueprint Tests' -Fixture {

    It -Name "Return named Blueprint $($JSON.Blueprint.Name)" -Test {

        $BlueprintA = Get-vRABlueprint -Name $JSON.Blueprint.Name
        $BlueprintA.Name | Should Be $JSON.Blueprint.Name
    }

    It -Name "Return named Service Blueprint $($JSON.ServiceBlueprint.Name)" -Test {

        $ServiceBlueprintA = Get-vRAServiceBlueprint -Name $JSON.ServiceBlueprint.Name
        $ServiceBlueprintA.Name | Should Be $JSON.ServiceBlueprint.Name
    }
}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false