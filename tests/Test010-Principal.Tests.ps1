# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $JSON.Connection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'User Principal Tests' -Fixture {

    It -Name "Create named User Principal $($JSON.Principal.UserPrincipalId)" -Test {

        $UserPrincipalA = New-vRAUserPrincipal -TenantId $JSON.Connection.Tenant -FirstName $JSON.Principal.UserPrincipalFirstName -LastName $JSON.Principal.UserPrincipalLastName -EmailAddress $JSON.Principal.UserPrincipalEmailAddress -Description $JSON.Principal.UserPrincipalDescription -Password $JSON.Principal.UserPrincipalPassword -PrincipalId $JSON.Principal.UserPrincipalId
        $UserPrincipalA.FirstName | Should Be $Json.Principal.UserPrincipalFirstName
                
    }

    It -Name "Return named User Principal $($JSON.Principal.UserPrincipalId)" -Test {
        
        $UserPrincipalB = Get-vRAUserPrincipal -Id $JSON.Principal.UserPrincipalId
        $UserPrincipalB.FirstName | Should Be $JSON.Principal.UserPrincipalFirstName
        
    }

    It -Name "Update named User Principal $($JSON.Principal.UserPrincipalId)" -Test {

        $UserPrincipalC = Set-vRAUserPrincipal -Id $JSON.Principal.UserPrincipalId -FirstName $JSON.Principal.UserPrincipalFirstNameUpdated
        $UserPrincipalC.FirstName | Should Be $JSON.Principal.UserPrincipalFirstNameUpdated

    }

    It -Name "Remove named User Principal $($JSON.Principal.UserPrincipalId)" -Test {

        Remove-vRAUserPrincipal -Id $JSON.Principal.UserPrincipalId -Confirm:$false
        
        try {
            
            $UserPrincipalD = Get-vRAUserPrincipal -Id $JSON.Principal.UserPrincipalId            
            
        }
        catch {}
        
        $UserPrincipalD | Should Be $null
                
    }
       
}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false