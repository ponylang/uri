use "pony_test"
use "pony_check"
use template = "./template"

actor \nodoc\ Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    // URI template expansion (uri/template subpackage)
    template.Main.make().tests(test)

    // Percent-encoding tests
    test(Property1UnitTest[String val](_PropertyPercentRoundtrip))
    test(Property1UnitTest[String val](
      _PropertyPercentEncodeOutputLegal))
    test(Property1UnitTest[String val](
      _PropertyInvalidPercentSequenceRejected))
    test(Property1UnitTest[(String val, Bool)](
      _PropertyPercentDecodeBoundary))
    test(_TestPercentEncodeKnownGood)

    // URI parsing tests
    test(Property1UnitTest[_ValidURIInput](_PropertyURIRoundtrip))
    test(Property1UnitTest[String val](_PropertyInvalidSchemeRejected))
    test(_TestParseURIKnownGood)

    // Authority parsing tests
    test(Property1UnitTest[_ValidAuthorityInput](
      _PropertyAuthorityRoundtrip))
    test(Property1UnitTest[String val](_PropertyInvalidPortRejected))
    test(Property1UnitTest[String val](_PropertyInvalidHostRejected))
    test(_TestParseURIAuthorityKnownGood)

    // Path segment tests
    test(Property1UnitTest[String val](_PropertyPathSegmentCount))
    test(Property1UnitTest[String val](_PropertyPathSegmentRoundtrip))
    test(Property1UnitTest[String val](_PropertyPathSegmentInvalidRejected))
    test(_TestPathSegmentsKnownGood)

    // Query parameter tests
    test(Property1UnitTest[Array[(String val, String val)] val](
      _PropertyQueryParamsRoundtrip))
    test(Property1UnitTest[String val](_PropertyQueryParamsPlusDecodes))
    test(Property1UnitTest[String val](_PropertyQueryParamsInvalidRejected))
    test(_TestQueryParametersKnownGood)
    test(_TestURIQueryParams)
    test(_TestQueryParamsGet)
    test(_TestQueryParamsGetAll)
    test(_TestQueryParamsContains)
    test(_TestQueryParamsSize)

    // RemoveDotSegments tests
    test(Property1UnitTest[String val](_PropertyDotSegmentsIdempotent))
    test(Property1UnitTest[String val](_PropertyDotSegmentsNoDots))
    test(Property1UnitTest[String val](
      _PropertyDotSegmentsPreservesAbsolute))
    test(_TestRemoveDotSegmentsKnownGood)

    // ResolveURI tests
    test(Property1UnitTest[_ResolveInput](
      _PropertyResolveResultAbsolute))
    test(Property1UnitTest[_AbsoluteURIInput](
      _PropertyResolveEmptyRef))
    test(Property1UnitTest[(_AbsoluteURIInput, _AbsoluteURIInput)](
      _PropertyAbsoluteRefIgnoresBase))
    test(Property1UnitTest[_ValidURIInput](
      _PropertyNonAbsoluteBaseRejected))
    test(Property1UnitTest[_ResolveInput](_PropertyResolveRoundtrip))
    test(_TestResolveURIRFCNormal)
    test(_TestResolveURIRFCAbnormal)
    test(_TestResolveURIEdgeCases)
