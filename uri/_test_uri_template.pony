use "pony_test"
use "pony_check"

// ============================================================================
// Helper to build the RFC 6570 standard variable set used across test groups
// ============================================================================

primitive _RFC6570Vars
  fun apply(): UriTemplateVariables =>
    let vars = UriTemplateVariables
    vars.set("count", "one,two,three")
    vars.set("dom", "example.com")
    vars.set("dub", "me/too")
    vars.set("hello", "Hello World!")
    vars.set("half", "50%")
    vars.set("var", "value")
    vars.set("who", "fred")
    vars.set("base", "http://example.com/home/")
    vars.set("path", "/foo/bar")
    vars.set("v", "6")
    vars.set("x", "1024")
    vars.set("y", "768")
    vars.set("empty", "")
    vars.set_list("list", recover val ["red"; "green"; "blue"] end)
    vars.set_pairs("keys",
      recover val [("semi", ";"); ("dot", "."); ("comma", ",")] end)
    vars
// ============================================================================
// Example-based tests: RFC 6570 Section 3 — Level 1 & 2 examples
// ============================================================================

class \nodoc\ iso _TestSimpleExpansion is UnitTest
  """RFC 6570 Section 3.2.2: Simple string expansion."""
  fun name(): String => "UriTemplate/simple expansion"

  fun apply(h: TestHelper) =>
    let vars = _RFC6570Vars()

    _assert_expand(h, "{var}", "value", vars)
    _assert_expand(h, "{hello}", "Hello%20World%21", vars)
    _assert_expand(h, "{half}", "50%25", vars)
    _assert_expand(h, "O{empty}X", "OX", vars)
    _assert_expand(h, "O{undef}X", "OX", vars)
    _assert_expand(h, "{x,y}", "1024,768", vars)
    _assert_expand(h, "{x,hello,y}", "1024,Hello%20World%21,768", vars)
    _assert_expand(h, "?{x,empty}", "?1024,", vars)
    _assert_expand(h, "?{x,undef}", "?1024", vars)
    _assert_expand(h, "?{undef,y}", "?768", vars)
    _assert_expand(h, "{var:3}", "val", vars)
    _assert_expand(h, "{var:30}", "value", vars)
    _assert_expand(h, "{list}", "red,green,blue", vars)
    _assert_expand(h, "{list*}", "red,green,blue", vars)
    _assert_expand(h, "{keys}", "semi,%3B,dot,.,comma,%2C", vars)
    _assert_expand(h, "{keys*}", "semi=%3B,dot=.,comma=%2C", vars)

  fun _assert_expand(
    h: TestHelper,
    template: String,
    expected: String,
    vars: UriTemplateVariables box)
  =>
    try
      let tpl = UriTemplate(template)?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val](expected, result
        where msg = "template: " + template)
    else
      h.fail("failed to parse template: " + template)
    end

class \nodoc\ iso _TestReservedExpansion is UnitTest
  """RFC 6570 Section 3.2.3: Reserved expansion (+)."""
  fun name(): String => "UriTemplate/reserved expansion"

  fun apply(h: TestHelper) =>
    let vars = _RFC6570Vars()

    _assert_expand(h, "{+var}", "value", vars)
    _assert_expand(h, "{+hello}", "Hello%20World!", vars)
    _assert_expand(h, "{+half}", "50%25", vars)
    _assert_expand(h, "{base}index", "http%3A%2F%2Fexample.com%2Fhome%2Findex",
      vars)
    _assert_expand(h, "{+base}index", "http://example.com/home/index", vars)
    _assert_expand(h, "O{+empty}X", "OX", vars)
    _assert_expand(h, "O{+undef}X", "OX", vars)
    _assert_expand(h, "{+path}/here", "/foo/bar/here", vars)
    _assert_expand(h, "here?ref={+path}", "here?ref=/foo/bar", vars)
    _assert_expand(h, "up{+path}{var}/here",
      "up/foo/barvalue/here", vars)
    _assert_expand(h, "{+x,hello,y}", "1024,Hello%20World!,768", vars)
    _assert_expand(h, "{+path,x}/here", "/foo/bar,1024/here", vars)
    _assert_expand(h, "{+path:6}/here", "/foo/b/here", vars)
    _assert_expand(h, "{+list}", "red,green,blue", vars)
    _assert_expand(h, "{+list*}", "red,green,blue", vars)
    _assert_expand(h, "{+keys}", "semi,;,dot,.,comma,,", vars)
    _assert_expand(h, "{+keys*}", "semi=;,dot=.,comma=,", vars)

  fun _assert_expand(
    h: TestHelper,
    template: String,
    expected: String,
    vars: UriTemplateVariables box)
  =>
    try
      let tpl = UriTemplate(template)?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val](expected, result
        where msg = "template: " + template)
    else
      h.fail("failed to parse template: " + template)
    end

