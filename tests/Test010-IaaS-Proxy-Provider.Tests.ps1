# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $JSON.Connection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'Iaas-Proxy-Provider Tests' -Fixture {

    Context -Name 'Network Profile' -Fixture {

        # --- CREATE
        It -Name "Create named External Network Profile" -Test {


        }

        It -Name "Create named NAT Network Profile" -Test {


        }

        It -Name "Create named Routed Network Profile" -Test {


        }

        # --- READ
        It -Name "Return named External Network Profile" -Test {


        }

        It -Name "Return named NAT Network Profile" -Test {


        }

        It -Name "Return named Routed Network Profile" -Test {


        }

        It -Name "Return Network Profile IP Range Summary" -Test {


        }


        It -Name "Return Network Profile IP Address List" -Test {


        } 

        # --- UPDATE
        It -Name "Update named External Network Profile" -Test {


        }

        It -Name "Update named NAT Network Profile" -Test {

            
        }

        It -Name "Update named Routed Network Profile" -Test {

            
        }

        # --- DELETE
        It -Name "Remove named External Network Profile" -Test {

            
        }

        It -Name "Remove named NAT Network Profile" -Test {

            
        }

        It -Name "Remove named Routed Network Profile" -Test {

            
        }

    }

}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false