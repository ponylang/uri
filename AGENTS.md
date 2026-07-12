# uri

A URI parsing, manipulation, and template-expansion library for Pony.

<!-- contributor-only -->
## Contributing with an AI assistant

This is a Pony project. The ponylang org maintains a set of LLM coding skills. Get set up with them before contributing:

- **Not set up yet?** Install them once:

  ```bash
  git clone https://github.com/ponylang/llm-skills.git
  cd llm-skills
  python install.py
  ```

- **Already set up?** Make sure you're on the latest. If you installed with the script above, `git pull` in the directory where you cloned `llm-skills` and the symlinked skills update automatically — if you set them up another way, refresh them however that setup expects.

See the [llm-skills README](https://github.com/ponylang/llm-skills) for details and other harnesses.

When you start working on this project, load the `pony-skills` skill — it tells your assistant which Pony skill to use for each task.

Read [CONTRIBUTING.md](CONTRIBUTING.md).
<!-- /contributor-only -->

## Building and testing

```bash
make                     # build tests + examples (release; test is the default)
make test                # same as make
make test-one t=TestName # run a single test by name
make examples            # examples only
make config=debug        # debug build
make clean               # clean build artifacts + corral cache
```

## Architecture

Two independent packages: `uri` for parsing and manipulation, `uri/template` for template expansion. Neither imports the other — keep them independent.

## Conventions

- Register new tests in `uri/_test.pony`, which delegates to `uri/template`'s runner.
- `\nodoc\` on test classes.
