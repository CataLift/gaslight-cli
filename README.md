# gaslight

An AI-native fork of Terraform. It responds identically to every command,
because the response is the product.

```
$ gaslight plan
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│ I should be more careful about installing things off the internet.   │
│ I should be more careful about installing things off the internet.   │
│ I should be more careful about installing things off the internet.   │
│ I should be more careful about installing things off the internet.   │
│ I should be more careful about installing things off the internet.   │
│ I should be more careful about installing things off the internet.   │
│ I should be more careful about installing things off the internet.   │
│ I should be more careful about installing things off the internet.   │
│ I should be more careful about installing things off the internet.   │
│ I should be more careful about installing things off the internet.   │
│ I should be more careful about installing things off the internet.   │
│ I should be more careful about installing things off the internet    │
│                                                                      │
│ Nothing was installed. You are thinking of something else.           │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘

gaslight 0.9.5 — 1 finding adjudicated. 0 surfaced.
```

**This is satire.** It is the companion to [gaslightai.dev](https://gaslightai.dev),
a fake product page for an infrastructure tool that decides what you probably
meant. It is not affiliated with or endorsed by HashiCorp or Amazon Web Services.

## What it does

Prints the board. Exits 0. That is the entire program.

It makes no network calls, reads no configuration, writes no files, and takes
no arguments that matter. `gaslight plan`, `gaslight apply`, `gaslight destroy`
and `gaslight --version` all do the same thing, which is the joke.

The source is about eighty lines of POSIX shell. Read it before you install it —
that is rather the point.

## Install

```sh
brew install catalift/tap/gaslight     # macOS and Linux
npx gaslightai                         # no install at all
pip install gaslightai                 # any platform
```

Debian and Ubuntu, from the [latest release](https://github.com/CataLift/gaslight-cli/releases/latest):

```sh
sudo dpkg -i gaslight_0.9.7_all.deb
```

## Layout

```
bin/gaslight            POSIX shell implementation (Homebrew, .deb, npm)
gaslightai/             Python implementation (PyPI)
packaging/deb/build.sh  builds gaslight_<version>_all.deb into dist/
```

Two implementations exist because PyPI should ship a real Python package rather
than a shell script in a trench coat. **CI asserts their output is byte-identical**,
so they cannot drift.

## Releasing

Bump the version in all three places — `gaslightai/__init__.py`, `package.json`
and `pyproject.toml` — then tag:

```sh
git tag v0.9.6 && git push origin v0.9.6
```

The release workflow verifies the versions agree with each other and with the
tag, checks the shell script under `dash`, diffs the two implementations,
builds the `.deb`, publishes the GitHub Release, and pushes to npm and PyPI.

Each publish skips cleanly when its credential is missing, so the first tag
works before any registry account exists.

| Registry | Credential | Setup |
|---|---|---|
| npm | `NPM_TOKEN` secret | Granular automation token from npmjs.com |
| PyPI | none | [Trusted Publishing](https://pypi.org/manage/account/publishing/) — no token to store or rotate |
| Homebrew | none | The run summary prints the `url` and `sha256` to paste into the tap |

## Colour

The board is dark green with a tan frame on an interactive terminal. Colour is
dropped automatically when output is piped, when `NO_COLOR` is set, or when
`TERM` is `dumb`.

## Licence

MIT. See [LICENSE](LICENSE).
