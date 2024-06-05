/// `Var` provides methods used to read and write the Extism host's "var" data.
pub struct Var {}

/// `Var::get_memory` returns the (unprocessed) host Memory block for the "var" data associated with
/// the provided `key`.
pub fn Var::get_memory(key : String) -> Memory? {
  let mem = Memory::allocate_string(key)
  let offset = extism_var_get(mem.offset)
  if offset == 0L {
    return None
  }
  let length = extism_length(offset)
  if length == 0L {
    return None
  }
  Some({ offset, length })
}

/// `Var::get_bytes` returns the (unprocessed) host Memory block for the "var" data associated with
/// the provided `key`.
pub fn Var::get_bytes(key : String) -> Bytes? {
  match Var::get_memory(key) {
    Some(v) => Some(v.to_bytes())
    None => None
  }
}

/// `Var::get_int` returns the host's "var" Int associated with the provided `key`.
pub fn Var::get_int(key : String) -> Int? {
  match Var::get_memory(key) {
    Some(v) => Some(v.to_int())
    None => None
  }
}

/// `Var::get_string` returns the host's "var" String associated with the provided `key`.
/// Note that the Extism host string is in UTF-8 and the string is converted to
/// a MoonBit (UTF-16) String.
pub fn Var::get_string(key : String) -> String? {
  match Var::get_memory(key) {
    Some(v) => Some(v.to_string())
    None => None
  }
}

/// `Var::set_bytes` sets the (unprocessed) host Memory block for the "var" data associated with
/// the provided `key`.
pub fn Var::set_bytes(key : String, value : Bytes) -> Unit {
  let keyMem = Memory::allocate_string(key)
  let valMem = Memory::allocate_bytes(value)
  extism_var_set(keyMem.offset, valMem.offset)
}

/// `Var::set_int` sets the host's "var" Int associated with the provided `key`.
pub fn Var::set_int(key : String, value : Int) -> Unit {
  let keyMem = Memory::allocate_string(key)
  let bytes = Bytes::make(4)
  bytes[0] = value.land(255).to_byte()
  bytes[1] = value.lsr(8).land(255).to_byte()
  bytes[2] = value.lsr(16).land(255).to_byte()
  bytes[3] = value.lsr(24).land(255).to_byte()
  let valMem = Memory::allocate_bytes(bytes)
  extism_var_set(keyMem.offset, valMem.offset)
}

/// `Var::remove` deletes the value in the host's "var" memory associated with the provided `key`.
pub fn Var::remove(key : String) -> Unit {
  let mem = Memory::allocate_string(key)
  extism_var_set(mem.offset, 0L)
}
