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

**Current state**: Early development, no code yet.

**Planned features**:
- URI parsing according to RFC 3986
- URI manipulation (building, modifying components)
- URI template expansion according to RFC 6570
