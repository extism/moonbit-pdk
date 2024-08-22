/// `AllThree` represents a JSON object with all three array types.
pub struct AllThree {
  ints : Array[Int]
  floats : Array[Double]
  strings : Array[String]
} derive(Eq, Show, ToJson)

/// `process_all_three` processes all three array types.
pub fn process_all_three(all3 : AllThree) -> AllThree {
  {
    ints: process_ints(all3.ints),
    floats: process_floats(all3.floats),
    strings: process_strings(all3.strings),
  }
}

test "AllThree::to_json works as expected" {
  let all3 = { ints: [1, 2, 3], floats: [1, 2, 3], strings: ["1", "2", "3"] }
  let got = all3.to_json().stringify()
  // See: https://github.com/moonbitlang/core/issues/878
  // for trailing ".0" on the integers.
  let want =
    #|{"ints":[1.0,2.0,3.0],"floats":[1.0,2.0,3.0],"strings":["1","2","3"]}
  assert_eq!(got, want)
}
