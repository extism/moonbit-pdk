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
    Some(s) => {
      @pdk.Host::log_debug_str("get_vowels: host returned vowels: \(s)")
      s
    }
    None => {
      // defining default_vowels in the global scope causes problems with Extism.
      let default_vowels = "aeiouAEIOU"
      @pdk.Host::log_debug_str(
        "get_vowels: defaulting to built-in vowels: \(default_vowels)",
      )
      default_vowels
    }
  }
}

pub fn count_vowels() -> Int {
  @pdk.Host::log_debug_str("ENTER count_vowels")
  //
  let input = @pdk.Host::input_string()
  @pdk.Host::log_debug_str("count_vowels: input=\(input)")
  //
  let vowels = get_vowels()
  @pdk.Host::log_debug_str("count_vowels: vowels=\(vowels)")
  let vowels_arr = vowels.to_array()
  // println("count_vowels: vowels_arr=\(vowels_arr)")
  let count = input.as_iter().filter(fn(ch) { vowels_arr.contains(ch) }).count()
  //
  let mut total = get_total()
  total += count
  store_total(total)
  //
  { count, total, vowels }
  |> @jsonutil.to_json()
  |> @pdk.Host::output_json_value()
  0 // success
}
