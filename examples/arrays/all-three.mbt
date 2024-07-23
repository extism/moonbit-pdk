/// `AllThree` represents a JSON object with all three array types.
pub struct AllThree {
  ints : Array[Int]
  floats : Array[Double]
  strings : Array[String]
} derive(Eq, Show)

pub impl @jsonutil.ToJson for AllThree with to_json(self) {
  let fields : Array[(String, @jsonutil.ToJson)] = [
    ("ints", self.ints),
    ("floats", self.floats),
    ("strings", self.strings),
  ]
  @jsonutil.from_entries(fields)
}

/// `process_all_three` processes all three array types.
pub fn process_all_three(in : AllThree) -> AllThree {
  {
    ints: process_ints(in.ints),
    floats: process_floats(in.floats),
    strings: process_strings(in.strings),
  }
}
