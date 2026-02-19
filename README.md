# uri

A library for parsing, manipulating, and expanding URIs for [Pony](https://www.ponylang.io/). Provides URI parsing per [RFC 3986](https://datatracker.ietf.org/doc/html/rfc3986) and URI template expansion per [RFC 6570](https://datatracker.ietf.org/doc/html/rfc6570).

## Status

Early development. Not yet ready for use.

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
