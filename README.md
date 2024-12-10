# extism/moonbit-pdk
[![check](https://github.com/extism/moonbit-pdk/actions/workflows/check.yml/badge.svg)](https://github.com/extism/moonbit-pdk/actions/workflows/check.yml)

This is an [Extism PDK] that can be used to write [Extism Plug-ins] using the [MoonBit] programming language.

[Extism PDK]: https://extism.org/docs/concepts/pdk
[Extism Plug-ins]: https://extism.org/docs/concepts/plug-in
[MoonBit]: https://www.moonbitlang.com/

## Install

Add the library to your project as a dependency with the `moon` tool:

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

* [extism/moonbit-pdk/examples/add]
* [extism/moonbit-pdk/examples/arrays]
* [extism/moonbit-pdk/examples/count-vowels]
* [extism/moonbit-pdk/examples/greet]
* [extism/moonbit-pdk/examples/http-get]
* [extism/moonbit-pdk/examples/kitchen-sink]

[extism/moonbit-pdk/examples/add]: https://mooncakes.io/docs/#/extism/moonbit-pdk/examples/add/members
[extism/moonbit-pdk/examples/arrays]: https://mooncakes.io/docs/#/extism/moonbit-pdk/examples/arrays/members
[extism/moonbit-pdk/examples/count-vowels]: https://mooncakes.io/docs/#/extism/moonbit-pdk/examples/count-vowels/members
[extism/moonbit-pdk/examples/greet]: https://mooncakes.io/docs/#/extism/moonbit-pdk/examples/greet/members
[extism/moonbit-pdk/examples/http-get]: https://mooncakes.io/docs/#/extism/moonbit-pdk/examples/http-get/members
[extism/moonbit-pdk/examples/kitchen-sink]: https://mooncakes.io/docs/#/extism/moonbit-pdk/examples/kitchen-sink/members

## Getting Started

The goal of writing an [Extism plug-in](https://extism.org/docs/concepts/plug-in)
is to compile your MoonBit code to a Wasm module with exported functions that the
host application can invoke. The first thing you should understand is creating an export.
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
  let name = @host.input_string()
  let greeting = "Hello, \{name}!"
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

### More Exports: Error Handling

Suppose we want to re-write our greeting module to never greet Benjamins.
We can use [`@host.set_error`](https://mooncakes.io/docs/#/extism/moonbit-pdk/pdk/host/members?id=set_error):

```rust
pub fn greet() -> Int {
  let name = @host.input_string()
  if name == "Benjamin" {
    @host.set_error("Sorry, we don't greet Benjamins!")
    return 1 // failure
  }
  let greeting = "Hello, \{name}!"
  @host.output_string(greeting)
  0 // success
}
```

Now when we try again:

```bash
moon build --target wasm
extism call target/wasm/release/build/main/main.wasm greet --input "Benjamin" --wasi
# => Error: Sorry, we don't greet Benjamins!
echo $? # print last status code
# => 1
extism call target/wasm/release/build/main/main.wasm greet --input "Zach" --wasi
# => Hello, Zach!
echo $?
# => 0
```

### JSON

Extism export functions simply take bytes in and bytes out. Those can be whatever you want them to be.
A common way to get more complex types to and from the host is with JSON:
(MoonBit currently requires a bit of boilerplate to handle JSON I/O but
hopefully this situation will improve as the standard library is fleshed out.)

```rust
struct Add {
  a : Int
  b : Int
}

pub fn Add::from_json(value : Json) -> Add? {
  // From: https://github.com/moonbitlang/core/issues/892#issuecomment-2306068783
  match value {
    { "a": Number(a), "b": Number(b) } => Some({ a: a.to_int(), b: b.to_int() })
    _ => None
  }
}

type! ParseError String derive(Show)

pub fn Add::parse(s : String) -> Add!ParseError {
  match @json.parse?(s) {
    Ok(jv) =>
      match Add::from_json(jv) {
        Some(value) => value
        None => raise ParseError("unable to parse Add \{s}")
      }
    Err(e) => raise ParseError("unable to parse Add \{s}: \{e}")
  }
}

struct Sum {
  sum : Int
} derive(ToJson)

pub fn add() -> Int {
  let input = @host.input_string()
  let params = try {
    Add::parse!(input)
  } catch {
    ParseError(e) => {
      @host.set_error(e)
      return 1
    }
  }
  //
  let sum = { sum: params.a + params.b }
  let json_value = sum.to_json()
  @host.output_json_value(json_value)
  0 // success
}
```


Export your `add` function in `main/moon.pkg.json`:

```json
{
  "import": [
    "extism/moonbit-pdk/pdk/host"
  ],
  "link": {
    "wasm": {
      "exports": [
        "add"
      ],
      "export-memory-name": "memory"
    }
  }
}
```

Then compile and run:

```bash
moon build --target wasm
extism call plugin.wasm add --input='{"a": 20, "b": 21}' --wasi
# => {"sum":41}
```

## Configs

Configs are key-value pairs that can be passed in by the host when creating a plug-in.
These can be useful to statically configure the plug-in with some data that exists
across every function call.

Here is a trivial example using [`config.get`](https://mooncakes.io/docs/#/extism/moonbit-pdk/pdk/config/members?id=get):

```rust
pub fn greet() -> Int {
  let user = match @config.get("user") {
    Some(user) => user
    None => {
      @host.set_error("This plug-in requires a 'user' key in the config")
      return 1 // failure
    }
  }
  let greeting = "Hello, \{user}!"
  @host.output_string(greeting)
  0 // success
}
```

Remember to import the `config` and `host` packages in `main/moon.pkg.json` and
export your function:

```json
{
  "import": [
    "extism/moonbit-pdk/pdk/config",
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

To test it, the [Extism CLI](https://github.com/extism/cli) has a `--config` option that lets you pass in `key=value` pairs:

```bash
moon build --target wasm
extism call target/wasm/release/build/main/main.wasm greet --config user=Benjamin
# => Hello, Benjamin!
extism call target/wasm/release/build/main/main.wasm greet
# => Error: This plug-in requires a 'user' key in the config
```

## Variables

Variables are another key-value mechanism but are a mutable data store that
will persist across function calls. These variables will persist as long as the
host has loaded and not freed the plug-in.

```rust
pub fn count() -> Int {
  let mut count = match @var.get_int("count") {
    Some(v) => v
    None => 0
  }
  count = count + 1
  @var.set_int("count", count)
  let s = count.to_string()
  @host.output_string(s)
  0 // success
}
```

> **Note**: Use the untyped variant [`@var.set_bytes`](https://mooncakes.io/docs/#/extism/moonbit-pdk/pdk/var/members?id=set_bytes)
> to handle your own types.

Remember to import the `host` and `var` packages in `main/moon.pkg.json` and
export your function:

```json
{
  "import": [
    "extism/moonbit-pdk/pdk/host",
    "extism/moonbit-pdk/pdk/var"
  ],
  "link": {
    "wasm": {
      "exports": [
        "count"
      ],
      "export-memory-name": "memory"
    }
  }
}
```

## Logging

Because Wasm modules by default do not have access to the system, printing to
stdout won't work (unless you use WASI). Extism provides simple
[logging functions](https://mooncakes.io/docs/#/extism/moonbit-pdk/pdk/host/members?id=log_debug_str)
that allow you to use the host application to log without having to give the
plug-in permission to make syscalls.

```rust
pub fn log_stuff() -> Int {
  @host.log_info_str("An info log!")
  @host.log_debug_str("A debug log!")
  @host.log_warn_str("A warn log!")
  @host.log_error_str("An error log!")
  0 // success
}
```

From [Extism CLI](https://github.com/extism/cli):

```bash
moon build --target wasm
extism call target/wasm/release/build/main/main.wasm log_stuff --wasi --log-level=trace
# => 2024/07/09 11:37:30 No runtime detected
# => 2024/07/09 11:37:30 Calling function : log_stuff
# => 2024/07/09 11:37:30 An info log!
# => 2024/07/09 11:37:30 A debug log!
# => 2024/07/09 11:37:30 A warn log!
# => 2024/07/09 11:37:30 An error log!
```

> *Note*: From the CLI you need to pass a level with `--log-level`.
> If you are running the plug-in in your own host using one of our SDKs, you need
> to make sure that you call `set_log_file` to `"stdout"` or some file location.

## HTTP

Sometimes it is useful to let a plug-in [make HTTP calls](https://mooncakes.io/docs/#/extism/moonbit-pdk/pdk/http/members?id=send).
[See this example](examples/http-get/http-get.mbt).

```rust
pub fn http_get() -> Int {
  // create an HTTP Request (without relying on WASI), set headers as needed
  let req = @http.new_request(
    @http.Method::GET,
    "https://jsonplaceholder.typicode.com/todos/1",
  )
  req.header.set("some-name", "some-value")
  req.header.set("another", "again")
  // send the request, get response back
  let res = req.send()

  // zero-copy send output to host
  res.output()
  0 // success
}
```

By default, Extism modules cannot make HTTP requests unless you specify which
hosts it can connect to. You can use `--alow-host` in the Extism CLI to set this:

```bash
extism call \
    target/wasm/release/build/examples/http-get/http-get.wasm \
    http_get \
    --wasi \
    --allow-host='*.typicode.com'
# => {
# =>   "userId": 1,
# =>   "id": 1,
# =>   "title": "delectus aut autem",
# =>   "completed": false
# => }
```

## Imports (Host Functions)

Like any other code module, Wasm not only lets you export functions to the outside world, you can
import them too. Host Functions allow a plug-in to import functions defined in the host. For example,
if your host application is written in Python, it can pass a Python function down to your MoonBit plug-in
where you can invoke it.

This topic can get fairly complicated and we have not yet fully abstracted the Wasm knowledge you need
to do this correctly. So we recommend reading our [concept doc on Host Functions](https://extism.org/docs/concepts/host-functions)
before you get started.

### A Simple Example

Host functions have a similar interface as exports. You just need to declare them
as external in your `main.mbt`. You only declare the interface as it is the host's
responsibility to provide the implementation:

```rust
pub fn a_python_func(offset : Int64) -> Int64 = "extism:host/user" "a_python_func"
```

We should be able to call this function as a normal Go function. Note that we need to manually handle the pointer casting:

```rust
pub fn hello_from_python() -> Int {
  let msg = "An argument to send to Python"
  let mem = @host.allocate_string(msg)
  let ptr = a_python_func(mem.offset)
  mem.free()
  let rmem = @host.find_memory(ptr)
  let response = rmem.to_string()
  @host.output_string(response)
  return 0
}
```

### Testing it out

We can't really test this from the Extism CLI as something must provide the implementation. So let's
write out the Python side here. Check out the [docs for Host SDKs](https://extism.org/docs/concepts/host-sdk)
to implement a host function in a language of your choice.

```python
from extism import host_fn, Plugin

@host_fn()
def a_python_func(input: str) -> str:
    # just printing this out to prove we're in Python land
    print("Hello from Python!")

    # let's just add "!" to the input string
    # but you could imagine here we could add some
    # applicaiton code like query or manipulate the database
    # or our application APIs
    return input + "!"
```

Now when we load the plug-in we pass the host function:

```python
manifest = {"wasm": [{"path": "target/wasm/release/build/main/main.wasm"}]}
plugin = Plugin(manifest, functions=[a_python_func], wasi=True)
result = plugin.call('hello_from_python', b'').decode('utf-8')
print(result)
```

```bash
moon build --target wasm
python3 -m pip install extism
python3 app.py
# => Hello from Python!
# => An argument to send to Python!
```

> **Note**: This fails on my Mac M2 Max with some weird system error
> but works great on my Linux Mint Cinnamon box.

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

The code has been updated to support compiler:

```bash
$ moon version --all
moon 0.1.20241209 (2848796 2024-12-09) ~/.moon/bin/moon
moonc v0.1.20241210+3258bad5b ~/.moon/bin/moonc
moonrun 0.1.20241209 (2848796 2024-12-09) ~/.moon/bin/moonrun
```

Use `moonup` to manage `moon` compiler versions:
https://github.com/chawyehsu/moonup

## Reach Out!

Have a question or just want to drop in and say hi? [Hop on the Discord](https://extism.org/discord)!
