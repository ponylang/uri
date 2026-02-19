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
