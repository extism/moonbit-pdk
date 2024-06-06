pub fn http_get() -> Int {
  // create an HTTP Request (withuot relying on WASI), set headers as needed
  let req = @pdk.new_http_request(
    @pdk.method_get, "https://jsonplaceholder.typicode.com/todos/1",
  )
  req.SetHeader("some-name", "some-value")
  req.SetHeader("another", "again")
  // send the request, get response back (can check status on response via res.Status())
  let res = req.Send()

  // zero-copy output to host
  @pdk.output_memory(res.memory())
  return 0
}
