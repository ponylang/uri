## Rename ParseQueryParameters and QueryParams to ParseFormURLEncoded and FormURLEncoded

`ParseQueryParameters` and `QueryParams` have been renamed to `ParseFormURLEncoded` and `FormURLEncoded` to reflect the `application/x-www-form-urlencoded` format they implement. The same format is used for both URI query strings and HTTP POST request bodies, and the new names serve both contexts.

Before:

```pony
match ParseQueryParameters("key=value&name=Jane+Doe")
| let params: QueryParams val =>
  match params.get("name")
  | let v: String => // "Jane Doe"
  end
end
```

After:

```pony
match ParseFormURLEncoded("key=value&name=Jane+Doe")
| let params: FormURLEncoded val =>
  match params.get("name")
  | let v: String => // "Jane Doe"
  end
end
```

`URI.query_params()` is unchanged — it now returns `(FormURLEncoded val | None)` instead of `(QueryParams val | None)`.

## Make form-urlencoded parsing available for HTTP request bodies

`ParseFormURLEncoded` can be called directly on any `application/x-www-form-urlencoded` string, not just a URI's query component. This makes it usable for parsing HTTP POST request bodies that use the same format.

```pony
// Parse an HTTP POST body
match ParseFormURLEncoded(post_body)
| let form: FormURLEncoded val =>
  match form.get("username")
  | let v: String => // use v
  end
| let err: InvalidPercentEncoding val =>
  // handle error
end
```
