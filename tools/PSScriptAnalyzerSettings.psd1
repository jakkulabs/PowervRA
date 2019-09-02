@{
    ExcludeRules=@(
        "PSAvoidUsingUserNameAndPassWordParams",
        "PSAvoidGlobalVars"
    )

    Severity=@(
        "Warning",
        "Error"
    )

    Rules = @{
        # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/UseCompatibleCmdlets.md
        PSUseCompatibleCmdlets = @{
            Compatibility = @(
                "core-6.1.0-windows",
                "core-6.1.0-linux",
                "core-6.1.0-macos"
            )
        }
    }
}
