struct Add {
  a : Int
  b : Int
}

pub fn Add::from_json(value : @json.JsonValue) -> Add? {
  let value = match value.as_object() {
    Some(v) => v
    _ => return None
  }
  let a = match value.get("a") {
    Some(v) => v
    _ => return None
  }
  let a = a.as_number()
  let b = match value.get("b") {
    Some(v) => v
    _ => return None
  }
  let b = b.as_number()
  match (a, b) {
    (Some(a), Some(b)) => Some({ a: a.to_int(), b: b.to_int() })
    _ => None
  }
}

type! ParseError String derive(Show)

pub fn Add::parse(s : String) -> Add!ParseError {
  match @json.parse?(s) {
    Ok(jv) =>
      match Add::from_json(jv) {
        Some(value) => value
        None => raise ParseError("unable to parse Add \{s}")
      }
    Err(e) => raise ParseError("unable to parse Add \{s}: \{e}")
  }
}

struct Sum {
  sum : Int
}

pub fn to_json(self : Sum) -> Json {
  { "sum": self.sum.to_json() }
}

pub fn add() -> Int {
  let input = @host.input_string()
  let params = try {
    Add::parse!(input)
  } catch {
    ParseError(e) => {
      @host.set_error(e)
      return 1
    }
  }
  //
  let sum = { sum: params.a + params.b }
  let json_value = sum.to_json()
  @host.output_json_value(json_value)
  0 // success
}
