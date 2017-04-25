# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$ConnectionPassword = ConvertTo-SecureString $JSON.Connection.Password -AsPlainText -Force
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $ConnectionPassword -IgnoreCertRequirements

# --- Tests
Describe -Name 'o11n Gateway Service Tests' -Fixture {

    It -Name "Invoke vRA DataCollection" -Test {

       { Invoke-vRADataCollection } | Should Not Throw 
    }
}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false