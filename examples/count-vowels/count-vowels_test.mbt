test "to_json" {
  let got = { count: 1, total: 2, vowels: "some string" }
    |> @jsonutil.to_json()
    |> @jsonutil.stringify(spaces=0, newline=false)
  let want =
    #|{"count":1,"total":2,"vowels":"some string"}
  @test.eq(got, want)!
}
