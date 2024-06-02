let vowels = "aeiouAEIOU"

pub struct VowelReport {
  count : Int
  total : Int
  vowels : String
}

impl @jsonutil.ToJson for VowelReport with to_json(self) {
  @jsonutil.from_entries(
    [("count", self.count), ("total", self.total), ("vowels", self.vowels)],
  )
}

fn get_total() -> Int {
  match @pdk.Var::get_int("total") {
    Some(total) => total
    None => 0
  }
}

fn store_total(total : Int) -> Unit {
  @pdk.Var::set_int("total", total)
}

fn get_vowels() -> String {
  match @pdk.Config::get("vowels") {
    Some(s) => s
    _ => vowels
  }
}

pub fn count_vowels() -> Int {
  let input = @pdk.Host::input_string()
  //
  let vowels = get_vowels()
  let vowels_arr = vowels.to_array()
  let count = input.as_iter().filter(fn(ch) { vowels_arr.contains(ch) }).count()
  //
  let mut total = get_total()
  total += count
  store_total(total)
  //
  { count: 1, total: 2, vowels: "I got: input=\(input)" }
  |> @jsonutil.to_json()
  |> @pdk.Host::output_json_value()
  0 // success
}
