///|
test "AllThree::to_json works as expected" {
  let all3 : @arrays.AllThree = {
    ints: [1, 2, 3],
    floats: [1, 2, 3],
    strings: ["1", "2", "3"],
  }
  let got = all3.to_json().stringify()
  @debug.debug_inspect(
    got,
    content=(
      #|"{\"ints\":[1,2,3],\"floats\":[1,2,3],\"strings\":[\"1\",\"2\",\"3\"]}"
    ),
  )
  @debug.debug_inspect(
    all3,
    content=(
      #|{ ints: [1, 2, 3], floats: [1, 2, 3], strings: ["1", "2", "3"] }
    ),
  )
}
