# Examples

Each subdirectory is a self-contained Pony program demonstrating a different part of the uri library. Ordered from foundational to more specialized.

## [parsing](parsing/)

Parses a full URI and prints each component (scheme, authority, host, port, path, query, fragment). Demonstrates query parameter lookup with `URI.query_params()`, standalone authority parsing with `ParseURIAuthority`, path segment splitting with `PathSegments`, percent-encoding and decoding with `PercentEncode` and `PercentDecode`, reference resolution with `ResolveURI`, normalization with `NormalizeURI`, and equivalence checking with `URIEquivalent`. Start here if you're new to the library.

## [building](building/)

Constructs a URI from scratch using `URIBuilder`'s fluent API, chaining `set_scheme()`, `set_host()`, `append_path_segment()`, `add_query_param()`, and `set_fragment()`. Also demonstrates modifying an existing URI with `URIBuilder.from()` and error handling for invalid schemes via `URIBuildError`.

## [iri](iri/)

Parses a URI containing non-ASCII characters and demonstrates IRI/URI round-trip conversion with `IRIToURI` and `URIToIRI`. Covers IRI-aware percent-encoding with `IRIPercentEncode` (which preserves Unicode characters that `PercentEncode` would escape), IRI normalization with `NormalizeIRI`, and cross-form equivalence checking with `IRIEquivalent`.

## [template](template/)

Expands URI templates (RFC 6570) by parsing a template string with `URITemplate` and binding variables with `URITemplateVariables`. Demonstrates all variable types (strings, lists, pairs), multiple operator styles (simple, reserved `+`, fragment `#`, path `/`, query `?`), the explode modifier `*`, and the prefix modifier. Also shows error handling via `URITemplateParse`.

## [template-builder](template-builder/)

Performs one-shot URI template expansion using `URITemplateBuilder`'s fluent API, which combines template parsing and variable binding into a single chain. Demonstrates all three variable types (`set()`, `set_list()`, `set_pairs()`) and error handling for invalid templates.
