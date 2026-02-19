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

