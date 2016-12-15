# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $JSON.Connection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'Content-Management-Service Tests' -Fixture {

    Context -Name "Content" -Fixture {

        $TestContent = Get-vRAContent | Select-Object -First 1

        It -Name "Return content" -Test {

            $Content = Get-vRAContent
            $Content.Count | Should Not Be 0

        }

        It -Name "Return content by name" -Test {

            $Content = Get-vRAContent -Name $TestContent.Name
            $Content.Name | Should Be $TestContent.Name

        }

        It -Name "Return content by Id" -Test {

            $Content = Get-vRAContent -Id $TestContent.Id
            $Content.Id | Should Be $TestContent.Id

        }

        It -Name "Return content data string" -Test {

            $ContentData = Get-vRAContent -Id $TestContent.Id | Get-vRAContentData
            $ContentData.GetType().Name | Should Be "String"

        }

        It -Name "Return content-types" -Test {

            $ContentType = Get-vRAContentType
            $ContentType.Count | Should Not Be 0

        }

        It -Name "Return content-type by name" -Test {

            $TestContentType = Get-vRAContentType | Select-Object -First 1
            $ContentType = Get-vRAContentType -Name $TestContentType.Name
            $ContentType.Name | Should Be $TestContentType.Name

        }

        It -Name "Return content-type by id" -Test {

            $TestContentType = Get-vRAContentType | Select-Object -First 1
            $ContentType = Get-vRAContentType -Id $TestContentType.Id
            $ContentType.Id | Should Be $TestContentType.Id

        }

    }

    Context -Name "Package" -Fixture {

        $PackageName = "Package-$(Get-Random -Maximum 200)"


        It -Name "Create named Package" -Test {

            $Content = Get-vRAContent | Select-Object -First 1

            $Package = New-vRAPackage -Name $PackageName -Description "Test Description" -ContentId $Content.Id
            $Package.Name | Should Be $PackageName
        }

        It -Name "Return named Package" -Test {

            $Package = Get-vRAPackage -Name $PackageName
            $Package.Name | Should Be $PackageName
        }

        It -Name "Export named Package" -Test {

            $Package = Export-vRAPackage -Name $PackageName -Path "$($PSScriptRoot)\data"
            $Package.BaseName | Should Be $PackageName
        }

        It -Name "Remove named Package" -Test {

            Remove-vRAPackage -Name $PackageName -Confirm:$false
            
            try {
            
                $Package = Get-vRAPackage -Name $PackageName
            }
            catch [Exception]{

            }
            $Package | Should Be $null
        }

        It -Name "Test named Package" -Test {

            $PackageFile = "$($PSScriptRoot)\data\$($PackageName).zip"

            $TestStatus = Test-vRAPackage -File $PackageFile
            $TestStatus.operationStatus | Should Be "WARNING"

        }

        It -Name "Import named Package" -Test {

            $PackageFile = "$($PSScriptRoot)\data\$($PackageName).zip"
            $ImportStatus = Import-vRAPackage -File $PackageFile -Confirm:$false
            $ImportStatus.operationStatus | Should Be "WARNING"

        }

    }

}

# --- Cleanup

Remove-Item -Path "$($PSScriptRoot)\data\Package-*.zip" -Force

Disconnect-vRAServer -Confirm:$false