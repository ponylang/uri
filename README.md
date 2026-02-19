# uri

A URI library for [Pony](https://www.ponylang.io/). Provides URI parsing and normalization per [RFC 3986](https://datatracker.ietf.org/doc/html/rfc3986), IRI support per [RFC 3987](https://datatracker.ietf.org/doc/html/rfc3987), and URI template expansion per [RFC 6570](https://datatracker.ietf.org/doc/html/rfc6570).

## Status

Beta quality software that will change frequently. Expect breaking changes. That said, you should feel comfortable using it in your projects.

## Installation

* Install [corral](https://github.com/ponylang/corral)
* `corral add github.com/ponylang/uri.git --version 0.1.0`
* `corral fetch` to fetch your dependencies
* Include any of the available packages...
  * `use "uri"` for URI parsing
  * `use "uri/template"` for URI template expansion
* `corral run -- ponyc` to compile your application

## Usage

See [examples](examples/) for URI parsing and template expansion demonstrations.

## API Documentation

[https://ponylang.github.io/uri](https://ponylang.github.io/uri)
