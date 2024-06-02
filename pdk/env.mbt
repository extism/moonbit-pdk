pub fn input_length() -> Int64 = "extism:host/env" "input_length"

pub fn input_load_u8(offs : Int64) -> Byte = "extism:host/env" "input_load_u8"

pub fn input_load_u64(offs : Int64) -> Int64 = "extism:host/env" "input_load_u64"

pub fn length(a : Int64) -> Int64 = "extism:host/env" "length"

pub fn alloc(a : Int64) -> Int64 = "extism:host/env" "alloc"

pub fn free(a : Int64) -> Unit = "extism:host/env" "free"

pub fn output_set(a : Int64, b : Int64) -> Unit = "extism:host/env" "output_set"

pub fn error_set(a : Int64) -> Unit = "extism:host/env" "error_set"

pub fn config_get(a : Int64) -> Int64 = "extism:host/env" "config_get"

pub fn var_get(a : Int64) -> Int64 = "extism:host/env" "var_get"

pub fn var_set(a : Int64, b : Int64) -> Unit = "extism:host/env" "var_set"

pub fn store_u8(a : Int64, b : Byte) -> Unit = "extism:host/env" "store_u8"

pub fn load_u8(a : Int64) -> Byte = "extism:host/env" "load_u8"

pub fn store_u64(a : Int64, b : Int64) -> Unit = "extism:host/env" "store_u64"

pub fn load_u64(a : Int64) -> Int64 = "extism:host/env" "load_u64"

pub fn http_request(a : Int64, b : Int64) -> Int64 = "extism:host/env" "http_request"

pub fn log_warn(offs : Int64) -> Unit = "extism:host/env" "log_warn"

pub fn log_info(offs : Int64) -> Unit = "extism:host/env" "log_info"

pub fn log_debug(offs : Int64) -> Unit = "extism:host/env" "log_debug"

pub fn log_error(offs : Int64) -> Unit = "extism:host/env" "log_error"
