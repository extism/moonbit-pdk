# gmlewis/moonbit-pdk

This is an experimental [Extism PDK] for the [MoonBit] programming language.

[Extism PDK]: https://extism.org/docs/concepts/pdk
[MoonBit]: https://www.moonbitlang.com/

## Build

Before building, you must have already installed the MoonBit programming language
and the [Extism CLI tool].

To install MoonBit, follow the instructions here (it is super-easy with VSCode):
https://www.moonbitlang.com/download/

Then, to build this PDK, clone the repo, and type:

```bash
$ moon update
$ moon install
$ ./build.sh
```

[Extism CLI tool]: https://extism.org/docs/install/

## Run

To run the examples, type:

```bash
$ ./run.sh
```

## Status

This PDK is just in its infancy.

The code has been updated to support compiler version:

```bash
$ moon version
moon 0.1.20240603 (c0289e3 2024-06-03)
```

These plugins work (with the caveat that full UTF-8 input is not yet supported,
only ASCII input currently works for strings):

* [greet](examples/greet/)

  e.g. `./scripts/greet.sh 'My Name'`

These examples partially work:

* [count-vowels](examples/count-vowels/)

Here's the current situation with `count-vowels`:

* the unit test _WORKS_ (`moon test`)
* simulating the Extism SDK in the browser _WORKS_ (`./scripts/python-server.sh` then open `examples/count-vowels/index.html` in Chrome)
* running `count-vowels` with the Extism Go SDK _FAILS_: `./scripts/go-run-count-vowels.sh`
* running `count-vowels` with the Extism CLI _FAILS_: `./run.sh`

This demonstrates the current problem:

```bash
$ ./build.sh && ./scripts/go-run-count-vowels.sh
...
{"count":null,"total":null,"vowels":null}
```
