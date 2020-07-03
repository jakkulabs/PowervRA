# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Tests
Describe -Name 'Connectivity Tests' -Fixture {

    It -Name "Attempting to connect to the vRA Appliance $($JSON.Connection.vRAAppliance) on port 443" -Test {

        $Connection = New-Object Net.Sockets.TcpClient
        $Connection.ConnectASync($JSON.Connection.vRAAppliance,443) | Out-Null
        $Connection | Should Be $true
    }

    It -Name 'Connects to a vRA Appliance and generates a token' -Test {

        $ConnectionPassword = ConvertTo-SecureString $JSON.Connection.Password -AsPlainText -Force
        Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Username $JSON.Connection.Username -Password $ConnectionPassword -IgnoreCertRequirements
        $($Script:vRAConnection.Token) | Should Be $true
    }

    It -Name 'Connects to a vRA Appliance with a refresh_token and retrieves the access token' -Test {

        Connect-vRAServer -Server $JSON.Connection.vRAAppliance -APIToken $JSON.Connection.Refresh_Token -IgnoreCertRequirements
        $($Script:vRAConnection.Token) | Should Be $true

    }

}

Describe -Name 'Disconnectivity Tests' -Fixture {

    It -Name 'Disconnects from a vRA Appliance' -Test {

        Disconnect-vRAServer -Confirm:$false
        $($Script:vRAConnection.Token) | Should Be $null
    }
}
