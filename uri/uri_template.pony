class val UriTemplate
  """
  A parsed URI template (RFC 6570) ready for variable expansion.

  Parse a template string into a `UriTemplate`, then call `expand()` with
  variable bindings to produce the expanded URI. Use `UriTemplateParse` for
  detailed error information on invalid templates, or the convenience
  constructor on this class when error details aren't needed.

  ```pony
  let tpl = UriTemplate("{scheme}://{host}{/path*}{?query*}")?
  let vars = UriTemplateVariables
  vars.set("scheme", "https")
  vars.set("host", "example.com")
  vars.set_list("path", ["api"; "v1"; "users"])
  vars.set_pairs("query", [("page", "1"); ("limit", "10")])
  let uri: String val = tpl.expand(vars)
  // uri == "https://example.com/api/v1/users?page=1&limit=10"
  ```
  """
  let _template: String val
  let _parts: Array[_TemplatePart] val

  new val create(template: String) ? =>
    """
    Parse a URI template string.

    Raises an error if the template has invalid syntax. Use `UriTemplateParse`
    instead when you need a description of what went wrong.
    """
    _template = template
    _parts = match _UriTemplateParser.parse(template)
    | let p: Array[_TemplatePart] val => p
    | let _: UriTemplateParseError => error
    end

  new val _from_parts(template: String, parts: Array[_TemplatePart] val) =>
    """Internal constructor used by UriTemplateParse."""
    _template = template
    _parts = parts

  fun expand(vars: UriTemplateVariables box): String iso^ =>
    """
    Expand the template with the given variables.

    Always succeeds. Undefined variables produce no output per RFC 6570.
    """
    _UriTemplateExpander.expand(_parts, vars)

  fun string(): String iso^ =>
    """Return the original template string."""
    _template.clone()
