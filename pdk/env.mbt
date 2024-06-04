pub fn input_length() -> Int64 = "extism:host/env" "input_length"

pub fn input_load_u8(offset : Int64) -> Byte = "extism:host/env" "input_load_u8"

pub fn input_load_u64(offset : Int64) -> Int64 = "extism:host/env" "input_load_u64"

pub fn length(offset : Int64) -> Int64 = "extism:host/env" "length"

pub fn alloc(length : Int64) -> Int64 = "extism:host/env" "alloc"

pub fn free(offset : Int64) = "extism:host/env" "free"

pub fn output_set(offset : Int64, b : Int64) = "extism:host/env" "output_set"

pub fn error_set(offset : Int64) = "extism:host/env" "error_set"

pub fn config_get(offset : Int64) -> Int64 = "extism:host/env" "config_get"

pub fn var_get(offset : Int64) -> Int64 = "extism:host/env" "var_get"

pub fn var_set(offset : Int64, b : Int64) = "extism:host/env" "var_set"

pub fn store_u8(offset : Int64, b : Byte) = "extism:host/env" "store_u8"

pub fn load_u8(offset : Int64) -> Byte = "extism:host/env" "load_u8"

pub fn store_u64(offset : Int64, b : Int64) = "extism:host/env" "store_u64"

pub fn load_u64(offset : Int64) -> Int64 = "extism:host/env" "load_u64"

pub fn http_request(offset : Int64, b : Int64) -> Int64 = "extism:host/env" "http_request"

pub fn log_warn(offset : Int64) = "extism:host/env" "log_warn"

pub fn log_info(offset : Int64) = "extism:host/env" "log_info"

pub fn log_debug(offset : Int64) = "extism:host/env" "log_debug"

pub fn log_error(offset : Int64) = "extism:host/env" "log_error"
