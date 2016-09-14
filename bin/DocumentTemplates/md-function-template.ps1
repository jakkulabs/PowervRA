<#

.DESCRIPTION

Markdown template for generating docs from PowerShell help

#>

@" 
# $($Help.Name)

"@

if ($Help.Synopsis) {

@"
## SYNOPSIS
    
$($Help.Synopsis)

"@

}

if ($Help.Syntax) {

@"
## SYNTAX
$(
$Lines = ($Help.Syntax | Out-String) -split "`n"

foreach ($Line in $Lines) {

    "$($Line)`r"

}
)
"@
}
    
if ($Help.Description) {

@"

## DESCRIPTION

$(

foreach ($Description in $Help.description) {

$Description.Text.Trim()

}    

)

"@
}

if ($Help.Parameters.parameter) {

@"
## PARAMETERS

"@

foreach($Parameter in $Help.Parameters.parameter) {

@"

### $($Parameter.name)

"@

if ($Parameter.description) {
 
    foreach ($Description in $Parameter.description) {
        
        ($Description | Out-String).Trim()

    } 

}

@"

* Required: $($Parameter.required)
* Position: $($Parameter.position)
* Default value: $($Parameter.defaultValue)
* Accept pipeline input: $($Parameter.pipelineInput)
"@

}
   
}

if ($Help.inputTypes.inputType.type) {

@"

## INPUTS

$(
foreach($Input in $Help.inputTypes.inputType.type) {

@"
$($Input.name)
"@
}

)

"@

}

if ($Help.returnValues.returnValue.type) {

@"
## OUTPUTS

$(

foreach($Output in $Help.returnValues.returnValue.type) {

@"
$($Output.name)
"@
}

)

"@

}

if ($Help.Examples) {

@"
## EXAMPLES
``````
$(($Help.Examples | Out-String).Trim())
``````

"@

}