class \nodoc\ iso _TestFragmentExpansion is UnitTest
  """RFC 6570 Section 3.2.4: Fragment expansion (#)."""
  fun name(): String => "UriTemplate/fragment expansion"

  fun apply(h: TestHelper) =>
    let vars = _RFC6570Vars()

    _assert_expand(h, "{#var}", "#value", vars)
    _assert_expand(h, "{#hello}", "#Hello%20World!", vars)
    _assert_expand(h, "{#half}", "#50%25", vars)
    _assert_expand(h, "foo{#empty}", "foo#", vars)
    _assert_expand(h, "foo{#undef}", "foo", vars)
    _assert_expand(h, "{#x,hello,y}", "#1024,Hello%20World!,768", vars)
    _assert_expand(h, "{#path,x}/here", "#/foo/bar,1024/here", vars)
    _assert_expand(h, "{#path:6}/here", "#/foo/b/here", vars)
    _assert_expand(h, "{#list}", "#red,green,blue", vars)
    _assert_expand(h, "{#list*}", "#red,green,blue", vars)
    _assert_expand(h, "{#keys}", "#semi,;,dot,.,comma,,", vars)
    _assert_expand(h, "{#keys*}", "#semi=;,dot=.,comma=,", vars)

  fun _assert_expand(
    h: TestHelper,
    template: String,
    expected: String,
    vars: UriTemplateVariables box)
  =>
    try
      let tpl = UriTemplate(template)?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val](expected, result
        where msg = "template: " + template)
    else
      h.fail("failed to parse template: " + template)
    end

class \nodoc\ iso _TestLabelExpansion is UnitTest
  """RFC 6570 Section 3.2.5: Label expansion with dot-prefix (.)."""
  fun name(): String => "UriTemplate/label expansion"

  fun apply(h: TestHelper) =>
    let vars = _RFC6570Vars()

    _assert_expand(h, "{.who}", ".fred", vars)
    _assert_expand(h, "{.who,who}", ".fred.fred", vars)
    _assert_expand(h, "{.half,who}", ".50%25.fred", vars)
    _assert_expand(h, "X{.var}", "X.value", vars)
    _assert_expand(h, "X{.empty}", "X.", vars)
    _assert_expand(h, "X{.undef}", "X", vars)
    _assert_expand(h, "X{.var:3}", "X.val", vars)
    _assert_expand(h, "X{.list}", "X.red,green,blue", vars)
    _assert_expand(h, "X{.list*}", "X.red.green.blue", vars)
    _assert_expand(h, "X{.keys}", "X.semi,%3B,dot,.,comma,%2C", vars)
    _assert_expand(h, "X{.keys*}", "X.semi=%3B.dot=..comma=%2C", vars)
    _assert_expand(h, "X{.empty,who}", "X..fred", vars)

  fun _assert_expand(
    h: TestHelper,
    template: String,
    expected: String,
    vars: UriTemplateVariables box)
  =>
    try
      let tpl = UriTemplate(template)?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val](expected, result
        where msg = "template: " + template)
    else
      h.fail("failed to parse template: " + template)
    end

