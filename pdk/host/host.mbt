/// `input` returns a sequence of (unprocessed) bytes from the host.
pub fn input() -> Bytes {
  let length = @extism.input_length().to_int()
  let value = Bytes::new(length)
  for i = 0; i < length; i = i + 1 {
    value[i] = @extism.input_load_u8(i.to_int64())
  }
  value
}

/// `input_string` returns a (UTF-16) String from the host.
pub fn input_string() -> String {
  input() |> @pdk.ToUtf16::to_utf16()
}

// `output_bytes_to_memory` writes the (unprocessed) bytes to a Memory buffer on the host.
fn output_bytes_to_memory(b : Bytes) -> Memory {
  let length = b.length().to_int64()
  let offset = @extism.alloc(length)
  for i = 0; i < length.to_int(); i = i + 1 {
    @extism.store_u8(offset + i.to_int64(), b[i])
  }
  { offset, length }
}

/// `output` sends a sequence of (unprocessed) bytes to the host as the plugin's "output".
pub fn output(b : Bytes) -> Unit {
  let mem = output_bytes_to_memory(b)
  @extism.output_set(mem.offset, mem.length)
  // 2024-07-11: There is currently an issue with the JS SDK where if memory is
  // freed in the next line, the host receives a null from the `await plugin.call` function.
  // mem.free()
}

/// `output_string` converts a MoonBit String (UTF-16) to an Extism string (UTF-8)
/// and sends it to the host.
pub fn output_string(s : String) -> Unit {
  @pdk.ToUtf8::to_utf8(s) |> output()
}

/// `output_json_value` converts a MoonBit @json.JsonValue to an Extism JSON string
/// and sends it to the host.
pub fn output_json_value(j : @json.JsonValue) -> Unit {
  j.stringify() |> output_string()
}

fn set_error_bytes(b : Bytes) -> Unit {
  let mem = output_bytes_to_memory(b)
  @extism.error_set(mem.offset)
  // If the following line is uncommented, the Extism CLI fails with this example:
  // $ extism call target/wasm/release/build/main/main.wasm greet --input "Benjamin" --wasi
  // Error: Encountered an unknown error in call to Extism plugin function greet
  // However, with the line commented out, the Extism CLI responds correctly:
  // $ extism call target/wasm/release/build/main/main.wasm greet --input "Benjamin" --wasi
  // Error: Sorry, we don't greet Benjamins!
  // mem.free()
}

/// `set_error` converts a MoonBit String (UTF-16) to an Extism string (UTF-8)
/// and sends it to the host as its error output.
pub fn set_error(s : String) -> Unit {
  @pdk.ToUtf8::to_utf8(s) |> set_error_bytes()
}

/// `log_warn_str` is a helper function to log a warn string to the host.
pub fn log_warn_str(s : String) -> Unit {
  let { offset, .. } = @pdk.ToUtf8::to_utf8(s) |> output_bytes_to_memory()
  @extism.log_warn(offset)
  @extism.free(offset)
}

/// `log_info_str` is a helper function to log an info string to the host.
pub fn log_info_str(s : String) -> Unit {
  let { offset, .. } = @pdk.ToUtf8::to_utf8(s) |> output_bytes_to_memory()
  @extism.log_info(offset)
  @extism.free(offset)
}

/// `log_debug_str` is a helper function to log a debug string to the host.
pub fn log_debug_str(s : String) -> Unit {
  let { offset, .. } = @pdk.ToUtf8::to_utf8(s) |> output_bytes_to_memory()
  @extism.log_debug(offset)
  @extism.free(offset)
}

/// `log_error_str` is a helper function to log an error string to the host.
pub fn log_error_str(s : String) -> Unit {
  let { offset, .. } = @pdk.ToUtf8::to_utf8(s) |> output_bytes_to_memory()
  @extism.log_error(offset)
  @extism.free(offset)
}
