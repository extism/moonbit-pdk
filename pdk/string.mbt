/// ToUtf8 is a workaround since the standard library does not make
/// it easy to write a standard utf8 string.
/// https://github.com/moonbitlang/core/issues/484
pub trait ToUtf8 {
  to_utf8(Self) -> Bytes
}

pub fn ToUtf8::to_utf8(s : String) -> Bytes {
  let chars = s.to_array()
  // first, allocate the maximum possible length of the utf8 "string":
  let bytes = Bytes::make(4 * chars.length())
  let mut length = 0
  for i = 0; i < chars.length(); i = i + 1 {
    length += bytes.set_utf8_char(length, chars[i])
  }
  // now that the size is known exactly (length), make a blit_copy:
  let result = Bytes::make(length)
  result.blit(0, bytes, 0, length)
  result
}

/// ToUtf16 is a workaround since the standard library does not make
/// it easy to read a standard utf8 string.
/// https://github.com/moonbitlang/core/issues/484
pub trait ToUtf16 {
  to_utf16(Self) -> String
}

pub fn ToUtf16::to_utf16(b : Bytes) -> String {
  // TODO: Make a real UTF-8 => UTF-16 converter.
  // For now, support ASCII.
  // https://github.com/moonbitlang/core/issues/484
  let length = b.length()
  // Host::log_debug_str("ToUtf16::to_utf16: b.length=\(length)")
  let buf = Buffer::make(2 * length)
  for i = 0; i < length; i = i + 1 {
    let byte = b[i].to_int()
    let char = Char::from_int(byte)
    // println("to_utf16: b[\(i)]=\(byte)=\(char)")
    buf.write_char(char)
  }
  buf.to_string()
}
