# gmlewis/moonbit-pdk

This is an experimental [Extism PDK] for the [MoonBit] programming language.

[Extism PDK]: https://extism.org/docs/concepts/pdk
[MoonBit]: https://www.moonbitlang.com/

## Build

Before building, you must have already installed the MoonBit programming language.
To install MoonBit, follow the instructions here (it is super-easy with VSCode):
https://www.moonbitlang.com/download/

Additionally, there is currently an [issue with MoonBit] that needs a workaround,
so the tool [`wat2wasm`] also needs to be available in your `$PATH`.

Then, to build this PDK, clone the repo, and type:

```bash
$ ./build.sh
```

[issue with MoonBit]: https://github.com/moonbitlang/core/issues/480
[wasm-merge]: https://github.com/WebAssembly/binaryen?tab=readme-ov-file#wasm-merge
[wat2wasm]: https://github.com/WebAssembly/wabt?tab=readme-ov-file#running-wat2wasm

## Run

To run the examples, type:

```bash
$ ./run.sh Benjamin
```

## Status

This PDK is just in its infancy.

These plugins work (with the caveat that full UTF-8 input is not yet supported,
only ASCII input currently works for strings):

* [greet](examples/greet/)

These examples don't yet work:

* [count-vowels](examples/count-vowels/)
