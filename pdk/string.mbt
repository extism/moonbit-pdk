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
  let mut i = 0
  let mut length = 0
  while i < chars.length() {
    length += bytes.set_utf8_char(length, chars[i])
    i += 1
  }
  // now that the size is known exactly (length), make a blit_copy:
  let result = Bytes::make(length)
  result.blit(0, bytes, 0, length)
  result
}
