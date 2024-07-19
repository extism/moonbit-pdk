/// `progressive_sum_ints` tests passing arrays of ints.
pub fn progressive_sum_ints() -> Int {
  let s = @host.input_string()
  let jv = try {
    @json.parse!(s)
  } catch {
    e => {
      @host.set_error("unable to parse input: \(e)")
      return 1 // failure
    }
  }
  //
  let ints = match jv.as_array() {
    Some(arr) => arr.map(fn(jv) { jv.as_number().unwrap().to_int() })
    _ => {
      @host.set_error("could not parse array")
      return 1 // failure
    }
  }
  //
  let result = process_ints(ints)
  //
  let jv = @jsonutil.to_json(result)
  @host.output_json_value(jv)
  0 // success
}

/// `progressive_sum_floats` tests passing arrays of floats.
pub fn progressive_sum_floats() -> Int {
  let s = @host.input_string()
  let jv = try {
    @json.parse!(s)
  } catch {
    e => {
      @host.set_error("unable to parse input: \(e)")
      return 1 // failure
    }
  }
  //
  let floats = match jv.as_array() {
    Some(arr) => arr.map(fn(jv) { jv.as_number().unwrap() })
    _ => {
      @host.set_error("could not parse array")
      return 1 // failure
    }
  }
  //
  let result = process_floats(floats)
  //
  let jv = @jsonutil.to_json(result)
  @host.output_json_value(jv)
  0 // success
}

/// `progressive_concat_strings` tests passing arrays of strings.
pub fn progressive_concat_strings() -> Int {
  let s = @host.input_string()
  let jv = try {
    @json.parse!(s)
  } catch {
    e => {
      @host.set_error("unable to parse input: \(e)")
      return 1 // failure
    }
  }
  //
  let strings = match jv.as_array() {
    Some(arr) => arr.map(fn(jv) { jv.as_string().unwrap() })
    _ => {
      @host.set_error("could not parse array")
      return 1 // failure
    }
  }
  //
  let result = process_strings(strings)
  //
  let jv = @jsonutil.to_json(result)
  @host.output_json_value(jv)
  0 // success
}

/// `all_three_object` tests passing an object of all three arrays.
pub fn all_three_object() -> Int {
  let s = @host.input_string()
  let jv = try {
    @json.parse!(s)
  } catch {
    e => {
      @host.set_error("unable to parse input: \(e)")
      return 1 // failure
    }
  }
  //
  let all_three : AllThree = match jv {
    Object(
      {
        "ints": Some(Array(ints)),
        "floats": Some(Array(floats)),
        "strings": Some(Array(strings)),
      }
    ) => {
      let ints : Array[Int] = ints.map(fn { n => n.as_number() }).filter(
        fn { n => not(n.is_empty()) },
      ).map(fn { n => n.unwrap().to_int() })
      let floats : Array[Double] = floats.map(fn { n => n.as_number() }).filter(
        fn { n => not(n.is_empty()) },
      ).map(fn { n => n.unwrap() })
      let strings : Array[String] = strings.map(fn { n => n.as_string() }).filter(
        fn { n => not(n.is_empty()) },
      ).map(fn { n => n.unwrap() })
      { ints, floats, strings }
    }
    _ => {
      @host.set_error("unable to parse input: \(s)")
      return 1 // failure
    }
  }
  //
  let result = process_all_three(all_three)
  //
  let jv = @jsonutil.to_json(result)
  @host.output_json_value(jv)
  0 // success
}