class \nodoc\ iso _TestPathSegmentExpansion is UnitTest
  """RFC 6570 Section 3.2.6: Path segments (/)."""
  fun name(): String => "UriTemplate/path segment expansion"

  fun apply(h: TestHelper) =>
    let vars = _RFC6570Vars()

    _assert_expand(h, "{/who}", "/fred", vars)
    _assert_expand(h, "{/who,who}", "/fred/fred", vars)
    _assert_expand(h, "{/half,who}", "/50%25/fred", vars)
    _assert_expand(h, "{/who,dub}", "/fred/me%2Ftoo", vars)
    _assert_expand(h, "{/var}", "/value", vars)
    _assert_expand(h, "{/var,empty}", "/value/", vars)
    _assert_expand(h, "{/var,undef}", "/value", vars)
    _assert_expand(h, "{/var,x}/here", "/value/1024/here", vars)
    _assert_expand(h, "{/var:1,var}", "/v/value", vars)
    _assert_expand(h, "{/list}", "/red,green,blue", vars)
    _assert_expand(h, "{/list*}", "/red/green/blue", vars)
    _assert_expand(h, "{/list*,path:4}", "/red/green/blue/%2Ffoo", vars)
    _assert_expand(h, "{/keys}", "/semi,%3B,dot,.,comma,%2C", vars)
    _assert_expand(h, "{/keys*}", "/semi=%3B/dot=./comma=%2C", vars)

  fun _assert_expand(
    h: TestHelper,
    template: String,
    expected: String,
    vars: UriTemplateVariables box)
  =>
    try
      let tpl = UriTemplate(template)?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val](expected, result
        where msg = "template: " + template)
    else
      h.fail("failed to parse template: " + template)
    end

class \nodoc\ iso _TestPathParameterExpansion is UnitTest
  """RFC 6570 Section 3.2.7: Path-style parameters (;)."""
  fun name(): String => "UriTemplate/path parameter expansion"

  fun apply(h: TestHelper) =>
    let vars = _RFC6570Vars()

    _assert_expand(h, "{;who}", ";who=fred", vars)
    _assert_expand(h, "{;half}", ";half=50%25", vars)
    _assert_expand(h, "{;empty}", ";empty", vars)
    _assert_expand(h, "{;v,empty,who}", ";v=6;empty;who=fred", vars)
    _assert_expand(h, "{;v,bar,who}", ";v=6;who=fred", vars)
    _assert_expand(h, "{;x,y}", ";x=1024;y=768", vars)
    _assert_expand(h, "{;x,y,empty}", ";x=1024;y=768;empty", vars)
    _assert_expand(h, "{;x,y,undef}", ";x=1024;y=768", vars)
    _assert_expand(h, "{;hello:5}", ";hello=Hello", vars)
    _assert_expand(h, "{;list}", ";list=red,green,blue", vars)
    _assert_expand(h, "{;list*}", ";list=red;list=green;list=blue", vars)
    _assert_expand(h, "{;keys}", ";keys=semi,%3B,dot,.,comma,%2C", vars)
    _assert_expand(h, "{;keys*}", ";semi=%3B;dot=.;comma=%2C", vars)

  fun _assert_expand(
    h: TestHelper,
    template: String,
    expected: String,
    vars: UriTemplateVariables box)
  =>
    try
      let tpl = UriTemplate(template)?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val](expected, result
        where msg = "template: " + template)
    else
      h.fail("failed to parse template: " + template)
    end

