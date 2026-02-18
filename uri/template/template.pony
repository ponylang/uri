"""
# URI Template Expansion (RFC 6570)

Expand URI templates by substituting variables according to operator-specific
rules for encoding, separators, and naming. All four levels of RFC 6570 are
supported.

Use `URITemplateParse` to parse a template with detailed error reporting, or the
`URITemplate` constructor for convenience when error details aren't needed.

```pony
use "uri/template"

actor Main
  new create(env: Env) =>
    let vars = URITemplateVariables
    vars.set("host", "example.com")
    vars.set_list("path", ["api"; "v1"; "users"])
    vars.set_pairs("query", [("page", "1"); ("limit", "10")])

    match URITemplateParse("https://{host}{/path*}{?query*}")
    | let tpl: URITemplate =>
      env.out.print(tpl.expand(vars))
      // => https://example.com/api/v1/users?page=1&limit=10
    | let err: URITemplateParseError =>
      env.err.print("Bad template: " + err.string())
    end
```
"""
