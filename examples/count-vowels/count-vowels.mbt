let default_vowels = "aeiouAEIOU"

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
  match @var.get_int("total") {
    Some(total) => total
    None => 0
  }
}

fn store_total(total : Int) -> Unit {
  @var.set_int("total", total)
}

fn get_vowels() -> String {
  match @config.get("vowels") {
    Some(s) => s
    None => default_vowels
  }
}

pub fn count_vowels() -> Int {
  let input = @host.input_string()
  //
  let vowels = get_vowels()
  let vowels_arr = vowels.to_array()
  let count = input.as_iter().filter(fn(ch) { vowels_arr.contains(ch) }).count()
  //
  let total = get_total() + count
  store_total(total)
  //
  { count, total, vowels } |> @jsonutil.to_json() |> @host.output_json_value()
  0 // success
}
