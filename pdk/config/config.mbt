///| `Config` provides methods to get "config" data from the host.
pub(all) struct Config {}

///| `Config::get_memory` returns a "config" Memory block from the host that is keyed by `key`.
/// Note that no processing is performed on this block of memory.
pub fn Config::get_memory(key : String) -> @host.Memory? {
  let key_mem = @host.allocate_string(key)
  let offset = @extism.config_get(key_mem.offset)
  key_mem.free()
  if offset == 0L {
    return None
  }
  let length = @extism.length(offset)
  if length == 0L {
    return None
  }
  Some({ offset, length })
}

///| `Config::get` returns a "config" String from the host that is keyed by `key`.
/// Note that the Extism host strings are UTF-8 and therefore the returned
/// String is encoded as UTF-16 in compliance with MoonBit Strings.
pub fn Config::get(key : String) -> String? {
  match Config::get_memory(key) {
    Some(mem) => {
      let s = mem.to_string()
      mem.free()
      Some(s)
    }
    None => None
  }
}
