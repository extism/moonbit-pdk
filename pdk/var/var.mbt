/// `get_memory` returns the (unprocessed) host Memory block for the "var" data associated with
/// the provided `key`.
pub fn get_memory(key : String) -> @host.Memory? {
  let key_mem = @host.allocate_string(key)
  let offset = @extism.var_get(key_mem.offset)
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

/// `get_bytes` returns the (unprocessed) host Memory block for the "var" data associated with
/// the provided `key`.
pub fn get_bytes(key : String) -> Bytes? {
  match get_memory(key) {
    Some(v) => Some(v.to_bytes())
    None => None
  }
}

/// `get_int` returns the host's "var" Int associated with the provided `key`.
pub fn get_int(key : String) -> Int? {
  match get_memory(key) {
    Some(v) => Some(v.to_int())
    None => None
  }
}

/// `get_string` returns the host's "var" String associated with the provided `key`.
/// Note that the Extism host string is UTF-8 and the string is converted to
/// a MoonBit (UTF-16) String.
pub fn get_string(key : String) -> String? {
  match get_memory(key) {
    Some(v) => Some(v.to_string())
    None => None
  }
}

/// `set_bytes` sets the (unprocessed) host Memory block for the "var" data associated with
/// the provided `key`.
pub fn set_bytes(key : String, value : Bytes) -> Unit {
  let key_mem = @host.allocate_string(key)
  let val_mem = @host.allocate_bytes(value)
  @extism.var_set(key_mem.offset, val_mem.offset)
  key_mem.free()
  val_mem.free()
}

/// `set_int` sets the host's "var" Int associated with the provided `key`.
pub fn set_int(key : String, value : Int) -> Unit {
  let key_mem = @host.allocate_string(key)
  let bytes = Bytes::new(4)
  bytes[0] = value.land(255).to_byte()
  bytes[1] = value.lsr(8).land(255).to_byte()
  bytes[2] = value.lsr(16).land(255).to_byte()
  bytes[3] = value.lsr(24).land(255).to_byte()
  let val_mem = @host.allocate_bytes(bytes)
  @extism.var_set(key_mem.offset, val_mem.offset)
  key_mem.free()
  val_mem.free()
}

/// `set_string` sets the host Memory block for the "var" data associated with
/// the provided `key`.
/// Note that the MoonBit String is UTF-16 and the string is converted to
/// a UTF-8 string for the Extism host.
pub fn set_string(key : String, value : String) -> Unit {
  let key_mem = @host.allocate_string(key)
  let val_mem = @host.allocate_string(value)
  @extism.var_set(key_mem.offset, val_mem.offset)
  key_mem.free()
  val_mem.free()
}

/// `remove` deletes the value in the host's "var" memory associated with the provided `key`.
pub fn remove(key : String) -> Unit {
  let key_mem = @host.allocate_string(key)
  @extism.var_set(key_mem.offset, 0L)
  key_mem.free()
}
