pub struct Var {}

pub fn Var::get_memory(key : String) -> Option[Memory] {
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

pub fn Var::get_bytes(key : String) -> Option[Bytes] {
  match Var::get_memory(key) {
    Some(v) => Some(v.to_bytes())
    _ => None
  }
}

pub fn Var::get_int(key : String) -> Option[Int] {
  match Var::get_memory(key) {
    Some(v) => Some(v.to_int())
    _ => None
  }
}

pub fn Var::get_string(key : String) -> Option[String] {
  match Var::get_memory(key) {
    Some(v) => Some(v.to_string())
    _ => None
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
