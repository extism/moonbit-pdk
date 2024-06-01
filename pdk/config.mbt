pub struct Config {}

pub fn Config::get_memory(key : String) -> Option[Memory] {
  let mem = Memory::allocate_string(key)
  let offset = config_get(mem.offset)
  if offset == 0L {
    return None
  }
  let length = length(offset)
  if length == 0L {
    return None
  }
  Some({ offset, length })
}

pub fn Config::get(key : String) -> Option[String] {
  match Config::get_memory(key) {
    Some(mem) => Some(mem.to_string())
    _ => None
  }
}