class \nodoc\ iso _TestQueryExpansion is UnitTest
  """RFC 6570 Section 3.2.8: Form-style query (?)."""
  fun name(): String => "UriTemplate/query expansion"

  fun apply(h: TestHelper) =>
    let vars = _RFC6570Vars()

    _assert_expand(h, "{?who}", "?who=fred", vars)
    _assert_expand(h, "{?half}", "?half=50%25", vars)
    _assert_expand(h, "{?x,y}", "?x=1024&y=768", vars)
    _assert_expand(h, "{?x,y,empty}", "?x=1024&y=768&empty=", vars)
    _assert_expand(h, "{?x,y,undef}", "?x=1024&y=768", vars)
    _assert_expand(h, "{?var:3}", "?var=val", vars)
    _assert_expand(h, "{?list}", "?list=red,green,blue", vars)
    _assert_expand(h, "{?list*}", "?list=red&list=green&list=blue", vars)
    _assert_expand(h, "{?keys}", "?keys=semi,%3B,dot,.,comma,%2C", vars)
    _assert_expand(h, "{?keys*}", "?semi=%3B&dot=.&comma=%2C", vars)

  fun _assert_expand(
    h: TestHelper,
    template: String,
    expected: String,
    vars: UriTemplateVariables box)
  =>
    try
      let tpl = UriTemplate(template)?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val](expected, result
        where msg = "template: " + template)
    else
      h.fail("failed to parse template: " + template)
    end

class \nodoc\ iso _TestQueryContinuationExpansion is UnitTest
  """RFC 6570 Section 3.2.9: Form-style query continuation (&)."""
  fun name(): String => "UriTemplate/query continuation expansion"

  fun apply(h: TestHelper) =>
    let vars = _RFC6570Vars()

    _assert_expand(h, "{&who}", "&who=fred", vars)
    _assert_expand(h, "{&half}", "&half=50%25", vars)
    _assert_expand(h, "?fixed=yes{&x}", "?fixed=yes&x=1024", vars)
    _assert_expand(h, "{&x,y,empty}", "&x=1024&y=768&empty=", vars)
    _assert_expand(h, "{&x,y,undef}", "&x=1024&y=768", vars)
    _assert_expand(h, "{&var:3}", "&var=val", vars)
    _assert_expand(h, "{&list}", "&list=red,green,blue", vars)
    _assert_expand(h, "{&list*}", "&list=red&list=green&list=blue", vars)
    _assert_expand(h, "{&keys}", "&keys=semi,%3B,dot,.,comma,%2C", vars)
    _assert_expand(h, "{&keys*}", "&semi=%3B&dot=.&comma=%2C", vars)

  fun _assert_expand(
    h: TestHelper,
    template: String,
    expected: String,
    vars: UriTemplateVariables box)
  =>
    try
      let tpl = UriTemplate(template)?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val](expected, result
        where msg = "template: " + template)
    else
      h.fail("failed to parse template: " + template)
    end

// ============================================================================
// Parser error tests
// ============================================================================

class \nodoc\ iso _TestParseErrorReservedOp is UnitTest
  """Reserved operators produce specific error messages."""
  fun name(): String => "UriTemplate/parse error: reserved operator"

  fun apply(h: TestHelper) =>
    _assert_parse_error(h, "{=var}", "reserved operator '='", 1)
    _assert_parse_error(h, "{,var}", "reserved operator ','", 1)
    _assert_parse_error(h, "{!var}", "reserved operator '!'", 1)
    _assert_parse_error(h, "{@var}", "reserved operator '@'", 1)
    _assert_parse_error(h, "{|var}", "reserved operator '|'", 1)

  fun _assert_parse_error(
    h: TestHelper,
    template: String,
    expected_msg: String,
    expected_offset: USize)
  =>
    match UriTemplateParse(template)
    | let _: UriTemplate =>
      h.fail("expected parse error for: " + template)
    | let err: UriTemplateParseError =>
      h.assert_eq[String val](expected_msg, err.message
        where msg = "template: " + template)
      h.assert_eq[USize](expected_offset, err.offset
        where msg = "template: " + template + " offset")
    end

class \nodoc\ iso _TestParseErrorUnclosed is UnitTest
  """Unclosed expression produces error at the opening brace."""
  fun name(): String => "UriTemplate/parse error: unclosed"

  fun apply(h: TestHelper) =>
    match UriTemplateParse("{var")
    | let _: UriTemplate =>
      h.fail("expected parse error")
    | let err: UriTemplateParseError =>
      h.assert_eq[String val]("unclosed expression", err.message)
      h.assert_eq[USize](0, err.offset)
    end

