# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$ConnectionPassword = ConvertTo-SecureString $JSON.Connection.Password -AsPlainText -Force
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $ConnectionPassword -IgnoreCertRequirements

# --- Tests
Describe -Name 'Custom Forms Tests' -Fixture {

  It -Name "Get single form by id $($JSON.Blueprint.BlueprintId)" -Test {

      $CustomFormA = Get-vRACustomForm -Id $JSON.Blueprint.BlueprintId
      $CustomFormA.BlueprintId | Should -Be $JSON.Blueprint.BlueprintId
      $CustomFormA.JSON | Should -BeOfType System.String
      $CustomFormA.JSON | Should -BeLikeExactly '{*}'

  }

  It -Name "Get form from pipped Blueprint by id $($JSON.Blueprint.BlueprintId)" -Test {

      $CustomFormB = Get-vRACustomForm -Id $JSON.Blueprint.BlueprintId | Get-vRACustomForm
      $CustomFormB.BlueprintId | Should -Be $JSON.Blueprint.BlueprintId
      $CustomFormB.JSON | Should -BeOfType System.String
      $CustomFormB.JSON | Should -BeLikeExactly '{*}'

  }

}
