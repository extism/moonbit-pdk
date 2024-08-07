/// `greet` reads the input string from the host and writes a
/// greeting to the host's output string.
/// It returns 0 to the host on success.
pub fn greet() -> Int {
  let input = @host.input_string()
  let greeting = "Hello, \{input}!"
  @host.output_string(greeting)
  0 // success
}
