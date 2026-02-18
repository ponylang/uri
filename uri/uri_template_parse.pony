primitive UriTemplateParse
  """
  Parse a URI template string, returning either a valid `UriTemplate`
  or a `UriTemplateParseError` describing what went wrong.

  Use this instead of the `UriTemplate` constructor when you need details
  about parse failures.

  ```pony
  match UriTemplateParse("{+path}/here")
  | let tpl: UriTemplate =>
    let result = tpl.expand(vars)
  | let err: UriTemplateParseError =>
    env.err.print("Bad template: " + err.string())
  end
  ```
  """
  fun apply(template: String): (UriTemplate | UriTemplateParseError) =>
    """
    Parse a URI template string.

    Returns a `UriTemplate` on success or a `UriTemplateParseError` with
    details about the syntax error on failure.
    """
    match _UriTemplateParser.parse(template)
    | let parts: Array[_TemplatePart] val =>
      UriTemplate._from_parts(template, parts)
    | let err: UriTemplateParseError =>
      err
    end
