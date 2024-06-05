/// `extism_input_length` returns the number of (unprocessed) bytes provided by the host via its input methods.
/// The user of this PDK will typically not call this method directly.
pub fn extism_input_length() -> Int64 = "extism:host/env" "input_length"

/// `extism_input_load_u8` returns the byte at location `offset` of the "input" data from the host.
/// The user of this PDK will typically not call this method directly.
pub fn extism_input_load_u8(offset : Int64) -> Byte = "extism:host/env" "input_load_u8"

/// `extism_input_load_u64` returns the 64-bit unsigned integer of the "input" data from the host.
/// Note that MoonBit has no unsigned integers,
/// so the result is returned as an Int64.
/// Also note that `offset` must lie on an 8-byte boundary.
/// The user of this PDK will typically not call this method directly.
pub fn extism_input_load_u64(offset : Int64) -> Int64 = "extism:host/env" "input_load_u64"

/// `extism_length` returns the number of bytes associated with the block of host memory
/// located at `offset`.
/// The user of this PDK will typically not call this method directly.
pub fn extism_length(offset : Int64) -> Int64 = "extism:host/env" "length"

/// `extism_alloc` allocates `length` bytes of data with host memory for use by the plugin
/// and returns its `offset` within the host memory block.
/// The user of this PDK will typically not call this method directly.
pub fn extism_alloc(length : Int64) -> Int64 = "extism:host/env" "alloc"

/// `extism_free` releases the bytes previously allocated with `alloc` at the given `offset`.
/// The user of this PDK will typically not call this method directly.
pub fn extism_free(offset : Int64) = "extism:host/env" "free"

/// `extism_output_set` sets the "output" data from the plugin to the host to be the memory that
/// has been written at `offset` with the given `length`.
/// The user of this PDK will typically not call this method directly.
pub fn extism_output_set(offset : Int64, length : Int64) = "extism:host/env" "output_set"

/// `extism_error_set` sets the "error" data from the plugin to the host to be the memory that
/// has been written at `offset`.
/// The user of this PDK will typically not call this method directly.
pub fn extism_error_set(offset : Int64) = "extism:host/env" "error_set"

/// `extism_config_get` returns the host memory block offset for the "config" data associated with
/// the key which is represented by the UTF-8 string which as been previously
/// written at `offset`.
/// The user of this PDK will typically not call this method directly.
pub fn extism_config_get(offset : Int64) -> Int64 = "extism:host/env" "config_get"

/// `extism_var_get` returns the host memory block offset for the "var" data associated with
/// the key which is represented by the UTF-8 string which as been previously
/// written at `offset`.
/// The user of this PDK will typically not call this method directly.
pub fn extism_var_get(offset : Int64) -> Int64 = "extism:host/env" "var_get"

/// `extism_var_set` sets the host "var" memory keyed by the UTF-8 string located at `offset`
/// to be the value which has been previously written at `value_offset`.
/// The user of this PDK will typically not call this method directly.
pub fn extism_var_set(offset : Int64, value_offset : Int64) = "extism:host/env" "var_set"

/// `extism_store_u8` stores the Byte `b` at location `offset` in the host memory block.
/// The user of this PDK will typically not call this method directly.
pub fn extism_store_u8(offset : Int64, b : Byte) = "extism:host/env" "store_u8"

/// `extism_load_u8` returns the Byte located at `offset` in the host memory block.
/// The user of this PDK will typically not call this method directly.
pub fn extism_load_u8(offset : Int64) -> Byte = "extism:host/env" "load_u8"

/// `extism_store_u64` stores the Int64 value `v` at location `offset` in the host memory block.
/// Note that MoonBit does not have unsigned integers, but the host interprets
/// the provided `v` value as an unsigned 64-bit integer.
/// Also note that `offset` must lie on an 8-byte boundary.
/// The user of this PDK will typically not call this method directly.
pub fn extism_store_u64(offset : Int64, v : Int64) = "extism:host/env" "store_u64"

/// `extism_load_u64` returns the 64-bit unsigned integer at location `offset` in the host memory block.
/// Note that MoonBit has no unsigned integers,
/// so the result is returned as an Int64.
/// Also note that `offset` must lie on an 8-byte boundary.
/// The user of this PDK will typically not call this method directly.
pub fn extism_load_u64(offset : Int64) -> Int64 = "extism:host/env" "load_u64"

pub fn extism_http_request(offset : Int64, b : Int64) -> Int64 = "extism:host/env" "http_request"

/// `extism_log_warn` logs a "warning" string to the host from the previously-written UTF-8 string written to `offset`.
/// The user of this PDK will typically not call this method directly.
pub fn extism_log_warn(offset : Int64) = "extism:host/env" "log_warn"

/// `extism_log_info` logs an "info" string to the host from the previously-written UTF-8 string written to `offset`.
/// The user of this PDK will typically not call this method directly.
pub fn extism_log_info(offset : Int64) = "extism:host/env" "log_info"

/// `extism_log_debug` logs a "debug" string to the host from the previously-written UTF-8 string written to `offset`.
/// The user of this PDK will typically not call this method directly.
pub fn extism_log_debug(offset : Int64) = "extism:host/env" "log_debug"

/// `extism_log_error` logs an "error" string to the host from the previously-written UTF-8 string written to `offset`.
/// The user of this PDK will typically not call this method directly.
pub fn extism_log_error(offset : Int64) = "extism:host/env" "log_error"
