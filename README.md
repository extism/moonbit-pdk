# gmlewis/moonbit-pdk

This is an experimental [Extism PDK] for the [MoonBit] programming language.

[Extism PDK]: https://extism.org/docs/concepts/pdk
[MoonBit]: https://www.moonbitlang.com/

## Build

Before building, you must have already installed the MoonBit programming language
and the [Extism CLI tool].

To install MoonBit, follow the instructions here (it is super-easy with VSCode):
https://www.moonbitlang.com/download/

Additionally, there is currently an [issue with MoonBit] that needs a workaround,
so the tool [`wat2wasm`] also needs to be available in your `$PATH`.

Then, to build this PDK, clone the repo, and type:

```bash
$ moon update
$ moon install
$ ./build.sh
```

[Extism CLI tool]: https://extism.org/docs/install/
[issue with MoonBit]: https://github.com/moonbitlang/core/issues/480
[wasm-merge]: https://github.com/WebAssembly/binaryen?tab=readme-ov-file#wasm-merge
[wat2wasm]: https://github.com/WebAssembly/wabt?tab=readme-ov-file#running-wat2wasm

## Run

To run the examples, type:

```bash
$ ./run.sh
```

## Status

This PDK is just in its infancy.

These plugins work (with the caveat that full UTF-8 input is not yet supported,
only ASCII input currently works for strings):

* [greet](examples/greet/)

  e.g. `./scripts/greet.sh 'My Name'`

These examples don't yet work:

* [count-vowels](examples/count-vowels/)

Here's the current situation with `count-vowels`:

* the unit test _WORKS_ (`moon test`)
* simulating the Extism SDK in the browser _WORKS_ (`./scripts/python-server.sh` then open `examples/count-vowels/index.html` in Chrome)
* running `count-vowels` with the Extism Go SDK _FAILS_: `./scripts/go-run-count-vowels.sh`
* running `count-vowels` with the Extism CLI _FAILS_: `./run.sh`

So apparently I'm not understanding something about Extism that I need to know.

This section of code is somehow causing an out-of-bounds memory access:
https://github.com/gmlewis/moonbit-pdk/blob/8682675a16ac3c461237a5a4665a580befca5f20/examples/count-vowels/count-vowels.mbt#L28-L37

This demonstrates the current failure with the error message:

```bash
$ ./build.sh && ./scripts/go-run-count-vowels.sh
...
2024/06/02 20:29:22 No runtime detected
2024/06/02 20:29:22 Calling function : count_vowels
2024/06/02 20:29:22 ENTER count_vowels
2024/06/02 20:29:22 ToUtf16::to_utf16: b.length=13
2024/06/02 20:29:22 count_vowels: input=Hello, World!
2024/06/02 20:29:22 Config::get_memory(key=vowels)
2024/06/02 20:29:22 ENTER Memory::allocate_bytes: length=6
2024/06/02 20:29:22 LEAVE Memory::allocate_bytes: offset=311, length=6
2024/06/02 20:29:22 Config::get_memory: config_get(311)=0
2024/06/02 20:29:22 Config::get_memory(key=vowels) is uninitialized.
2024/06/02 20:29:22 Config::get(key=vowels) is uninitialized.
2024/06/02 20:29:22 exit code=1: wasm error: out of bounds memory access
wasm stack trace:
	.$49(i32,i32) i32
	.$172() i32
	.$173() i32
plugin.Call output:
exit status 1
```

This is the latest version that demonstrates the above problem:
https://modsurfer.dylibso.com/module?hash=3e1b2f2808b048e89cc2d362bda2ced32d53591a3c25dc128c37c5352dc3dcf8
