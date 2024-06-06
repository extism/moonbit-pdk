/// `Request` represents an HTTP request made by the Extism host.
pub struct Request {
  method : Method
  header : Header
  url : String
}

impl @jsonutil.ToJson for Request with to_json(self) {
  @jsonutil.from_entries(
    [("method", self.method), ("header", self.header), ("url", self.url)],
  )
}

/// `Response` represents an HTTP response from the Extism host.
pub struct Response {
  status_code : Int
  body : @host.Memory
}

/// `new_request` returns a new `Request` using the provided
/// `method` and `url`.
pub fn new_request(method : Method, url : String) -> Request {
  // let header : Header = Map::new()
  let header : Header = { map: Map::new() } // compiler workaround
  { method, header, url }
}

/// `send` sends the `Request` to the host, waits for a response,
/// and returns it to the caller.
pub fn send(self : Request) -> Response {
  let status_code = 0
  let body = "not implemented yet"
  { status_code, body }
}

/// `output` sends the `Response` to the Extism host "output" as a JSON blob.
pub fn output(self : Response) -> Unit {
  // TODO
}
