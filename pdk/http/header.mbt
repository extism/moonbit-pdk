/// `Header` represents an HTTP Request header.
pub type Header Map[String, Array[String]]

pub fn add(self : Header, key : String, value : String) -> Unit {
  match self.get(key) {
    Some(v) => ()
    None => ()
  }
}
