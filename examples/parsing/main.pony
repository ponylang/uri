// in your code this `use` statement would be:
// use "uri"
use "../../uri"

actor Main
  """
  Demonstrates URI parsing (RFC 3986).
  """
  new create(env: Env) =>
    env.out.print("URI Parsing Examples")
    env.out.print("====================")
    env.out.print("")

    // Parse a full URI
    match ParseURI("http://user@example.com:8080/path?query=1#frag")
    | let u: URI val =>
      env.out.print("Parsed: " + u.string())
      match u.scheme
      | let s: String => env.out.print("  scheme:    " + s)
      end
      match u.authority
      | let a: URIAuthority =>
        env.out.print("  authority: " + a.string())
        env.out.print("  host:      " + a.host)
        match a.port
        | let p: U16 => env.out.print("  port:      " + p.string())
        end
      end
      env.out.print("  path:      " + u.path)
      match u.query
      | let q: String => env.out.print("  query:     " + q)
      end
      match u.fragment
      | let f: String => env.out.print("  fragment:  " + f)
      end
    | let e: URIParseError val =>
      env.out.print("Parse error: " + e.string())
    end

    env.out.print("")

    // Query parameter lookup
    match ParseURI("https://example.com/search?q=pony&page=1&page=2")
    | let u: URI val =>
      env.out.print("Query parameters for: " + u.string())
      match u.query_params()
      | let params: QueryParams val =>
        match params.get("q")
        | let v: String => env.out.print("  q:    " + v)
        end
        let pages = params.get_all("page")
        env.out.print("  page: " + ", ".join(pages.values()))
      end
    | let e: URIParseError val =>
      env.out.print("Parse error: " + e.string())
    end
