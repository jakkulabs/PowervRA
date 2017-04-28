@{
    ExcludeRules=@(
        "PSAvoidUsingUserNameAndPassWordParams",
        "PSAvoidUsingPlainTextForPassword",
        "PSAvoidGlobalVars"
    )
    
    Severity=@(
        "Warning",
        "Error"
    )

    Rules = @{
        # https://github.com/PowerShell/PSScriptAnalyzer/blob/260a573e5e3f1ce8580c6ceb6f9089c7f1aadbc6/RuleDocumentation/UseCompatibleCmdlets.md
        PSUseCompatibleCmdlets = @{Compatibility = @(
            "core-6.0.0-alpha-linux",
            "core-6.0.0-alpha-windows",
            "core-6.0.0-alpha-osx"
        )}
    }

}