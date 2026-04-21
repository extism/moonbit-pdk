///|
/// `Header` represents an HTTP Request header.
/// Multiple values for a single key are not deduped.
pub(all) struct Header(Map[String, String]) derive(Eq)

///|
pub impl Show for Header with output(self, logger) {
  logger.write_string(
    (
      $|Header(\{self.0.to_string()})
    ),
  )
}

///|
impl ToJson for Header with to_json(self) {
  self.0.to_json()
}

///|
/// `Header::new` returns a new Header.
pub fn Header::new() -> Header {
  Header(Map::new())
}

///|
/// `add` adds a value to a named (by `key`) header field.
/// If the header key already exists, the value is appended after a comma.
pub fn Header::add(self : Header, key : String, value : String) -> Unit {
  match self.0.get(key) {
    Some(v) => self.0[key] = "\{v},\{value}"
    None => self.0[key] = value
  }
}

///|
/// `set` overwrites a value to a named (by `key`) header field.
pub fn Header::set(self : Header, key : String, value : String) -> Unit {
  self.0[key] = value
}

///|
test "Header::add" {
  let h = Header::new()
  h.add("key1", "one")
  h.add("key2", "one")
  h.add("key2", "two")
  h.add("key2", "two")
  inspect(
    h,
    content=(
      #|Header({"key1": "one", "key2": "one,two,two"})
    ),
  )
}

///|
test "Header::to_json works as expected" {
  let header : Header = { "key1": "one", "key2": "two" }
  let got = header.to_json().stringify()
  let want =
    #|{"key1":"one","key2":"two"}
  inspect(got, content=want)
}
