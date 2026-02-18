# uri

URI parsing, manipulation, and template expansion library for Pony.

## Building and Testing

```bash
make                    # build tests + examples (release)
make test               # same as above
make config=debug       # debug build
make build-examples     # examples only
make clean              # clean build artifacts + corral cache
```

## Project Status

**Current state**: Early development.

**Implemented features**:
- URI parsing according to RFC 3986 (scheme, authority, path, query, fragment)
- URI template expansion according to RFC 6570 (all 4 levels)

**Planned features**:
- URI manipulation (building, modifying components)

## Architecture

Two packages: `uri` for RFC 3986 parsing, `uri/template` for RFC 6570 template expansion. They are independent — neither imports the other.

### `uri` Package — RFC 3986 Parsing

- **Public API**: `URI`, `URIAuthority`, `ParseURI`, `ParseURIAuthority`, `URIParseError` (`InvalidPort`, `InvalidHost`), `PercentEncode`, `PercentDecode`, `InvalidPercentEncoding`, `URIPart` (+ 5 part primitives), `PathSegments`, `ParseQueryParameters`, `QueryParams`
- **Internal**: `_Unreachable` for unreachable code paths

### `uri/template` Package — RFC 6570 Template Expansion

- **Public API**: `URITemplate`, `URITemplateParse`, `URITemplateVariables`, `URITemplateParseError`, `URITemplateValue`
- **Internal**: Parser (`_URITemplateParser`) does single-pass left-to-right scanning into `_TemplatePart` AST nodes. Expander (`_URITemplateExpander`) walks the AST and produces output. `_PctEncode` handles percent-encoding in unreserved and reserved modes. `_OperatorProperties` encodes the RFC 6570 operator behavior table.

### Testing

Single test runner in `uri/_test.pony` that delegates to `uri/template`'s test Main via `template.Main.make().tests(test)`.
