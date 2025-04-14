///|
/// `http_get` makes a GET HTTP request through the Extism host, gets
/// the response back, then sends it (unmodified) to the Extism host output.
/// It returns 0 to the host on success.
pub fn http_get() -> Int {
  // create an HTTP Request (without relying on WASI), set headers as needed
  let req = @http.new_request(
    @http.Method::GET,
    "https://jsonplaceholder.typicode.com/todos/1",
  )
  req.header.set("some-name", "some-value")
  req.header.set("another", "again")
  // send the request, get response back
  let res = req.send()

  // zero-copy send output to host
  res.output()
  0 // success
}
