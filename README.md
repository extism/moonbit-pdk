# extism/moonbit-pdk
[![check](https://github.com/extism/moonbit-pdk/actions/workflows/check.yml/badge.svg)](https://github.com/extism/moonbit-pdk/actions/workflows/check.yml)

This is an [Extism PDK] that can be used to write [Extism Plug-ins] using the [MoonBit] programming language.

[Extism PDK]: https://extism.org/docs/concepts/pdk
[Extism Plug-ins]: https://extism.org/docs/concepts/plug-in
[MoonBit]: https://www.moonbitlang.com/

## Install

Add the library to your projext as a dependency with the `moon` tool:

```bash
moon add extism/moonbit-pdk
```

## Reference Documentation

You can find the reference documentation for this library on [mooncakes.io]:

* [extism/moonbit-pdk overview and status]
* [extism/moonbit-pdk/pdk/config]
* [extism/moonbit-pdk/pdk/host]
* [extism/moonbit-pdk/pdk/http]
* [extism/moonbit-pdk/pdk/var]

[mooncakes.io]: https://mooncakes.io
[extism/moonbit-pdk overview and status]: https://mooncakes.io/docs/#/extism/moonbit-pdk/
[extism/moonbit-pdk/pdk/config]: https://mooncakes.io/docs/#/extism/moonbit-pdk/pdk/config/members
[extism/moonbit-pdk/pdk/host]: https://mooncakes.io/docs/#/extism/moonbit-pdk/pdk/host/members
[extism/moonbit-pdk/pdk/http]: https://mooncakes.io/docs/#/extism/moonbit-pdk/pdk/http/members
[extism/moonbit-pdk/pdk/var]: https://mooncakes.io/docs/#/extism/moonbit-pdk/pdk/var/members

Examples can also be found there:

* [extism/moonbit-pdk/examples/count-vowels]
* [extism/moonbit-pdk/examples/greet]
* [extism/moonbit-pdk/examples/http-get]
* [extism/moonbit-pdk/examples/kitchen-sink]

[extism/moonbit-pdk/examples/count-vowels]: https://mooncakes.io/docs/#/extism/moonbit-pdk/examples/count-vowels/members
[extism/moonbit-pdk/examples/greet]: https://mooncakes.io/docs/#/extism/moonbit-pdk/examples/greet/members
[extism/moonbit-pdk/examples/http-get]: https://mooncakes.io/docs/#/extism/moonbit-pdk/examples/http-get/members
[extism/moonbit-pdk/examples/kitchen-sink]: https://mooncakes.io/docs/#/extism/moonbit-pdk/examples/kitchen-sink/members

## Getting Started

The goal of writing an [Extism plug-in](https://extism.org/docs/concepts/plug-in)
is to compile your MoonBit code to a Wasm module with exported functions that the
host application can invoke.
The first thing you should understand is creating an export.
Let's write a simple program that exports a `greet` function which will take
a name as a string and return a greeting string.

First, install the `moon` CLI tool:

See https://www.moonbitlang.com/download/ for instructions for your platform.

Create a new MoonBit project directory using the `moon` tool and initialize
the project:

```bash
moon new greet
cd greet
```

Next, add this Extism PDK to the project and remove the default "lib" example:

```bash
moon add extism/moonbit-pdk
rm -rf lib
```

Now paste this into your `main/main.mbt` file:

```rust
pub fn greet() -> Int {
  let input = @host.input_string()
  let greeting = "Hello, \(input)!"
  @host.output_string(greeting)
  0 // success
}

fn main {

}
```

Then paste this into your `main/moon.pkg.json` file to export the `greet` function
and include the `@host` import into your plugin:

```json
{
  "is-main": true,
  "import": [
    "extism/moonbit-pdk/pdk/host"
  ],
  "link": {
    "wasm": {
      "exports": [
        "greet"
      ],
      "export-memory-name": "memory"
    }
  }
}
```

Some things to note about this code:

1. The `moon.pkg.json` file is required. This marks the greet function as an export with the name `greet` that can be called by the host.
2. We need a `main` but it is unused.
3. Exports in the MoonBit PDK are coded to the raw ABI. You get parameters from the host by calling [`@host.input*` functions](https://mooncakes.io/docs/#/extism/moonbit-pdk/pdk/host/members?id=input) and you send return values back with the [`@host.output*` functions](https://mooncakes.io/docs/#/extism/moonbit-pdk/pdk/host/members?id=output).
4. An Extism export expects an i32 (a MoonBit `Int`) return code. `0` is success and `1` (or any other value) is a failure.

Finally, compile this with the command:

```bash
moon build --target wasm
```

We can now test `plugin.wasm` using the [Extism CLI](https://github.com/extism/cli)'s `run`
command:

```bash
extism call target/wasm/release/build/main/main.wasm greet --input "Benjamin" --wasi
# => Hello, Benjamin!
```

> **Note**: We also have a web-based, plug-in tester called the [Extism Playground](https://playground.extism.org/)

## For PDK Devs: Building the PDK locally

Before building, you must have already installed the MoonBit programming language,
the [Go] programming language, and the [Extism CLI tool].

To install MoonBit, follow the instructions here (it is super-easy with VSCode):
https://www.moonbitlang.com/download/

Then, to build this PDK, clone the repo, and type:

```bash
moon update && moon install
./build.sh
```

[Extism CLI tool]: https://extism.org/docs/install/
[Go]: https://go.dev/

### Run

To run the examples, type:

```bash
./run.sh
```

## Status

The code has been updated to support compiler `moon version`:

```bash
moon 0.1.20240708 (4e51712 2024-07-08)
```

## Reach Out!

Have a question or just want to drop in and say hi? [Hop on the Discord](https://extism.org/discord)!
