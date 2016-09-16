@"
---

site_name: $($ModuleName)
pages:
- 'Home' : 'index.md'
- 'Functions': 
$(foreach ($Command in $ModuleCommands) {

@"

   - '$($Command)' : '$($Command).md'

"@
})
"@
