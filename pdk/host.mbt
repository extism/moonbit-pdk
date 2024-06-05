/// `Host` provides methods used to communicate with the Extism SDK host.
pub struct Host {}

/// `Host::input` returns a sequence of (unprocessed) bytes from the host.
pub fn Host::input() -> Bytes {
  let length = extism_input_length().to_int()
  let value = Bytes::make(length)
  for i = 0; i < length; i = i + 1 {
    value[i] = extism_input_load_u8(i.to_int64())
  }
  value
}

/// `Host::input_string` returns a (UTF-16) String from the host.
pub fn Host::input_string() -> String {
  Host::input() |> ToUtf16::to_utf16()
}

// `output_bytes_to_memory` writes the (unprocessed) bytes to a Memory buffer on the host.
fn output_bytes_to_memory(b : Bytes) -> Memory {
  let length = b.length().to_int64()
  let offset = extism_alloc(length)
  for i = 0; i < length.to_int(); i = i + 1 {
    extism_store_u8(offset + i.to_int64(), b[i])
  }
  { offset, length }
}

/// `Host::output` sends a sequence of (unprocessed) bytes to the host as the plugin's "output".
pub fn Host::output(b : Bytes) -> Unit {
  let { offset, length } = output_bytes_to_memory(b)
  extism_output_set(offset, length)
}

/// Host::output_string converts a MoonBit String (UTF-16) to an Extism string (UTF-8)
/// and sends it to the host.
pub fn Host::output_string(s : String) -> Unit {
  ToUtf8::to_utf8(s) |> Host::output()
}

/// Host::output_json_value converts a MoonBit @json.JsonValue to an Extism JSON string
/// and sends it to the host.
pub fn Host::output_json_value(j : @json.JsonValue) -> Unit {
  @jsonutil.stringify(j, spaces=0, newline=false) |> Host::output_string()
}

/// Host::log_warn_str is a helper function to log a warn string to the host.
pub fn Host::log_warn_str(s : String) -> Unit {
  let { offset, .. } = ToUtf8::to_utf8(s) |> output_bytes_to_memory()
  extism_log_warn(offset)
  extism_free(offset)
}

/// Host::log_info_str is a helper function to log a info string to the host.
pub fn Host::log_info_str(s : String) -> Unit {
  let { offset, .. } = ToUtf8::to_utf8(s) |> output_bytes_to_memory()
  extism_log_info(offset)
  extism_free(offset)
}

/// Host::log_debug_str is a helper function to log a debug string to the host.
pub fn Host::log_debug_str(s : String) -> Unit {
  let { offset, .. } = ToUtf8::to_utf8(s) |> output_bytes_to_memory()
  extism_log_debug(offset)
  extism_free(offset)
}

/// Host::log_error_str is a helper function to log a error string to the host.
pub fn Host::log_error_str(s : String) -> Unit {
  let { offset, .. } = ToUtf8::to_utf8(s) |> output_bytes_to_memory()
  extism_log_error(offset)
  extism_free(offset)
}
