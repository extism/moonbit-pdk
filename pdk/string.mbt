///|
/// ToUtf8 is a workaround since the standard library does not make
/// it easy to write a standard UTF-8 string.
/// https://github.com/moonbitlang/core/issues/484
pub(open) trait ToUtf8 {
  to_utf8(Self) -> Bytes
}

///|
/// `to_utf8` converts the MoonBit (UTF-16) `String` to a UTF-8 encoded `Bytes`.
pub impl ToUtf8 for String with to_utf8(s : String) -> Bytes {
  let chars = s.to_array()
  // first, allocate the maximum possible length of the UTF-8 "string":
  let arr = FixedArray::makei(4 * chars.length(), fn(_) { b'\x00' })
  let mut len = 0
  for i = 0; i < chars.length(); i = i + 1 {
    len += arr.set_utf8_char(len, chars[i])
  }
  Bytes::from_array(arr[:len])
}

///|
/// ToUtf16 is a workaround since the standard library does not make
/// it easy to write a standard UTF-16 string from UTF-8.
/// https://github.com/moonbitlang/core/issues/484
pub(open) trait ToUtf16 {
  to_utf16(Self) -> String
}

///|
/// `to_utf16` converts a UTF-8 encoded `Bytes` to a MoonBit (UTF-16) `String`.
pub impl ToUtf16 for Bytes with to_utf16(b : Bytes) -> String {
  // TODO: Make a real UTF-8 => UTF-16 converter.
  // https://github.com/moonbitlang/core/issues/484
  let length = b.length()
  let buf = @buffer.new(size_hint=2 * length)
  let mut i = 0
  while i < length {
    if (b[i] & 0xF0) == 0xF0 {
      let code = ((b[i].to_int() & 0x07) << 18) |
        ((b[i + 1].to_int() & 0x3F) << 12) |
        ((b[i + 2].to_int() & 0x3F) << 6) |
        (b[i + 3].to_int() & 0x3F)
      buf.write_char(Int::unsafe_to_char(code))
      i += 4
      continue
    }
    if (b[i] & 0xE0) == 0xE0 {
      let code = ((b[i].to_int() & 0x0F) << 12) |
        ((b[i + 1].to_int() & 0x3F) << 6) |
        (b[i + 2].to_int() & 0x3F)
      buf.write_char(Int::unsafe_to_char(code))
      i += 3
      continue
    }
    if (b[i] & 0xC0) == 0xC0 {
      let code = ((b[i].to_int() & 0x1F) << 6) | (b[i + 1].to_int() & 0x3F)
      buf.write_char(Int::unsafe_to_char(code))
      i += 2
      continue
    }
    let code = b[i].to_int() & 0x7F
    buf.write_char(Int::unsafe_to_char(code))
    i += 1
  }
  buf.contents().to_unchecked_string()
}
