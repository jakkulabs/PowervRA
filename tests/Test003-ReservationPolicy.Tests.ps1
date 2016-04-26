# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $JSON.Connection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'Reservation Policy Tests' -Fixture {

    It -Name "Create named Reservation Policy $($JSON.ReservationPolicy.Name)" -Test {

        $ReservationPolicyA = New-vRAReservationPolicy -Name $JSON.ReservationPolicy.Name -Description $JSON.ReservationPolicy.Description
        $ReservationPolicyA.Name | Should Be $JSON.ReservationPolicy.Name
    }

    It -Name "Return named Reservation Policy $($JSON.ReservationPolicy.Name)" -Test {

        $ReservationPolicyB = Get-vRAReservationPolicy -Name $JSON.ReservationPolicy.Name
        $ReservationPolicyB.Name | Should Be $JSON.ReservationPolicy.Name
    }

    It -Name "Update named Reservation Policy $($JSON.ReservationPolicy.Name)" -Test {

        $ReservationPolicyC = Set-vRAReservationPolicy -Name $JSON.ReservationPolicy.Name -NewName $JSON.ReservationPolicy.NewName -Confirm:$false
        $ReservationPolicyC.Name | Should Be $JSON.ReservationPolicy.NewName
    }

    It -Name "Remove named Reservation Policy $($JSON.ReservationPolicy.NewName)" -Test {

        Remove-vRAReservationPolicy -Name $JSON.ReservationPolicy.NewName -Confirm:$false
        $ReservationPolicyD = Get-vRAReservationPolicy -Name $JSON.ReservationPolicy.NewName
        $ReservationPolicyD | Should Be $null
    }
}
Describe -Name 'Storage Reservation Policy Tests' -Fixture {

    It -Name "Create named Storage Reservation Policy $($JSON.StorageReservationPolicy.Name)" -Test {

        $StorageReservationPolicyA = New-vRAStorageReservationPolicy -Name $JSON.StorageReservationPolicy.Name -Description $JSON.StorageReservationPolicy.Description
        $StorageReservationPolicyA.Name | Should Be $JSON.StorageReservationPolicy.Name
    }

    It -Name "Return named Storage Reservation Policy $($JSON.StorageReservationPolicy.Name)" -Test {

        $StorageReservationPolicyB = Get-vRAStorageReservationPolicy -Name $JSON.StorageReservationPolicy.Name
        $StorageReservationPolicyB.Name | Should Be $JSON.StorageReservationPolicy.Name
    }

    It -Name "Update named Storage Reservation Policy $($JSON.StorageReservationPolicy.Name)" -Test {

        $StorageReservationPolicyC = Set-vRAStorageReservationPolicy -Name $JSON.StorageReservationPolicy.Name -NewName $JSON.StorageReservationPolicy.NewName -Confirm:$false
        $StorageReservationPolicyC.Name | Should Be $JSON.StorageReservationPolicy.NewName
    }

    It -Name "Remove named Storage Reservation Policy $($JSON.StorageReservationPolicy.NewName)" -Test {

        Remove-vRAStorageReservationPolicy -Name $JSON.StorageReservationPolicy.NewName -Confirm:$false
        $StorageReservationPolicyD = Get-vRAStorageReservationPolicy -Name $JSON.StorageReservationPolicy.NewName
        $StorageReservationPolicyD | Should Be $null
    }
}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false