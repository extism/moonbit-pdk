pub fn greet() -> Int {
  let input = @pdk.Host::input()
  let greeting = "Hello, \(input)!"
  @pdk.Host::outputString(greeting)
  return 0
}
