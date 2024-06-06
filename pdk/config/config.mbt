/// `Config` provides methods to get "config" data from the host.
pub struct Config {}

/// `Config::get_memory` returns a "config" Memory block from the host that is keyed by `key`.
/// Note that no processing is performed on this block of memory.
pub fn Config::get_memory(key : String) -> @memory.Memory? {
  let mem = @memory.allocate_string(key)
  let offset = @pdk.extism_config_get(mem.offset)
  if offset == 0L {
    return None
  }
  let length = @pdk.extism_length(offset)
  if length == 0L {
    return None
  }
  Some({ offset, length })
}

/// `Config::get` returns a "config" String from the host that is keyed by `key`.
/// Note that the Extism host strings are UTF-8 and therefore the returned
/// String is encoded as UTF-16 in compliance with MoonBit Strings.
pub fn Config::get(key : String) -> String? {
  match Config::get_memory(key) {
    Some(mem) => Some(mem.to_string())
    None => None
  }
}