pub struct Config {}

pub fn Config::get_memory(key : String) -> Memory? {
  // Host::log_debug_str("Config::get_memory(key=\(key))")
  let mem = Memory::allocate_string(key)
  let offset = config_get(mem.offset)
  // let mem_offset = mem.offset // MoonBit workaround
  // Host::log_debug_str("Config::get_memory: config_get(\(mem_offset))=\(offset)")
  if offset == 0L {
    // Host::log_debug_str("Config::get_memory(key=\(key)) is uninitialized.")
    return None
  }
  let length = length(offset)
  if length == 0L {
    // Host::log_debug_str("Config::get_memory(key=\(key)) has zero length.")
    return None
  }
  // Host::log_debug_str("Config::get_memory(key=\(key)) has offset=\(offset) and length=\(length).")
  Some({ offset, length })
}

pub fn Config::get(key : String) -> String? {
  match Config::get_memory(key) {
    Some(mem) => Some(mem.to_string())
    None =>
      // Host::log_debug_str("Config::get(key=\(key)) is uninitialized.")
      None
  }
}