class \nodoc\ iso _TestParseErrorEmptyExpression is UnitTest
  """Empty expression {} produces error."""
  fun name(): String => "UriTemplate/parse error: empty expression"

  fun apply(h: TestHelper) =>
    match UriTemplateParse("{}")
    | let _: UriTemplate =>
      h.fail("expected parse error")
    | let err: UriTemplateParseError =>
      h.assert_eq[String val]("empty expression", err.message)
      h.assert_eq[USize](0, err.offset)
    end

class \nodoc\ iso _TestParseErrorEmptyVarname is UnitTest
  """Trailing comma with no varname produces error."""
  fun name(): String => "UriTemplate/parse error: empty varname"

  fun apply(h: TestHelper) =>
    match UriTemplateParse("{,}")
    | let _: UriTemplate =>
      h.fail("expected parse error")
    | let err: UriTemplateParseError =>
      // The comma is parsed as reserved operator
      h.assert_eq[String val]("reserved operator ','", err.message)
    end

class \nodoc\ iso _TestParseErrorPrefixBounds is UnitTest
  """Prefix values at boundaries: 0 too low, 10000 too high."""
  fun name(): String => "UriTemplate/parse error: prefix bounds"

  fun apply(h: TestHelper) =>
    match UriTemplateParse("{var:0}")
    | let _: UriTemplate =>
      h.fail("expected parse error for :0")
    | let err: UriTemplateParseError =>
      h.assert_eq[String val](
        "prefix length must be at least 1", err.message)
    end

    match UriTemplateParse("{var:10000}")
    | let _: UriTemplate =>
      h.fail("expected parse error for :10000")
    | let err: UriTemplateParseError =>
      h.assert_eq[String val](
        "prefix length exceeds 4 digits", err.message)
    end

class \nodoc\ iso _TestParseErrorDotInVarname is UnitTest
  """Leading and consecutive dots in varnames produce errors."""
  fun name(): String => "UriTemplate/parse error: dots in varname"

  fun apply(h: TestHelper) =>
    match UriTemplateParse("{..var}")
    | let _: UriTemplate =>
      h.fail("expected parse error for leading dot")
    | let err: UriTemplateParseError =>
      h.assert_eq[String val]("leading dot in varname", err.message)
    end

    match UriTemplateParse("{var..x}")
    | let _: UriTemplate =>
      h.fail("expected parse error for consecutive dots")
    | let err: UriTemplateParseError =>
      h.assert_eq[String val](
        "consecutive dots in varname", err.message)
    end

class \nodoc\ iso _TestParseErrorUnexpectedCloseBrace is UnitTest
  """Stray } in literal text produces error."""
  fun name(): String => "UriTemplate/parse error: unexpected }"

  fun apply(h: TestHelper) =>
    match UriTemplateParse("foo}bar")
    | let _: UriTemplate =>
      h.fail("expected parse error")
    | let err: UriTemplateParseError =>
      h.assert_eq[String val]("unexpected '}'", err.message)
      h.assert_eq[USize](3, err.offset)
    end

class \nodoc\ iso _TestParseErrorInvalidLiteralChar is UnitTest
  """Invalid literal characters (space, <, >) produce errors."""
  fun name(): String => "UriTemplate/parse error: invalid literal char"

  fun apply(h: TestHelper) =>
    match UriTemplateParse("foo bar")
    | let _: UriTemplate =>
      h.fail("expected parse error for space")
    | let err: UriTemplateParseError =>
      h.assert_eq[String val]("invalid literal character", err.message)
      h.assert_eq[USize](3, err.offset)
    end

