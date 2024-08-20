/// `AllThree` represents a JSON object with all three array types.
pub struct AllThree {
  ints : Array[Int]
  floats : Array[Double]
  strings : Array[String]
} derive(Eq, Show)

fn array_to_json[T](arr : Array[T], ~f : (T) -> Json) -> Json {
  Array(arr.map(f))
}

fn to_json(self : AllThree) -> Json {
  let { ints, floats, strings } = self
  {
    "ints": ints |> array_to_json(f=fn { x => Number(x.to_double()) }),
    "floats": floats |> array_to_json(f=fn { x => Number(x) }),
    "strings": strings |> array_to_json(f=fn { x => String(x) }),
  }
}

/// `process_all_three` processes all three array types.
pub fn process_all_three(all3 : AllThree) -> AllThree {
  {
    ints: process_ints(all3.ints),
    floats: process_floats(all3.floats),
    strings: process_strings(all3.strings),
  }
}
