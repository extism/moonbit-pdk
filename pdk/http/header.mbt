/// `Header` represents an HTTP Request header.
/// Multiple values for a single key are not deduped.
// pub type Header Map[String, String]
pub struct Header {
  map : Map[String, String] // compiler workaround
}

impl @jsonutil.ToJson for Header with to_json(self) {
  let pairs = self.map.as_iter().map(
      fn { (k, v) => (k, @json.JsonValue::String(v)) },
    ).collect()
    |> @immut/sorted_map.Map::from_array()
  @json.JsonValue::Object(pairs)
}

/// `add` adds a value to a named (by `key`) header field.
/// If the header key already exists, the value is appended after a comma.
pub fn add(self : Header, key : String, value : String) -> Unit {
  match self.map.get(key) {
    Some(v) => self.map[key] = "\(v),\(value)"
    None => self.map[key] = value
  }
}

/// `set` overwrites a value to a named (by `key`) header field.
pub fn set(self : Header, key : String, value : String) -> Unit {
  self.map[key] = value
}

test "add" {
  let h = { map: Map::new() }
  h.add("key1", "one")
  h.add("key2", "one")
  h.add("key2", "two")
  h.add("key2", "two")
  // @assertion.assert_eq(h.map.get("nokey"), None)
  // @assertion.assert_eq(h.map.get("key1"), Some("one"))
  // @assertion.assert_eq(h.map.get("key2"), Some("one,two,two"))
}
