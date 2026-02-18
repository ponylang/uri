primitive _OpNone
  """Simple string expansion (no operator)."""

primitive _OpPlus
  """Reserved expansion (+)."""

primitive _OpHash
  """Fragment expansion (#)."""

primitive _OpDot
  """Label expansion (.)."""

primitive _OpSlash
  """Path segments (/)."""

primitive _OpSemicolon
  """Path-style parameters (;)."""

primitive _OpQuestion
  """Form-style query (?)."""

primitive _OpAmpersand
  """Form-style query continuation (&)."""

// Type alias can't have docstrings in Pony
type _Operator is
  ( _OpNone | _OpPlus | _OpHash | _OpDot
  | _OpSlash | _OpSemicolon | _OpQuestion | _OpAmpersand )
