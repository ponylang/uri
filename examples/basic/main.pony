// in your code these `use` statements would be:
// use "uri"
// use "uri/template"
use "../../uri"
use "../../uri/template"

actor Main
  """
  Demonstrates URI parsing and template expansion using the uri library.
  """
  new create(env: Env) =>
    _template_examples(env)
    _parsing_examples(env)

  fun _template_examples(env: Env) =>
    env.out.print("URI Template Expansion Examples")
    env.out.print("===============================")
    env.out.print("")

    // Build variable bindings
    let vars = URITemplateVariables
    vars.set("scheme", "https")
    vars.set("host", "example.com")
    vars.set("path", "/api/v1")
    vars.set("user", "fred")
    vars.set("query", "pony lang")
    vars.set_list("segments", recover val ["api"; "v1"; "users"] end)
    vars.set_pairs("params",
      recover val [("page", "1"); ("limit", "10")] end)

    // Simple expansion
    _expand(env, "{scheme}://{host}{path}", vars)
    // => https://example.com/api/v1

    // Reserved expansion (preserves reserved chars like /)
    _expand(env, "{+path}/users/{user}", vars)
    // => /api/v1/users/fred

    // Fragment expansion
    _expand(env, "https://{host}/docs{#user}", vars)
    // => https://example.com/docs#fred

    // Path segment expansion with exploded list
    _expand(env, "https://{host}{/segments*}", vars)
    // => https://example.com/api/v1/users

    // Query expansion with exploded pairs
    _expand(env, "https://{host}/search{?params*}", vars)
    // => https://example.com/search?page=1&limit=10

    // Query with encoded value
    _expand(env, "https://{host}/search{?query}", vars)
    // => https://example.com/search?query=pony%20lang

    // Prefix modifier
    _expand(env, "{scheme}://{host}/{user:2}", vars)
    // => https://example.com/fr

    env.out.print("")

    // Error handling with URITemplateParse
    env.out.print("Error handling:")
    match URITemplateParse("{=invalid}")
    | let tpl: URITemplate =>
      env.out.print("  (unexpected success)")
    | let err: URITemplateParseError =>
      env.out.print("  " + err.string())
    end

  fun _parsing_examples(env: Env) =>
    env.out.print("")
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

  fun _expand(
    env: Env,
    template: String,
    vars: URITemplateVariables box)
  =>
    try
      let tpl = URITemplate(template)?
      let result: String val = tpl.expand(vars)
      env.out.print("  " + template)
      env.out.print("  => " + result)
      env.out.print("")
    else
      env.out.print("  Failed to parse: " + template)
    end
