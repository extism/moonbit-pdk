///|
pub fn kitchen_sink() -> Int {
  // Input
  let input = @host.input_string()

  // Config
  let _ = @config.get("test")

  // Vars
  @var.set_string("test_var", "something")
  let test_var = @var.get_string("test_var")
  if test_var != Some("something") {
    @host.log_error_str("Invalid test_var")
  }

  // HTTP
  let req = @http.new_request(@http.Method::GET, "https://extism.org")
  let resp = req.send()
  if resp.status_code != 200 {
    @host.log_error_str("Invalid HTTP status code")
  }

  // Logging
  @host.log_info_str("INFO")
  @host.log_debug_str("DEBUG")
  @host.log_warn_str("WARN")
  @host.log_error_str("ERROR")

  // Output
  @host.output_string(input)
  return 0
}
