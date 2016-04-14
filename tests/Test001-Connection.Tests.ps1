# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Tests
Describe -Name 'Connectivity Tests' -Fixture {

    It -Name "Attempting to ping the vRA Appliance $($JSON.Connection.vRAAppliance)" -Test {

        $ping = Test-Connection -ComputerName $JSON.Connection.vRAAppliance -Quiet
        $ping | Should be $true
    }

    It -Name 'Connects to a vRA Appliance and generates a token' -Test {

        Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $JSON.Connection.Password -IgnoreCertRequirements
        $($Global:vRAConnection.Token) | Should Be $true
    }

}

Describe -Name 'Disconnectivity Tests' -Fixture {

    It -Name 'Disconnects from a vRA Appliance' -Test {

        Disconnect-vRAServer -Confirm:$false
        $($Global:vRAConnection.Token) | Should Be $null
    }

}