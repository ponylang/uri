class val UriTemplateParseError
  """
  Describes why a URI template string failed to parse.

  Contains a human-readable error message and the byte offset in the
  template string where the error was detected.
  """
  let message: String val
  let offset: USize

  new val create(message': String val, offset': USize) =>
    message = message'
    offset = offset'

  fun string(): String iso^ =>
    """Format as "offset N: message"."""
    let out = recover iso String end
    out.append("offset ")
    out.append(offset.string())
    out.append(": ")
    out.append(message)
    consume out
