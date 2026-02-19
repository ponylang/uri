primitive InvalidScheme is Stringable
  """The scheme contains characters not allowed by RFC 3986 section 3.1."""
  fun string(): String iso^ =>
    "invalid scheme".clone()

// URIBuildError is any error returned by URIBuilder.build().
// InvalidScheme is specific to the builder; InvalidPort and InvalidHost are
// reused from ParseURIAuthority validation.
type URIBuildError is (InvalidScheme | URIParseError)
