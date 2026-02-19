## Add URI normalization and equivalence per RFC 3986 section 6

Normalize URIs using syntax-based (section 6.2.2) and scheme-based (section 6.2.3) rules: lowercase scheme and host, normalize percent-encoding, remove dot segments, strip default ports (http→80, https→443, ftp→21), and set empty paths to `/` for http/https with authority.

```pony
match ParseURI("HTTP://Example.COM:80/%7Euser/a/../b?q=%6A")
| let u: URI val =>
  match NormalizeURI(u)
  | let n: URI val =>
    // n.string() == "http://example.com/~user/b?q=j"
  end
end
```

Test equivalence of two URIs under normalization:

```pony
match (ParseURI("HTTP://Example.COM:80/path"), ParseURI("http://example.com/path"))
| (let a: URI val, let b: URI val) =>
  match URIEquivalent(a, b)
  | let eq: Bool =>
    // eq == true
  end
end
```

New API:

- `NormalizeURI` — applies syntax-based and scheme-based normalization
- `URIEquivalent` — normalizes two URIs and compares them
