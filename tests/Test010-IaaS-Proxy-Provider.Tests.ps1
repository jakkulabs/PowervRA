# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $JSON.Connection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'Iaas-Proxy-Provider Tests' -Fixture {

    Context -Name 'Network Profile' -Fixture {

        $APIVersion = [version]$Global:vRAConnection.APIVersion
        $RequiredVersion = [version]"7.1"

        if ($APIVersion -lt $RequiredVersion) {

            It -Name "Throw an error for an Unsupported API Version" -Test {

                try {

                    Get-vRAExternalNetworkProfile -ErrorVariable FailedCommand

                }catch {}

                $FailedCommand.Count | Should Not Be 0

            }

        } else {

            $ExternalProfileName = "Test-External-$(Get-Random -Maximum 20)"
            $NatProfileName = "Test-NAT-$(Get-Random -Maximum 20)"
            $RoutedProfileName = "Test-Routed-$(Get-Random -Maximum 20)"

            # --- CREATE
            It -Name "Create named External Network Profile" -Test {

                $IPRange = New-vRANetworkProfileIPRangeDefinition -Name "Range-01" -Description "Test IP Range" -StartIPv4Address "10.0.0.10" -EndIPv4Address "10.0.0.20"

                $Param = @{

                    Name = $ExternalProfileName
                    Description = "Test Network Profile"
                    SubnetMask = "255.255.255.0"
                    GatewayAddress = "10.0.0.1"
                    PrimaryDNSAddress = "10.0.0.2"
                    SecondaryDNSAddress = "10.0.0.3"
                    PrimaryWinsAddress = "10.0.0.4"
                    SecondaryWinsAddress = "10.0.0.5"
                    DNSSuffix = "corp.local"
                    DNSSearchSuffix = "corp.local"
                    IPRanges = $IPRange

                }

                $NetworkProfile = New-vRAExternalNetworkProfile @Param
                $NetworkProfile.Name | Should Be $ExternalProfileName

            }

            It -Name "Create named NAT Network Profile" -Test {

                $IPRange = New-vRANetworkProfileIPRangeDefinition -Name "Range-01" -Description "Test IP Range" -StartIPv4Address "10.0.1.20" -EndIPv4Address "10.0.1.20"

                $Param = @{

                    Name = $NatProfileName
                    Description = "Test Network Profile"
                    SubnetMask = "255.255.255.0"
                    GatewayAddress = "10.0.1.1"
                    ExternalNetworkProfile = $ExternalProfileName
                    UseExternalNetworkProfileSettings = $true
                    IPRanges = $IPRange
                    NatType = "ONETOMANY"
                    DHCPEnabled = $true
                    DHCPStartAddress = "10.0.1.10"
                    DHCPEndAddress = "10.0.1.15"

                }

                $NetworkProfile = New-vRANATNetworkProfile @Param
                $NetworkProfile.Name | Should Be $NatProfileName

            }

            It -Name "Create named Routed Network Profile" -Test {

                $IPRange = New-vRANetworkProfileIPRangeDefinition -Name "Range-01" -Description "Test IP Range" -StartIPv4Address "10.0.2.10" -EndIPv4Address "10.0.2.254"

                $Param = @{

                    Name = $RoutedProfileName
                    Description = "Test Network Profile"
                    SubnetMask = "255.255.255.0"
                    GatewayAddress = "10.0.2.1"
                    PrimaryDNSAddress = "10.0.2.2"
                    SecondaryDNSAddress = "10.0.2.3"
                    PrimaryWinsAddress = "10.0.2.4"
                    SecondaryWinsAddress = "10.0.2.5"
                    DNSSuffix = "corp.local"
                    DNSSearchSuffix = "corp.local"
                    ExternalNetworkProfile = $ExternalProfileName
                    RangeSubnetMask = "255.255.255.0"
                    BaseIPAddress = "10.0.2.10"
                    IPRanges = $IPRange

                }

                $NetworkProfile = New-vRARoutedNetworkProfile @Param
                $NetworkProfile.Name | Should Be $RoutedProfileName

            }

            # --- READ
            It -Name "Return named External Network Profile" -Test {

                $NetworkProfile = Get-vRAExternalNetworkProfile -Name $ExternalProfileName
                $NetworkProfile.Name | Should Be $ExternalProfileName


            }

            It -Name "Return named NAT Network Profile" -Test {

                $NetworkProfile = Get-vRANATNetworkProfile -Name $NatProfileName
                $NetworkProfile.Name | Should Be $NatProfileName

            }

            It -Name "Return named Routed Network Profile" -Test {

                $NetworkProfile = Get-vRARoutedNetworkProfile -Name $RoutedProfileName
                $NetworkProfile.Name | Should Be $RoutedProfileName

            }

            It -Name "Return Network Profile IP Range Summary" -Test {

                $NetworkProfile = Get-vRAExternalNetworkProfile -Name $ExternalProfileName
                $IPRangeSummary = $NetworkProfile | Get-vRANetworkProfileIPRangeSummary
                $IPRangeSummary | Should Not Be $null

            }


            It -Name "Return Network Profile IP Address List" -Test {

                $NetworkProfile = Get-vRAExternalNetworkProfile -Name $ExternalProfileName
                $IPAddressList = $NetworkProfile | Get-vRANetworkProfileIPAddressList
                $IPAddressList | Should Not Be $null

            } 

            # --- UPDATE
            It -Name "Update named External Network Profile" -Test {

                $NetworkProfile = Get-vRAExternalNetworkProfile -Name $ExternalProfileName
                $NetworkProfileDescription = $NetworkProfile.Description
                $UpdatedNetworkProfile = $NetworkProfile | Set-vRAExternalNetworkProfile -Description "$($NetworkProfileDescription) Updated" -Confirm:$false
                $UpdatedNetworkProfile.Description | Should Be "$($NetworkProfileDescription) Updated"

            }

            It -Name "Update named NAT Network Profile" -Test {

                $NetworkProfile = Get-vRANATNetworkProfile -Name $NatProfileName
                $NetworkProfileDescription = $NetworkProfile.Description
                $UpdatedNetworkProfile = $NetworkProfile | Set-vRANatNetworkProfile -Description "$($NetworkProfileDescription) Updated" -Confirm:$false
                $UpdatedNetworkProfile.Description | Should Be "$($NetworkProfileDescription) Updated"

            }

            It -Name "Update named Routed Network Profile" -Test {

                $NetworkProfile = Get-vRARoutedNetworkProfile -Name $RoutedProfileName
                $NetworkProfileDescription = $NetworkProfile.Description
                $UpdatedNetworkProfile = $NetworkProfile | Set-vRARoutedNetworkProfile -Description "$($NetworkProfileDescription) Updated" -Confirm:$false
                $UpdatedNetworkProfile.Description | Should Be "$($NetworkProfileDescription) Updated"
                
            }

            # --- DELETE
            It -Name "Remove named NAT Network Profile" -Test {

                $NetworkProfile = Get-vRANatNetworkProfile -Name $NatProfileName
                $NetworkProfile | Remove-vRANatNetworkProfile -Confirm:$false

            }

            It -Name "Remove named Routed Network Profile" -Test {

                $NetworkProfile = Get-vRARoutedNetworkProfile -Name $RoutedProfileName
                $NetworkProfile | Remove-vRARoutedNetworkProfile -Confirm:$false
                
            }

            It -Name "Remove named External Network Profile" -Test {

                $NetworkProfile = Get-vRAExternalNetworkProfile -Name $ExternalProfileName
                $NetworkProfile | Remove-vRAExternalNetworkProfile -Confirm:$false

            }

        }

    }

}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false