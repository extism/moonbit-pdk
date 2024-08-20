test "to_json" {
  let got = { count: 1, total: 2, vowels: "some string" }.to_json().stringify()
  // See: https://github.com/moonbitlang/core/issues/878
  // for trailing ".0" on the integers.
  let want =
    #|{"count":1.0,"total":2.0,"vowels":"some string"}
  assert_eq!(got, want)
}
