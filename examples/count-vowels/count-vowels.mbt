///|
/// `default_vowels` represents the default set of vowels
/// if the host provides no "config.vowels" string.
let default_vowels = "aeiouAEIOU"

///|
/// `VowelReport` represents the JSON struct returned to the host.
pub(all) struct VowelReport {
  count : Int
  total : Int
  vowels : String
} derive(Show, Eq, ToJson)

///|
fn get_total() -> Int {
  @var.get_int("total").unwrap_or_default()
}

///|
fn store_total(total : Int) -> Unit {
  @var.set_int("total", total)
}

///|
fn get_vowels() -> String {
  @config.get("vowels").unwrap_or(default_vowels)
}

///|
/// `count_vowels` reads the input string from the host, reads the "vowels"
/// config from the host, then counts the number of vowels in the input
/// string and keeps a running total (over multiple iterations)
/// in the host's "total" var.
/// It sends the JSON `VowelReport` to the host via its output data channel.
/// It returns 0 to the host on success.
pub fn count_vowels() -> Int {
  let input = @host.input_string()
  //
  let vowels = get_vowels()
  let vowels_arr = vowels.to_array()
  let count = input.iter().filter(fn(ch) { vowels_arr.contains(ch) }).count()
  //
  let total = get_total() + count
  store_total(total)
  //
  { count, total, vowels }.to_json() |> @host.output_json_value()
  0 // success
}

///|
test "VowelReport::to_json works as expected" {
  let vowel_report = { count: 1, total: 2, vowels: "some string" }
  let got = vowel_report.to_json().stringify()
  let want =
    #|{"count":1,"total":2,"vowels":"some string"}
  assert_eq(got, want)
}
