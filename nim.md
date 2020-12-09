* no global type inference
* calling conventions infecting type system in weird ways (`{.nimcall.}` vs `{.closure.}`)
* no uniform way to parse arbitrary base numbers
* no uniform max for sequences
	* or sum
* "methods" not being associated with classes means you can't tell the difference between the method not being defined for that class, and the method having the wrong signature *after* the first parameter, except by properly inspecting the type mismatch error
