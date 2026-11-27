///|
test "VowelReport::to_json works as expected" {
  let vowel_report : @cv.VowelReport = {
    count: 1,
    total: 2,
    vowels: "some string",
  }
  let got = vowel_report.to_json().stringify()
  let want =
    #|{"count":1,"total":2,"vowels":"some string"}
  inspect(got, content=want)
  inspect(
    vowel_report,
    content=(
      #|{count: 1, total: 2, vowels: "some string"}
    ),
  )
}
