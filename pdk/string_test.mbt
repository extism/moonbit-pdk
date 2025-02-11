///|
test "simple ASCII utf-8 and utf-16 conversions work" {
  let orig = "This is a simple ASCII string"
  let utf8 = @pdk.ToUtf8::to_utf8(orig)
  assert_eq!(utf8, b"This is a simple ASCII string")
  let got = @pdk.ToUtf16::to_utf16(utf8)
  assert_eq!(got, orig)
}

///|
test "non-trivial utf-8 and utf-16 conversions work" {
  let orig = "这是一个不平凡的 UTF-16 字符串"
  let utf8 = @pdk.ToUtf8::to_utf8(orig)
  assert_eq!(
    utf8, b"\xe8\xbf\x99\xe6\x98\xaf\xe4\xb8\x80\xe4\xb8\xaa\xe4\xb8\x8d\xe5\xb9\xb3\xe5\x87\xa1\xe7\x9a\x84\x20\x55\x54\x46\x2d\x31\x36\x20\xe5\xad\x97\xe7\xac\xa6\xe4\xb8\xb2",
  )
  let got = @pdk.ToUtf16::to_utf16(utf8)
  assert_eq!(got, orig)
}
