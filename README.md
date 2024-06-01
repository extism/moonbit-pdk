# gmlewis/moonbit-pdk

This is an experimental [Extism PDK] for the [MoonBit] programming language.

[Extism PDK]: https://extism.org/docs/concepts/pdk
[MoonBit]: https://www.moonbitlang.com/

## Build

Before building, you must have already installed the MoonBit programming language.
To install MoonBit, follow the instructions here (it is super-easy with VSCode):
https://www.moonbitlang.com/download/

Then, to build this PDK, clone the repo, and type:

```bash
$ ./build.sh
```

## Run

To run the examples, type:

```bash
$ ./run.sh
```

## Examples

* [count-vowels](examples/count-vowels/)
* [greet](examples/greet/)

## Status

This PDK is just in its infancy and nothing is working yet.

Currently, the PDK is broken and gives this error:

```
Error: module[spectest] not instantiated
```
