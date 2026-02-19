## Add URI reference resolution per RFC 3986 section 5

Resolve relative URI references against a base URI to produce a target URI. This is the operation browsers perform when following relative links.

```pony
match (ParseURI("http://example.com/a/b/c"), ParseURI("../d"))
| (let base: URI val, let ref': URI val) =>
  match ResolveURI(base, ref')
  | let target: URI val =>
    // target.string() == "http://example.com/a/b/d"
  end
end
```

New API:

- `ResolveURI` — resolves a reference against a base URI
- `RemoveDotSegments` — normalizes `.` and `..` segments in a URI path
- `BaseURINotAbsolute` / `ResolveURIError` — returned when the base URI lacks a scheme

## Add IRI support per RFC 3987

Add IRI (Internationalized Resource Identifier) support for working with URIs that contain Unicode characters. `ParseURI` and `ResolveURI` already handle IRIs natively — the new primitives handle conversion between IRI and URI forms, IRI-aware encoding, normalization, and equivalence.

Convert between IRI and URI forms:

```pony
// IRI to URI — percent-encodes all non-ASCII bytes
match ParseURI("http://example.com/café")
| let iri: URI val =>
  let uri = IRIToURI(iri)
  // uri.string() == "http://example.com/caf%C3%A9"
end

// URI to IRI — decodes ucschar sequences back to literal UTF-8
match ParseURI("http://example.com/caf%C3%A9")
| let uri: URI val =>
  let iri = URIToIRI(uri)
  // iri.string() == "http://example.com/café"
end
```

IRI-aware percent-encoding preserves Unicode characters that are allowed literally in IRIs:

```pony
IRIPercentEncode("café menu", URIPartPath)  // "café%20menu"
PercentEncode("café menu", URIPartPath)     // "caf%C3%A9%20menu"
```

Detect equivalence across IRI and URI forms:

```pony
match (ParseURI("http://example.com/café"), ParseURI("http://example.com/caf%C3%A9"))
| (let a: URI val, let b: URI val) =>
  match IRIEquivalent(a, b)
  | let eq: Bool =>
    // eq == true
  end
end
```

New API:

- `IRIToURI` — convert IRI to URI by percent-encoding non-ASCII bytes
- `URIToIRI` — convert URI to IRI by decoding allowed non-ASCII sequences
- `IRIPercentEncode` — IRI-aware encoding that preserves `ucschar` codepoints
- `NormalizeIRI` — IRI-aware normalization (applies `NormalizeURI` then `URIToIRI`)
- `IRIEquivalent` — equivalence testing across IRI and URI forms

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

