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
- URI template expansion according to RFC 6570 (all 4 levels)

**Planned features**:
- URI parsing according to RFC 3986
- URI manipulation (building, modifying components)

## Architecture

The template expansion implementation follows this structure:

- **Public API**: `UriTemplate`, `UriTemplateParse`, `UriTemplateVariables`, `UriTemplateParseError`, `UriTemplateValue`
- **Internal**: Parser (`_UriTemplateParser`) does single-pass left-to-right scanning into `_TemplatePart` AST nodes. Expander (`_UriTemplateExpander`) walks the AST and produces output. `_PctEncode` handles percent-encoding in unreserved and reserved modes. `_OperatorProperties` encodes the RFC 6570 operator behavior table.
