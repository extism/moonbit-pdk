///|
test "Method::to_json works as expected" {
  let got = @http.GET.to_json().stringify()
  let want =
    #|"GET"
  inspect(got, content=want)
}
