pub fn http_get() -> Int {
  // create an HTTP Request (without relying on WASI), set headers as needed
  let req = @http.new_request(
    @http.Method::GET,
    "https://jsonplaceholder.typicode.com/todos/1",
  )
  req.header.add("some-name", "some-value")
  req.header.add("another", "again")
  // send the request, get response back (can check status on response via res.status())
  let res = req.send()

  // send output to host
  res.output()
  return 0 // success
}
