pub struct Var {}

pub fn Var::get_memory(key : String) -> Memory? {
  let mem = Memory::allocate_string(key)
  let offset = var_get(mem.offset)
  if offset == 0L {
    return None
  }
  let length = length(offset)
  if length == 0L {
    return None
  }
  Some({ offset, length })
}

pub fn Var::get_bytes(key : String) -> Bytes? {
  match Var::get_memory(key) {
    Some(v) => Some(v.to_bytes())
    None => None
  }
}

pub fn Var::get_int(key : String) -> Int? {
  match Var::get_memory(key) {
    Some(v) => Some(v.to_int())
    None => None
  }
}

pub fn Var::get_string(key : String) -> String? {
  match Var::get_memory(key) {
    Some(v) => Some(v.to_string())
    None => None
  }
}

pub fn Var::set_bytes(key : String, value : Bytes) -> Unit {
  let keyMem = Memory::allocate_string(key)
  let valMem = Memory::allocate_bytes(value)
  var_set(keyMem.offset, valMem.offset)
}

pub fn Var::set_int(key : String, value : Int) -> Unit {
  let keyMem = Memory::allocate_string(key)
  let bytes = Bytes::make(4)
  bytes[0] = value.land(255).to_byte()
  bytes[1] = value.lsr(8).land(255).to_byte()
  bytes[2] = value.lsr(16).land(255).to_byte()
  bytes[3] = value.lsr(24).land(255).to_byte()
  let valMem = Memory::allocate_bytes(bytes)
  var_set(keyMem.offset, valMem.offset)
}

pub fn Var::remove(key : String) -> Unit {
  let mem = Memory::allocate_string(key)
  var_set(mem.offset, 0L)
}
