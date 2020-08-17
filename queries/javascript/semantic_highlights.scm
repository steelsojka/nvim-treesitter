((identifier) @variable.builtin
 (#not-is? @variable.builtin import var parameter)
 (#vim-match? @variable.builtin "^(arguments|module|console|window|document)$"))

((identifier) @function.builtin
 (#not-is? @function.builtin import var parameter)
 (#eq? @function.builtin "require"))

((identifier) @parameter.reference
 (#is? @parameter.reference parameter))


