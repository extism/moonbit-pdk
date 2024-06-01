/// Memory represents memory allocated by (and shared with) the host.
/// TODO: What kind of error checking needs to happen here?
pub struct Memory {
  offset : Int64
  length : Int64
}

/// `release` releases this Memory from the host.
/// The AssemblyScript PDK calls this function `free`.
pub fn release(self : Memory) -> Unit {
  free(self.offset)
}

/// allocate allocates an uninitialized (determined by host)
/// area of shared memory on the host.
pub fn Memory::allocate(length : Int64) -> Memory {
  { offset: alloc(length), length }
}

/// allocate_bytes allocates and initializes host memory
/// with the provided bytes.
pub fn Memory::allocate_bytes(bytes : Bytes) -> Memory {
  let length = bytes.length().to_int64()
  let offset = alloc(length)
  let mut i = 0L
  while i < length {
    store_u8(offset + i, bytes[i.to_int()])
    i += 1L
  }
  { offset, length }
}

/// allocate_string allocates and initializes a utf-8 string
/// in host memory that is converted from this utf-16 MoonBit String.
pub fn Memory::allocate_string(s : String) -> Memory {
  ToUtf8::to_utf8(s) |> allocate_bytes()
}

/// to_string reads and converts the utf-8 string residing in the host memory
/// to a utf-16 MoonBit String.
pub fn to_string(self : Memory) -> String {
  self.to_bytes() |> ToUtf16::to_utf16()
}

/// to_bytes reads the bytes residing in the host memory
/// to a MoonBit Bytes.
pub fn to_bytes(self : Memory) -> Bytes {
  let bytes = Bytes::make(self.length.to_int())
  let mut i = 0L
  while i < self.length {
    bytes[i.to_int()] = load_u8(self.offset + i)
    i += 1L
  }
  bytes
}
