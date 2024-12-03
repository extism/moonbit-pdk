///|
struct Add {
  a : Int
  b : Int
}

///|
pub fn Add::from_json(value : Json) -> Add? {
  // From: https://github.com/moonbitlang/core/issues/892#issuecomment-2306068783
  match value {
    { "a": Number(a), "b": Number(b) } => Some({ a: a.to_int(), b: b.to_int() })
    _ => None
  }
}

///|
type! ParseError String derive(Show)

///|
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

///|
struct Sum {
  sum : Int
} derive(ToJson)

///|
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

test "Sum::to_json works as expected" {
  let sum = { sum: 42 }
  let got = sum.to_json().stringify()
  let want =
    #|{"sum":42}
  assert_eq!(got, want)
}