class \nodoc\ iso _TestParseValidTemplates is UnitTest
  """Valid templates with various operators parse successfully."""
  fun name(): String => "UriTemplate/parse valid templates"

  fun apply(h: TestHelper) =>
    let valid: Array[String] val = [
      ""                          // empty template
      "literal"                   // pure literal
      "{var}"                     // simple
      "{+var}"                    // reserved
      "{#var}"                    // fragment
      "{.var}"                    // label
      "{/var}"                    // path
      "{;var}"                    // parameter
      "{?var}"                    // query
      "{&var}"                    // continuation
      "{var:3}"                   // prefix
      "{var*}"                    // explode
      "{x,y}"                     // multiple vars
      "{?x,y,z}"                  // query with multiple
      "http://example.com/{var}"  // full URL pattern
      "{var.name}"                // dot-separated varname
    ]

    for template in valid.values() do
      match UriTemplateParse(template)
      | let _: UriTemplate => None
      | let err: UriTemplateParseError =>
        h.fail("unexpected parse error for '" + template + "': "
          + err.string())
      end
    end

class \nodoc\ iso _TestTemplateString is UnitTest
  """UriTemplate.string() returns the original template."""
  fun name(): String => "UriTemplate/string roundtrip"

  fun apply(h: TestHelper) =>
    let templates: Array[String] val = [
      ""
      "literal"
      "{var}"
      "{+path}/here{?x,y}"
    ]

    for template in templates.values() do
      try
        let tpl = UriTemplate(template)?
        h.assert_eq[String val](template, tpl.string())
      else
        h.fail("failed to parse: " + template)
      end
    end

// ============================================================================
// Composite expansion edge cases
// ============================================================================

class \nodoc\ iso _TestEmptyListUndefined is UnitTest
  """Empty list is treated as undefined — produces no output."""
  fun name(): String => "UriTemplate/empty list is undefined"

  fun apply(h: TestHelper) =>
    let vars = UriTemplateVariables
    vars.set_list("empty_list", recover val Array[String val] end)
    vars.set("x", "1024")

    try
      let tpl = UriTemplate("{?x,empty_list}")?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val]("?x=1024", result)
    else
      h.fail("failed to parse template")
    end

class \nodoc\ iso _TestEmptyPairsUndefined is UnitTest
  """Empty pairs is treated as undefined — produces no output."""
  fun name(): String => "UriTemplate/empty pairs is undefined"

  fun apply(h: TestHelper) =>
    let vars = UriTemplateVariables
    vars.set_pairs("empty_pairs",
      recover val Array[(String val, String val)] end)
    vars.set("x", "1024")

    try
      let tpl = UriTemplate("{?x,empty_pairs}")?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val]("?x=1024", result)
    else
      h.fail("failed to parse template")
    end

class \nodoc\ iso _TestAllUndefined is UnitTest
  """All variables undefined produces empty string for expression."""
  fun name(): String => "UriTemplate/all undefined"

  fun apply(h: TestHelper) =>
    let vars = UriTemplateVariables

    try
      let tpl = UriTemplate("{?x,y,z}")?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val]("", result)
    else
      h.fail("failed to parse template")
    end

class \nodoc\ iso _TestExplodeListQuery is UnitTest
  """Exploded list with query: each item gets name= prefix."""
  fun name(): String => "UriTemplate/explode list query"

  fun apply(h: TestHelper) =>
    let vars = UriTemplateVariables
    vars.set_list("colors",
      recover val ["red"; "green"; "blue"] end)

    try
      let tpl = UriTemplate("{?colors*}")?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val]("?colors=red&colors=green&colors=blue", result)
    else
      h.fail("failed to parse template")
    end

class \nodoc\ iso _TestExplodePairsQuery is UnitTest
  """Exploded pairs with query: each pair becomes key=value."""
  fun name(): String => "UriTemplate/explode pairs query"

  fun apply(h: TestHelper) =>
    let vars = UriTemplateVariables
    vars.set_pairs("opts",
      recover val [("page", "1"); ("size", "10")] end)

    try
      let tpl = UriTemplate("{?opts*}")?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val]("?page=1&size=10", result)
    else
      h.fail("failed to parse template")
    end

