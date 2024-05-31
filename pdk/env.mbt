fn input_length() -> Int64 = "extism:host/env" "input_length"

fn input_load_u8(offs : Int64) -> Byte = "extism:host/env" "input_load_u8"

fn input_load_u64(offs : Int64) -> Int64 = "extism:host/env" "input_load_u64"

fn length(a : Int64) -> Int64 = "extism:host/env" "length"

fn alloc(a : Int64) -> Int64 = "extism:host/env" "alloc"

fn free(a : Int64) -> Unit = "extism:host/env" "free"

fn output_set(a : Int64, b : Int64) -> Unit = "extism:host/env" "output_set"

fn error_set(a : Int64) -> Unit = "extism:host/env" "error_set"

fn config_get(a : Int64) -> Int64 = "extism:host/env" "config_get"

fn var_get(a : Int64) -> Int64 = "extism:host/env" "var_get"

fn var_set(a : Int64, b : Int64) -> Unit = "extism:host/env" "var_set"

fn store_u8(a : Int64, b : Byte) -> Unit = "extism:host/env" "store_u8"

fn load_u8(a : Int64) -> Byte = "extism:host/env" "load_u8"

fn store_u64(a : Int64, b : Int64) -> Unit = "extism:host/env" "store_u64"

fn load_u64(a : Int64) -> Int64 = "extism:host/env" "load_u64"

fn http_request(a : Int64, b : Int64) -> Int64 = "extism:host/env" "http_request"

fn log_warn(offs : Int64) -> Unit = "extism:host/env" "log_warn"

fn log_info(offs : Int64) -> Unit = "extism:host/env" "log_info"

fn log_debug(offs : Int64) -> Unit = "extism:host/env" "log_debug"

fn log_error(offs : Int64) -> Unit = "extism:host/env" "log_error"
