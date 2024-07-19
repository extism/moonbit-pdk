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
  let mut sum = 0
  ints.eachi(
    fn(index, value) {
      sum += value
      ints[index] = sum
    },
  )
  //
  let jv = @jsonutil.to_json(ints)
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
  let mut sum = 0.0
  floats.eachi(
    fn(index, value) {
      sum += value
      floats[index] = sum
    },
  )
  //
  let jv = @jsonutil.to_json(floats)
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
  let parts = []
  strings.eachi(
    fn(index, value) {
      parts.push(value)
      strings[index] = parts.join("|")
    },
  )
  //
  let jv = @jsonutil.to_json(strings)
  @host.output_json_value(jv)
  0 // success
}
