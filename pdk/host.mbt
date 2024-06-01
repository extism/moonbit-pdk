pub struct Host {
}

// pub fn Host::input() -> Array[Byte] {
//   let length = input_length().to_int()
//   Array::new_with_index(length, fn(i) { input_load_u8(i.to_int64()) })
// }

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

pub fn Host::inputString() -> String {
  Host::input().to_string()
}

// pub fn Host::output(s : Array[Byte]) -> Unit {
//   let length = s.length().to_int64()
//   let offset = alloc(length)
//   s.blit_to()
//   store(offset, s)
//   output_set(offset, length)
// }

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

// outputString converts a MoonBit String (UTF-16) to an Extism string (UTF-8).
pub fn Host::outputString(s : String) -> Unit {
  let chars = s.to_array()
  let tmp_bytes = Bytes::make(4)
  let mut i = 0
  let offset = alloc((4 * chars.length()).to_int64())
  let mut length = 0L
  let out = fn(b) {
    store_u8(offset + length, b)
    length += 1L
  }
  while i < chars.length() {
    match tmp_bytes.set_utf8_char(0, chars[i]) {
      1 => out(tmp_bytes[0])
      2 => {
        out(tmp_bytes[0])
        out(tmp_bytes[1])
      }
      3 => {
        out(tmp_bytes[0])
        out(tmp_bytes[1])
        out(tmp_bytes[2])
      }
      4 => {
        out(tmp_bytes[0])
        out(tmp_bytes[1])
        out(tmp_bytes[2])
        out(tmp_bytes[3])
      }
      _ => panic() // abort("mal-formed UTF-16 string")
    }
    i += 1
  }
  output_set(offset, length)
}

// outputJsonValue converts a MoonBit @json.JsonValue to an Extism JSON string.
pub fn Host::outputJsonValue(j : @json.JsonValue) -> Unit {
  let s = @jsonutil.stringify(j, spaces=0, newline=false)
  Host::outputString(s)
}
