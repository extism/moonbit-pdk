/// `Header` represents an HTTP Request header.
/// Multiple values for a single key are not deduped.
// pub type Header Map[String, Array[String]]
pub struct Header {
  map : Map[String, Array[String]] // compiler workaround
}

pub fn add(self : Header, key : String, value : String) -> Unit {
  match self.map.get(key) {
    Some(v) => v.push(value)
    None => self.map[key] = [value]
  }
}

test "add" {
  let h = { map: Map::new() }
  h.add("key1", "one")
  h.add("key2", "one")
  h.add("key2", "two")
  h.add("key2", "two")
  @assertion.assert_eq(h.map.get("nokey"), None)
  @assertion.assert_eq(h.map.get("key1"), Some(["one"]))
  @assertion.assert_eq(h.map.get("key2"), Some(["one", "two", "two"]))
}
