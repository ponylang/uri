# uri

URI library for Pony. Implements [RFC 3986](https://datatracker.ietf.org/doc/html/rfc3986) parsing, reference resolution, and normalization; [RFC 3987](https://datatracker.ietf.org/doc/html/rfc3987) IRI/URI conversion and IRI-aware encoding; and [RFC 6570](https://datatracker.ietf.org/doc/html/rfc6570) URI template expansion at all four levels.

## Status

Beta quality software that will change frequently. Expect breaking changes. That said, you should feel comfortable using it in your projects.

## Installation

* Install [corral](https://github.com/ponylang/corral)
* `corral add github.com/ponylang/uri.git --version 0.2.0`
* `corral fetch` to fetch your dependencies
* `use "uri"` to include this package
  * `use "uri/template"` for URI template expansion
* `corral run -- ponyc` to compile your application

## Usage

See [examples](examples/) for URI parsing and template expansion demonstrations.

## API Documentation

[https://ponylang.github.io/uri](https://ponylang.github.io/uri)
