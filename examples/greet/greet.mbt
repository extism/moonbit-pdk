pub fn greet() -> Int {
  let input = @pdk.Host::input_string()
  let greeting = "Hello, \(input)!"
  @pdk.Host::output_string(greeting)
  return 0
}
