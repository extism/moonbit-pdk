///|
/// `Request` represents an HTTP request made by the Extism host.
pub(all) struct Request {
  http_method : Method
  header : Header
  url : String
} derive(ToJson)

///|
/// `Response` represents an HTTP response from the Extism host.
pub(all) struct Response {
  status_code : Int
  body : @host.Memory
}

///|
/// `new_request` returns a new `Request` using the provided
/// `method` and `url`.
pub fn new_request(http_method : Method, url : String) -> Request {
  let header = Header::new()
  { http_method, header, url }
}

///|
/// `send` sends the `Request` to the host, waits for a response,
/// and returns it to the caller.
/// Note that the (optional) `body` is freed by this call.
pub fn send(self : Request, body~ : @host.Memory? = None) -> Response {
  let meta_mem = self.to_json() |> @host.allocate_json_value()
  let body_memory_offset = match body {
    Some(v) => v.offset
    None => 0L
  }
  //
  let response_offset = @extism.http_request(
    meta_mem.offset,
    body_memory_offset,
  )
  let response_length = @extism.length(response_offset)
  let status_code = @extism.http_status_code()
  //
  meta_mem.free()
  match body {
    Some(body_mem) => body_mem.free()
    None => ()
  }
  //
  let response_body : @host.Memory = {
    offset: response_offset,
    length: response_length,
  }
  { status_code, body: response_body }
}

///|
/// `output` sends the (unprocessed) `Response` body to the Extism host "output".
pub fn output(self : Response) -> Unit {
  @host.output_memory(self.body)
}

///|
test "Request::to_json works as expected" {
  let request = {
    http_method: GET,
    header: { "key1": "one", "key2": "two" },
    url: "https://example.com",
  }
  let got = request.to_json().stringify(escape_slash=false)
  let want =
    #|{"http_method":"GET","header":{"key1":"one","key2":"two"},"url":"https://example.com"}
  assert_eq!(got, want)
}

///|
test "Json::stringify works on strings" {
  let url = "https://example.com"
  let got = url.to_json().stringify(escape_slash=false)
  let want =
    #|"https://example.com"
  assert_eq!(got, want)
}