class \nodoc\ iso _TestExplodeListSemicolon is UnitTest
  """Exploded list with semicolon: name=value for each item per RFC 6570."""
  fun name(): String => "UriTemplate/explode list semicolon"

  fun apply(h: TestHelper) =>
    let vars = _RFC6570Vars()

    try
      let tpl = UriTemplate("{;list*}")?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val](";list=red;list=green;list=blue", result)
    else
      h.fail("failed to parse template")
    end

class \nodoc\ iso _TestPrefixUnicode is UnitTest
  """Prefix modifier counts codepoints, not bytes."""
  fun name(): String => "UriTemplate/prefix counts codepoints"

  fun apply(h: TestHelper) =>
    let vars = UriTemplateVariables
    // Build "cafés" manually: c a f é(0xC3 0xA9) s
    let word = recover val
      let s = String
      s.push('c')
      s.push('a')
      s.push('f')
      s.push(0xC3)
      s.push(0xA9)
      s.push('s')
      s
    end
    vars.set("word", word)

    try
      let tpl = UriTemplate("{word:4}")?
      let result: String val = tpl.expand(vars)
      // First 4 codepoints: c a f é => encoded as caf%C3%A9
      h.assert_eq[String val]("caf%C3%A9", result)
    else
      h.fail("failed to parse template")
    end

// ============================================================================
// Property-based tests
// ============================================================================

class \nodoc\ iso _TestPropertyNoBracesInExpansion is Property1[String]
  """Property: expansion output contains no raw braces."""
  fun name(): String => "UriTemplate/property: no braces in expansion"

  fun gen(): Generator[String] =>
    // Generate valid templates from building blocks
    _TemplateGenerators.valid_template()

  fun ref property(arg1: String, h: PropertyHelper) =>
    match UriTemplateParse(arg1)
    | let tpl: UriTemplate =>
      let vars = _RFC6570Vars()
      let result: String val = tpl.expand(vars)
      for byte in result.values() do
        if byte == '{' then
          h.fail("expansion contains '{' for template: " + arg1)
          return
        end
        if byte == '}' then
          h.fail("expansion contains '}' for template: " + arg1)
          return
        end
      end
    | let err: UriTemplateParseError =>
      h.fail("generated template should be valid: " + arg1
        + " error: " + err.string())
    end

class \nodoc\ iso _TestPropertyUnreservedPassthrough is Property1[String]
  """Property: unreserved values in simple expansion pass through unchanged."""
  fun name(): String =>
    "UriTemplate/property: unreserved value passthrough"

  fun gen(): Generator[String] =>
    _TemplateGenerators.unreserved_string(1, 30)

  fun ref property(arg1: String, h: PropertyHelper) =>
    let vars = UriTemplateVariables
    vars.set("x", arg1)
    try
      let tpl = UriTemplate("{x}")?
      let result: String val = tpl.expand(vars)
      h.assert_eq[String val](arg1, result)
    else
      h.fail("failed to parse {x}")
    end

class \nodoc\ iso _TestPropertyValidTemplatesParse is Property1[String]
  """Property: valid generated templates always parse successfully."""
  fun name(): String => "UriTemplate/property: valid templates parse"

  fun gen(): Generator[String] =>
    _TemplateGenerators.valid_template()

  fun ref property(arg1: String, h: PropertyHelper) =>
    match UriTemplateParse(arg1)
    | let _: UriTemplate => None
    | let err: UriTemplateParseError =>
      h.fail("valid template failed to parse: '" + arg1
        + "' error: " + err.string())
    end

class \nodoc\ iso _TestPropertyInvalidTemplatesFail is Property1[String]
  """Property: invalid generated templates always fail to parse."""
  fun name(): String => "UriTemplate/property: invalid templates fail"

  fun gen(): Generator[String] =>
    _TemplateGenerators.invalid_template()

  fun ref property(arg1: String, h: PropertyHelper) =>
    match UriTemplateParse(arg1)
    | let _: UriTemplate =>
      h.fail("invalid template should not parse: '" + arg1 + "'")
    | let _: UriTemplateParseError => None
    end

