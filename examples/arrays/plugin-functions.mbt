///|
/// `progressive_sum_ints` tests passing arrays of ints.
pub fn progressive_sum_ints() -> Int {
  let s = @host.input_string()
  let jv = @json.parse(s) catch {
    e => {
      @host.set_error("unable to parse input: \{e}")
      return 1 // failure
    }
  }
  //
  let ints = match as_array(jv) {
    Some(arr) => arr.map(fn(jv) { as_number(jv).unwrap().to_int() })
    _ => {
      @host.set_error("could not parse array")
      return 1 // failure
    }
  }
  //
  let result = process_ints(ints)
  //
  let jv = result.to_json()
  @host.output_json_value(jv)
  0 // success
}

///|
/// `progressive_sum_floats` tests passing arrays of floats.
pub fn progressive_sum_floats() -> Int {
  let s = @host.input_string()
  let jv = @json.parse(s) catch {
    e => {
      @host.set_error("unable to parse input: \{e}")
      return 1 // failure
    }
  }
  //
  let floats = match as_array(jv) {
    Some(arr) => arr.map(fn(jv) { as_number(jv).unwrap() })
    _ => {
      @host.set_error("could not parse array")
      return 1 // failure
    }
  }
  //
  let result = process_floats(floats)
  //
  let jv = result.to_json()
  @host.output_json_value(jv)
  0 // success
}

///|
/// `progressive_concat_strings` tests passing arrays of strings.
pub fn progressive_concat_strings() -> Int {
  let s = @host.input_string()
  let jv = @json.parse(s) catch {
    e => {
      @host.set_error("unable to parse input: \{e}")
      return 1 // failure
    }
  }
  //
  let strings = match as_array(jv) {
    Some(arr) => arr.map(fn(jv) { as_string(jv).unwrap() })
    _ => {
      @host.set_error("could not parse array")
      return 1 // failure
    }
  }
  //
  let result = process_strings(strings)
  //
  let jv = result.to_json()
  @host.output_json_value(jv)
  0 // success
}

///|
/// `all_three_object` tests passing an object of all three arrays.
pub fn all_three_object() -> Int {
  let s = @host.input_string()
  let jv = @json.parse(s) catch {
    e => {
      @host.set_error("unable to parse input: \{e}")
      return 1 // failure
    }
  }
  //
  let all_three : AllThree = match jv {
    Object(
      {
        "ints": Array(ints),
        "floats": Array(floats),
        "strings": Array(strings),
        ..
      }
    ) => {
      let ints : Array[Int] = ints
        .map(fn(n) { as_number(n) })
        .filter(fn(n) { not(n is None) })
        .map(fn(n) { n.unwrap().to_int() })
      let floats : Array[Double] = floats
        .map(fn(n) { as_number(n) })
        .filter(fn(n) { not(n is None) })
        .map(fn(n) { n.unwrap() })
      let strings : Array[String] = strings
        .map(fn(n) { as_string(n) })
        .filter(fn(n) { not(n is None) })
        .map(fn(n) { n.unwrap() })
      { ints, floats, strings }
    }
    _ => {
      @host.set_error("unable to parse input: \{s}")
      return 1 // failure
    }
  }
  //
  let result = process_all_three(all_three)
  //
  let jv = result.to_json()
  @host.output_json_value(jv)
  0 // success
}

///|
fn as_array(json : Json) -> Array[Json]? {
  if json is Array(vs) {
    Some(vs)
  } else {
    None
  }
}

///|
fn as_number(json : Json) -> Double? {
  if json is Number(n, ..) {
    Some(n)
  } else {
    None
  }
}

///|
fn as_string(json : Json) -> String? {
  if json is String(s) {
    Some(s)
  } else {
    None
  }
}
