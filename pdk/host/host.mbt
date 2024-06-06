/// `input` returns a sequence of (unprocessed) bytes from the host.
pub fn input() -> Bytes {
  let length = @extism.input_length().to_int()
  let value = Bytes::make(length)
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
  let { offset, length } = output_bytes_to_memory(b)
  @extism.output_set(offset, length)
}

/// output_string converts a MoonBit String (UTF-16) to an Extism string (UTF-8)
/// and sends it to the host.
pub fn output_string(s : String) -> Unit {
  @pdk.ToUtf8::to_utf8(s) |> output()
}

/// output_json_value converts a MoonBit @json.JsonValue to an Extism JSON string
/// and sends it to the host.
pub fn output_json_value(j : @json.JsonValue) -> Unit {
  @jsonutil.stringify(j, spaces=0, newline=false) |> output_string()
}

/// log_warn_str is a helper function to log a warn string to the host.
pub fn log_warn_str(s : String) -> Unit {
  let { offset, .. } = @pdk.ToUtf8::to_utf8(s) |> output_bytes_to_memory()
  @extism.log_warn(offset)
  @extism.free(offset)
}

/// log_info_str is a helper function to log a info string to the host.
pub fn log_info_str(s : String) -> Unit {
  let { offset, .. } = @pdk.ToUtf8::to_utf8(s) |> output_bytes_to_memory()
  @extism.log_info(offset)
  @extism.free(offset)
}

/// log_debug_str is a helper function to log a debug string to the host.
pub fn log_debug_str(s : String) -> Unit {
  let { offset, .. } = @pdk.ToUtf8::to_utf8(s) |> output_bytes_to_memory()
  @extism.log_debug(offset)
  @extism.free(offset)
}

/// log_error_str is a helper function to log a error string to the host.
pub fn log_error_str(s : String) -> Unit {
  let { offset, .. } = @pdk.ToUtf8::to_utf8(s) |> output_bytes_to_memory()
  @extism.log_error(offset)
  @extism.free(offset)
}
