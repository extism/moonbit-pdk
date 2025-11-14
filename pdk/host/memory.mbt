///|
/// `Memory` represents memory allocated by (and shared with) the host.
/// TODO: What kind of error checking needs to happen here?
pub(all) struct Memory {
  offset : Int64
  length : Int64
}

///|
/// `find_memory` returns a `Memory` struct from an offset provided by the host.
pub fn find_memory(offset : Int64) -> Memory {
  let length = @extism.length(offset)
  { offset, length }
}

///|
/// `free` releases this Memory from the host.
pub fn Memory::free(self : Memory) -> Unit {
  @extism.free(self.offset)
}

///|
/// `allocate` allocates an uninitialized (determined by host)
/// area of shared memory on the host.
pub fn allocate(length : Int64) -> Memory {
  { offset: @extism.alloc(length), length }
}

///|
/// `allocate_bytes` allocates and initializes host memory
/// with the provided (unprocessed) bytes.
pub fn allocate_bytes(bytes : Bytes) -> Memory {
  let length = bytes.length().to_int64()
  let offset = @extism.alloc(length)
  for i in 0L..<length {
    @extism.store_u8(offset + i, bytes[i.to_int()])
  }
  { offset, length }
}

///|
/// `output_memory` sets the host's "output" to be the contents of this Memory data.
pub fn Memory::output_memory(self : Memory) -> Unit {
  @extism.output_set(self.offset, self.length)
}

///|
/// `allocate_string` allocates and initializes a UTF-8 string
/// in host memory that is converted from this UTF-16 MoonBit String.
pub fn allocate_string(s : String) -> Memory {
  @pdk.ToUtf8::to_utf8(s) |> allocate_bytes()
}

///|
/// `allocate_json_value` allocates and initializes a UTF-8 string
/// in host memory that is converted from this `Json`.
pub fn allocate_json_value(j : Json) -> Memory {
  j.stringify() |> allocate_string()
}

///|
/// `to_string` reads and converts the UTF-8 string residing in the host memory
/// to a UTF-16 MoonBit String.
pub fn Memory::to_string(self : Memory) -> String {
  self.to_bytes() |> @pdk.ToUtf16::to_utf16()
}

///|
/// `to_int` reads and converts the u32 residing in the host memory
/// to a MoonBit Int.
pub fn Memory::to_int(self : Memory) -> Int {
  let bytes = self.to_bytes()
  bytes[0].to_int() +
  (bytes[1].to_int() << 8) +
  (bytes[2].to_int() << 16) +
  (bytes[3].to_int() << 24)
}

///|
/// `to_bytes` reads the (unprocessed) bytes residing in the host memory
/// to a MoonBit Bytes.
pub fn Memory::to_bytes(self : Memory) -> Bytes {
  let bytes = FixedArray::makei(self.length.to_int(), fn(i) {
    @extism.load_u8(self.offset + i.to_int64())
  })
  Bytes::from_array(bytes)
}
