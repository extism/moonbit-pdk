pub fn greet() -> Int {
  let input = @pdk.Host::inputString()
  let greeting = "Hello, \(input)!"
  @pdk.Host::outputString(greeting)
  return 0
}
