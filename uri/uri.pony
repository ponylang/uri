"""
# uri

URI parsing, manipulation, and template expansion library for Pony.

## URI Template Expansion (RFC 6570)

Expand URI templates by substituting variables according to operator-specific
rules for encoding, separators, and naming. All four levels of RFC 6570 are
supported.

Use `UriTemplateParse` to parse a template with detailed error reporting, or the
`UriTemplate` constructor for convenience when error details aren't needed.

```pony
use "uri"

actor Main
  new create(env: Env) =>
    let vars = UriTemplateVariables
    vars.set("host", "example.com")
    vars.set_list("path", ["api"; "v1"; "users"])
    vars.set_pairs("query", [("page", "1"); ("limit", "10")])

    match UriTemplateParse("https://{host}{/path*}{?query*}")
    | let tpl: UriTemplate =>
      env.out.print(tpl.expand(vars))
      // => https://example.com/api/v1/users?page=1&limit=10
    | let err: UriTemplateParseError =>
      env.err.print("Bad template: " + err.string())
    end
```

## Planned Features

* **URI Parsing** - Parse URIs into component parts (scheme, authority, path, query, fragment)
* **URI Building** - Construct URIs from components with proper encoding
* **URI Manipulation** - Modify URI components
"""
