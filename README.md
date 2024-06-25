# extism/moonbit-pdk

This is an experimental [Extism PDK] for the [MoonBit] programming language.

[Extism PDK]: https://extism.org/docs/concepts/pdk
[MoonBit]: https://www.moonbitlang.com/

## Build

Before building, you must have already installed the MoonBit programming language,
the [Go] programming language, and the [Extism CLI tool].

To install MoonBit, follow the instructions here (it is super-easy with VSCode):
https://www.moonbitlang.com/download/

Then, to build this PDK, clone the repo, and type:

```bash
$ moon update
$ moon install
$ ./build.sh
```

[Extism CLI tool]: https://extism.org/docs/install/
[Go]: https://go.dev/

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
moon 0.1.20240624 (e25afbc 2024-06-24)
```

These plugins work (with the caveat that full UTF-8 input is not yet supported,
only ASCII input currently works for strings):

* [greet](examples/greet/)

  e.g. `./scripts/greet.sh 'My Name'`

* [count-vowels](examples/count-vowels/)

  e.g. `./scripts/count-vowels.sh 'Once upon a dream'

* [http-get](examples/http-get/)

  e.g. `./scripts/http-get.sh`
