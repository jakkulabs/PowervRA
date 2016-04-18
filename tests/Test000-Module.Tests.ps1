# --- Tests
Describe -Name 'Module Tests' -Fixture {

    It -Name "Attempting to import the PowervRA Module" -Test {

        $Module = Import-Module PowervRA -PassThru
        $Module.Name | Should be "PowervRA"
    }
}
