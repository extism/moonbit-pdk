test "to_json" {
  let vr = { count: 1, total: 2, vowels: "some string" }
  let jv = @jsonutil.to_json(vr)
  let got = @jsonutil.stringify(jv, spaces=0, newline=false)
  let want = "{count:1,total:2,vowels:\"some string\"}"
  @assertion.assert_eq(got, want)?
}
