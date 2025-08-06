///|
/// `Header` represents an HTTP Request header.
/// Multiple values for a single key are not deduped.
pub(all) struct Header(Map[String, String]) derive(Show, Eq)

///|
impl ToJson for Header with to_json(self) {
  self.inner().to_json()
}

///|
/// `Header::new` returns a new Header.
pub fn Header::new() -> Header {
  Header(Map::new())
}

///|
/// `add` adds a value to a named (by `key`) header field.
/// If the header key already exists, the value is appended after a comma.
pub fn add(self : Header, key : String, value : String) -> Unit {
  match self.inner().get(key) {
    Some(v) => self.inner()[key] = "\{v},\{value}"
    None => self.inner()[key] = value
  }
}

///|
/// `set` overwrites a value to a named (by `key`) header field.
pub fn set(self : Header, key : String, value : String) -> Unit {
  self.inner()[key] = value
}

///|
test "Header::add" {
  let h = Header::new()
  h.add("key1", "one")
  h.add("key2", "one")
  h.add("key2", "two")
  h.add("key2", "two")
  assert_eq(h.inner().get("nokey"), None)
  assert_eq(h.inner().get("key1"), Some("one"))
  assert_eq(h.inner().get("key2"), Some("one,two,two"))
}

///|
test "Header::to_json works as expected" {
  let header : Header = { "key1": "one", "key2": "two" }
  let got = header.to_json().stringify()
  let want =
    #|{"key1":"one","key2":"two"}
  assert_eq(got, want)
}
