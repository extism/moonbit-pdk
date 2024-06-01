pub struct Host {}

/// Host::input returns a sequence of bytes from the host.
pub fn Host::input() -> Bytes {
  let length = input_length().to_int()
  let value = Bytes::make(length)
  let mut i = 0
  while i < length {
    value[i] = input_load_u8(i.to_int64())
    i += 1
  }
  value
}

/// Host::inputString returns a string from the host.
pub fn Host::inputString() -> String {
  let bytes = Host::input()
  // TODO: Make a real UTF-8 => UTF-16 converter.
  // For now, support ASCII.
  let length = bytes.length()
  let buf = Buffer::make(2 * length)
  let mut i = 0
  while i < length {
    buf.write_char(Char::from_int(bytes[i].to_int()))
    i += 1
  }
  buf.to_string()
}

/// Host::output sends a sequence of bytes to the host.
pub fn Host::output(b : Bytes) -> Unit {
  let length = b.length().to_int64()
  let offset = alloc(length)
  let mut i = 0
  while i < length.to_int() {
    store_u8(offset + i.to_int64(), b[i])
    i += 1
  }
  output_set(offset, length)
}

// pub fn Host::outputMemory(s : Memory) -> Unit {
//   output_set(s.offset, s.length)
// }

/// Host::outputString converts a MoonBit String (UTF-16) to an Extism string (UTF-8)
/// and sends it to the host.
pub fn Host::outputString(s : String) -> Unit {
  ToUtf8::to_utf8(s) |> Host::output()
}

/// Host::outputJsonValue converts a MoonBit @json.JsonValue to an Extism JSON string
/// and sends it to the host.
pub fn Host::outputJsonValue(j : @json.JsonValue) -> Unit {
  @jsonutil.stringify(j, spaces=0, newline=false) |> Host::outputString()
}
