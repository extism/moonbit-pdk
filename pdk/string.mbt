/// ToUtf8 is a workaround since the standard library does not make
/// it easy to write a standard UTF-8 string.
/// https://github.com/moonbitlang/core/issues/484
pub(open) trait ToUtf8 {
  to_utf8(Self) -> Bytes
}

/// `to_utf8` converts the MoonBit (UTF-16) `String` to a UTF-8 encoded `Bytes`.
pub impl ToUtf8 for String with to_utf8(s : String) -> Bytes {
  let chars = s.to_array()
  // first, allocate the maximum possible length of the UTF-8 "string":
  let bytes = Bytes::new(4 * chars.length())
  let mut length = 0
  for i = 0; i < chars.length(); i = i + 1 {
    length += bytes.set_utf8_char(length, chars[i])
  }
  // now that the size is known exactly (length), make a blit_copy:
  let result = Bytes::new(length)
  result.blit(0, bytes, 0, length)
  result
}

/// ToUtf16 is a workaround since the standard library does not make
/// it easy to write a standard UTF-16 string from UTF-8.
/// https://github.com/moonbitlang/core/issues/484
pub(open) trait ToUtf16 {
  to_utf16(Self) -> String
}

/// `to_utf16` converts a UTF-8 encoded `Bytes` to a MoonBit (UTF-16) `String`.
pub impl ToUtf16 for Bytes with to_utf16(b : Bytes) -> String {
  // TODO: Make a real UTF-8 => UTF-16 converter.
  // For now, support ASCII.
  // https://github.com/moonbitlang/core/issues/484
  let length = b.length()
  let buf = @buffer.new(size_hint=2 * length)
  for i = 0; i < length; i = i + 1 {
    let byte = b[i].to_int()
    let char = Char::from_int(byte)
    buf.write_char(char)
  }
  buf.to_string()
}
