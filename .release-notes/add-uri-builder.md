## Add URIBuilder for URI construction and modification

`URIBuilder` provides a fluent API for constructing URIs from raw (unencoded) components with automatic percent-encoding, and for modifying existing URIs.

Build a URI from scratch:

```pony
match URIBuilder
  .set_scheme("https")
  .set_host("example.com")
  .append_path_segment("api")
  .append_path_segment("users")
  .add_query_param("name", "Jane Doe")
  .build()
| let u: URI val =>
  // u.string() == "https://example.com/api/users?name=Jane%20Doe"
end
```

Modify an existing URI:

```pony
match URIBuilder.from(existing_uri)
  .set_host("other.com")
  .add_query_param("page", "2")
  .build()
| let u: URI val =>
  // uses original scheme, path, etc. with new host and added param
end
```
