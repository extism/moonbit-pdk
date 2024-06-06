pub fn greet() -> Int {
  let input = @host.input_string()
  let greeting = "Hello, \(input)!"
  @host.output_string(greeting)
  0 // success
}
