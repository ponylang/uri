## Add URITemplateBuilder for one-shot template expansion

`URITemplateBuilder` combines template parsing, variable binding, and expansion into a single fluent chain — the common case for expanding a template once without needing to reuse the parsed template or inspect parse errors.

```pony
let uri = URITemplateBuilder("{scheme}://{host}{/path*}")
  .set("scheme", "https")
  .set("host", "example.com")
  .set_list("path", ["api"; "v1"; "users"])
  .build()?
// => "https://example.com/api/v1/users"
```

For repeated expansion of the same template, parse once with `URITemplate` and call `expand()` multiple times. For detailed parse error reporting, use `URITemplateParse`.
