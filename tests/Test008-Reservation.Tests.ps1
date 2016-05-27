# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $JSON.Connection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'Reservation Tests' -Fixture {

    It -Name "Return Reservation Types" -Test {

        Get-vRAReservationType | Where-Object {$_.Name -eq 'vSphere'} | Select-Object -ExpandProperty Id | Should Be 'Infrastructure.Reservation.Virtual.vSphere'
    }

    It -Name "Return named vSphere Compute Resource $($JSON.Reservation.ComputeResourceName)" -Test {

        $ComputeResourceA = Get-vRAReservationComputeResource -Type vSphere -Name $JSON.Reservation.ComputeResourceName
        $ComputeResourceA.Label | Should Be $JSON.Reservation.ComputeResourceName
    }

    It -Name "Return named vSphere Compute Resource Memory for $($JSON.Reservation.ComputeResourceName)" -Test {

        $ComputeResourceB = Get-vRAReservationComputeResource -Type vSphere -Name $JSON.Reservation.ComputeResourceName
        $ComputeResourceMemoryB = Get-vRAReservationComputeResourceMemory -Type vSphere -ComputeResourceId $ComputeResourceB.Id
        $ComputeResourceMemoryB.Values.Entries | Where-Object {$_.Key -eq 'computeResourceMemoryTotalSizeMB'}| Select-Object -ExpandProperty value | Select-Object -ExpandProperty value | Should Be $JSON.Reservation.ComputeResourceMemoryTotalSizeMB
    }

    It -Name "Return named vSphere Compute Resource Network for $($JSON.Reservation.ComputeResourceName)" -Test {

        $ComputeResourceC = Get-vRAReservationComputeResource -Type vSphere -Name $JSON.Reservation.ComputeResourceName
        $ComputeResourceNetworkC = Get-vRAReservationComputeResourceNetwork -Type vSphere -ComputeResourceId $ComputeResourceC.Id -Name $JSON.Reservation.NetworkPath
        $ComputeResourceNetworkC.Values.Entries | Select-Object -ExpandProperty value | Select-Object -ExpandProperty label | Should Be $JSON.Reservation.NetworkPath
    }

    It -Name "Return named vSphere Compute Resource Resource Pool for $($JSON.Reservation.ComputeResourceName)" -Test {

        $ComputeResourceD = Get-vRAReservationComputeResource -Type vSphere -Name $JSON.Reservation.ComputeResourceName
        $ComputeResourceResourcePoolD = Get-vRAReservationComputeResourceResourcePool -Type vSphere -ComputeResourceId $ComputeResourceD.Id -Name $JSON.Reservation.ResourcePool
        $ComputeResourceResourcePoolD.Label | Should Be $JSON.Reservation.ResourcePool
    }

    It -Name "Return named vSphere Compute Resource Storage for $($JSON.Reservation.ComputeResourceName)" -Test {

        $ComputeResourceE = Get-vRAReservationComputeResource -Type vSphere -Name $JSON.Reservation.ComputeResourceName
        $ComputeResourceStorageE = Get-vRAReservationComputeResourceStorage -Type vSphere -ComputeResourceId $ComputeResourceE.Id -Name $JSON.Reservation.Datastore
        $ComputeResourceStorageE.Values.entries | Where-Object {$_.key -eq 'StoragePath'} | Select-Object -ExpandProperty value  | Select-Object -ExpandProperty label | Should Be $JSON.Reservation.Datastore
    }

    It -Name "Create named vSphere Reservation $($JSON.Reservation.Name)" -Test {

        # --- Get the compute resource id
        $ComputeResource = Get-vRAReservationComputeResource -Type vSphere -Name $JSON.Reservation.ComputeResourceName

        # --- Get the network definition
        $NetworkDefinitionArray = @()
        $Network1 = New-vRAReservationNetworkDefinition -Type vSphere -ComputeResourceId $ComputeResource.Id -NetworkPath $JSON.Reservation.NetworkPath -NetworkProfile $JSON.Reservation.NetworkProfile
        $NetworkDefinitionArray += $Network1

        # --- Get the storage definition
        $StorageDefinitionArray = @()
        $Storage1 = New-vRAReservationStorageDefinition -Type vSphere -ComputeResourceId $ComputeResource.Id -Path $JSON.Reservation.Datastore -ReservedSizeGB $JSON.Reservation.DatastoreReservedSizeGB -Priority $JSON.Reservation.DatastorePriority
        $StorageDefinitionArray += $Storage1

        # --- Set the parameters and create the reservation
        $Param = @{

            Type = "vSphere"
            Name = $JSON.Reservation.Name
            Tenant = $JSON.Connection.Tenant
            BusinessGroup = $JSON.Reservation.BusinessGroup
            ReservationPolicy = $JSON.Reservation.ReservationPolicy
            Priority = $JSON.Reservation.Priority
            ComputeResourceId = $ComputeResource.Id
            Quota = $JSON.Reservation.Quota
            MemoryGB = $JSON.Reservation.MemoryGB
            Storage = $StorageDefinitionArray
            ResourcePool = $JSON.Reservation.ResourcePool
            Network = $NetworkDefinitionArray
            EnableAlerts = $false

        }

        

        $ReservationA = New-vRAReservation @Param
        $ReservationA.Name | Should Be $JSON.Reservation.Name
    }

    It -Name "Return named Reservation $($JSON.Reservation.Name)" -Test {

        $ReservationB = Get-vRAReservation -Name $JSON.Reservation.Name
        $ReservationB.Name | Should Be $JSON.Reservation.Name
    }

    It -Name "Return named Reservation Template $($JSON.Reservation.Name)" -Test {

        $ReservationTemplateA = Get-vRAReservation -Name $JSON.Reservation.Name | Get-vRAReservationTemplate
        $ReservationTemplateA | ConvertFrom-JSON | Select-Object -ExpandProperty name | Should Be $JSON.Reservation.Name
    }

    It -Name "Add Storage to named Reservation $($JSON.Reservation.Name)" -Test {

        Get-vRAReservation -Name $JSON.Reservation.Name | Add-vRAReservationStorage -Path $JSON.Reservation.AdditionalDatastore -ReservedSizeGB $JSON.Reservation.AdditionalDatastoreReservedSizeGB -Priority $JSON.Reservation.AdditionalDatastorePriority
        $ReservationC = Get-vRAReservation -Name $JSON.Reservation.Name
        (($ReservationC.ExtensionData.entries | Where-Object {$_.key -eq 'reservationStorages'}).value.items.values.entries | Where-Object {$_.key -eq 'storagePath'} | Select-Object -ExpandProperty value | Where-Object {$_.label -eq $JSON.Reservation.AdditionalDatastore}).label | Should Be $JSON.Reservation.AdditionalDatastore
    }

    It -Name "Add Network to named Reservation $($JSON.Reservation.Name)" -Test {

        Get-vRAReservation -Name $JSON.Reservation.Name | Add-vRAReservationNetwork -NetworkPath $JSON.Reservation.AdditionalNetworkPath -NetworkProfile $JSON.Reservation.AdditionalNetworkProfile
        $ReservationD = Get-vRAReservation -Name $JSON.Reservation.Name
        (($ReservationD.ExtensionData.entries | Where-Object {$_.key -eq 'reservationNetworks'}).value.items.values.entries | Where-Object {$_.key -eq 'networkPath'} | Select-Object -ExpandProperty value | Where-Object {$_.label -eq $JSON.Reservation.AdditionalNetworkPath}).label | Should Be $JSON.Reservation.AdditionalNetworkPath
    }

    It -Name "Update Storage for named Reservation $($JSON.Reservation.Name)" -Test {
        
        try {
                        
            Get-vRAReservation -Name $JSON.Reservation.Name | Set-vRAReservationStorage -Path $JSON.Reservation.AdditionalDatastore -ReservedSizeGB $JSON.Reservation.AdditionalDatastoreReservedSizeGB -Priority $JSON.Reservation.AdditionalDatastorePriority -Confirm:$false
            $UpdateStorageError = $null
        }
        catch [Exception]{

            $UpdateStorageError = "1"
        }
        $UpdateStorageError | Should Be $null
    }

    It -Name "Update Network for named Reservation $($JSON.Reservation.Name)" -Test {
        
        try {
            
            Get-vRAReservation -Name $JSON.Reservation.Name | Set-vRAReservationNetwork -NetworkPath $JSON.Reservation.AdditionalNetworkPath -NetworkProfile $JSON.Reservation.AdditionalNetworkProfile -Confirm:$false
            $UpdateNetworkError = $null
        }
        catch [Exception]{

            $UpdateNetworkError = "1"
        }
        $UpdateNetworkError | Should Be $null
    }

    It -Name "Update named Reservation $($JSON.Reservation.Name)" -Test {

        $ReservationE = Get-vRAReservation -Name $JSON.Reservation.Name | Set-vRAReservation -Name $JSON.Reservation.UpdatedName -Confirm:$false
        $ReservationE.Name | Should Be $JSON.Reservation.UpdatedName
    }

    It -Name "Remove named Reservation $($JSON.Reservation.UpdatedName)" -Test {

        Remove-vRAReservation -Name $JSON.Reservation.UpdatedName -Confirm:$false
        try {
            $ReservationF = Get-vRAReservation -Name $JSON.Reservation.UpdatedName
        }
        catch [Exception]{

        }
        $ReservationF | Should Be $null
    }
}
# --- Cleanup
Disconnect-vRAServer -Confirm:$false