class \nodoc\ iso _TestPropertyMixedTemplates is Property1[(String, Bool)]
  """
  Property: mixed valid/invalid templates succeed iff they're the valid variant.
  """
  fun name(): String => "UriTemplate/property: mixed valid/invalid boundary"

  fun gen(): Generator[(String, Bool)] =>
    _TemplateGenerators.mixed_template()

  fun ref property(arg1: (String, Bool), h: PropertyHelper) =>
    (let template, let is_valid) = arg1
    match UriTemplateParse(template)
    | let _: UriTemplate =>
      if not is_valid then
        h.fail("invalid template should not parse: '" + template + "'")
      end
    | let err: UriTemplateParseError =>
      if is_valid then
        h.fail("valid template failed to parse: '" + template
          + "' error: " + err.string())
      end
    end

// ============================================================================
// Template generators for property tests
// ============================================================================

primitive _TemplateGenerators
  fun unreserved_string(
    min: USize = 0,
    max: USize = 30)
    : Generator[String]
  =>
    let unreserved_bytes: Array[U8] val = recover val
      let arr = Array[U8]
      for ch in "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~".values() do
        arr.push(ch)
      end
      arr
    end
    Generators.byte_string(
      Generators.usize(0, unreserved_bytes.size() - 1)
        .map[U8]({(idx) =>
          try unreserved_bytes(idx)? else 'a' end
        }),
      min, max)

  fun valid_varname(): Generator[String] =>
    let name_bytes: Array[U8] val = recover val
      let arr = Array[U8]
      for ch in "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_".values() do
        arr.push(ch)
      end
      arr
    end
    Generators.byte_string(
      Generators.usize(0, name_bytes.size() - 1)
        .map[U8]({(idx) =>
          try name_bytes(idx)? else 'a' end
        }),
      1, 10)

  fun valid_expression(): Generator[String] =>
    let ops: Array[String val] val = [""; "+"; "#"; "."; "/"; ";"; "?"; "&"]
    Generators.usize(0, ops.size() - 1)
      .flat_map[String]({(op_idx)(ops) =>
        _TemplateGenerators.valid_varname()
          .map[String]({(name)(op_idx, ops) =>
            let op = try ops(op_idx)? else "" end
            recover val
              String.>append("{")
                .>append(op)
                .>append(name)
                .>append("}")
            end
          })
      })

  fun valid_template(): Generator[String] =>
    // Generate 1-3 parts (mix of literals and expressions)
    Generators.usize(1, 3)
      .flat_map[String]({(num_parts) =>
        // Build a template by alternating literals and expressions
        _TemplateGenerators.valid_expression()
          .map[String]({(expr)(num_parts) =>
            if num_parts > 1 then
              recover val
                String.>append("http://example.com/")
                  .>append(expr)
              end
            else
              expr
            end
          })
      })

  fun invalid_template(): Generator[String] =>
    // Generate various kinds of invalid templates
    Generators.frequency[String]([
      // Unclosed expression
      (1, _TemplateGenerators.valid_varname()
        .map[String]({(name) =>
          recover val String.>append("{").>append(name) end
        }))
      // Reserved operator
      (1, _TemplateGenerators.valid_varname()
        .map[String]({(name) =>
          recover val
            String.>append("{=").>append(name).>append("}")
          end
        }))
      // Empty expression
      (1, Generators.unit[String]("{}"))
      // Stray close brace
      (1, Generators.unit[String]("foo}bar"))
      // Space in literal
      (1, Generators.unit[String]("foo bar"))
    ])

  fun mixed_template(): Generator[(String, Bool)] =>
    Generators.bool()
      .flat_map[(String, Bool)]({(is_valid) =>
        if is_valid then
          _TemplateGenerators.valid_template()
            .map[(String, Bool)]({(tpl) => (tpl, true) })
        else
          _TemplateGenerators.invalid_template()
            .map[(String, Bool)]({(tpl) => (tpl, false) })
        end
      })
