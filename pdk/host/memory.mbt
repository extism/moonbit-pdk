/// `Memory` represents memory allocated by (and shared with) the host.
/// TODO: What kind of error checking needs to happen here?
pub struct Memory {
  offset : Int64
  length : Int64
}

/// `free` releases this Memory from the host.
pub fn free(self : Memory) -> Unit {
  @extism.free(self.offset)
}

/// `Memory::allocate` allocates an uninitialized (determined by host)
/// area of shared memory on the host.
pub fn Memory::allocate(length : Int64) -> Memory {
  { offset: @extism.alloc(length), length }
}

/// `Memory::allocate_bytes` allocates and initializes host memory
/// with the provided (unprocessed) bytes.
pub fn Memory::allocate_bytes(bytes : Bytes) -> Memory {
  let length = bytes.length().to_int64()
  let offset = @extism.alloc(length)
  for i = 0L; i < length; i = i + 1L {
    @extism.store_u8(offset + i, bytes[i.to_int()])
  }
  { offset, length }
}

/// `output_memory` sets the host's "output" to be the contents of this Memory data.
pub fn output_memory(self : Memory) -> Unit {
  @extism.output_set(self.offset, self.length)
}

/// `Memory::allocate_string` allocates and initializes a UTF-8 string
/// in host memory that is converted from this UTF-16 MoonBit String.
pub fn Memory::allocate_string(s : String) -> Memory {
  @pdk.ToUtf8::to_utf8(s) |> allocate_bytes()
}

/// `Memory::allocate_json_value` allocates and initializes a UTF-8 string
/// in host memory that is converted from this `@json.JsonValue`.
pub fn Memory::allocate_json_value(j : @json.JsonValue) -> Memory {
  @jsonutil.stringify(j, spaces=0, newline=false) |> Memory::allocate_string()
}

/// `to_string` reads and converts the UTF-8 string residing in the host memory
/// to a UTF-16 MoonBit String.
pub fn to_string(self : Memory) -> String {
  self.to_bytes() |> @pdk.ToUtf16::to_utf16()
}

/// `to_int` reads and converts the u32 residing in the host memory
/// to a MoonBit Int.
pub fn to_int(self : Memory) -> Int {
  let bytes = self.to_bytes()
  bytes[0].to_int() + bytes[1].to_int().lsl(8) + bytes[2].to_int().lsl(16) + bytes[3].to_int().lsl(
    24,
  )
}

/// `to_bytes` reads the (unprocessed) bytes residing in the host memory
/// to a MoonBit Bytes.
pub fn to_bytes(self : Memory) -> Bytes {
  let bytes = Bytes::make(self.length.to_int())
  for i = 0L; i < self.length; i = i + 1L {
    let byte = @extism.load_u8(self.offset + i)
    bytes[i.to_int()] = byte
  }
  bytes
}
