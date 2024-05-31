// ───────┬─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
//        │ File: lib.rs
// ───────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
//    1   │ use extism_pdk::*;
//    2   │ use serde::Serialize;
//    3   │
//    4   │ const VOWELS: &str = "aeiouAEIOU";
//    5   │
//    6   │ #[derive(Serialize)]
//    7   │ struct VowelReport {
//    8   │     pub count: u32,
//    9   │     pub total: u32,
//   10   │     pub vowels: String,
//   11   │ }
//   12   │
//   13   │ fn get_total() -> u32 {
//   14   │     match var::get::<String>("total") {
//   15   │         Ok(Some(v)) => v.parse::<u32>().ok().unwrap(),
//   16   │         Ok(None) => 0u32,
//   17   │         Err(_) => panic!("Couldn't access extism variable 'total'"),
//   18   │     }
//   19   │ }
//   20   │
//   21   │ fn store_total(total: u32) {
//   22   │     var::set("total", total.to_string()).ok();
//   23   │ }
//   24   │
//   25   │ fn get_vowels() -> String {
//   26   │     match config::get("vowels") {
//   27   │         Ok(Some(v)) => v,
//   28   │         _ => VOWELS.to_string(),
//   29   │     }
//   30   │ }
//   31   │
//   32   │ #[plugin_fn]
//   33   │ pub fn count_vowels(input: String) -> FnResult<Json<VowelReport>> {
//   34   │     let mut count = 0;
//   35   │     let vowels = get_vowels();
//   36   │     for ch in input.chars() {
//   37   │         if vowels.contains(ch) {
//   38   │             count += 1;
//   39   │         }
//   40   │     }
//   41   │
//   42   │     let mut total = get_total();
//   43   │     total += count;
//   44   │     store_total(total);
//   45   │
//   46   │     let output = VowelReport {
//   47   │         count,
//   48   │         total,
//   49   │         vowels,
//   50   │     };
//   51   │
//   52   │     Ok(Json(output))
//   53   │ }

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
  match @pdk.Var::get("total") {
    Ok(Some(v)) => v
    Ok(None) => 0
    Err(_) => abort("Couldn't access extism variable 'total'")
  }
}

fn store_total(total : Int) -> Unit {
  @pdk.Var::set("total", total)
}

fn get_vowels() -> String {
  match @pdk.Config::get("vowels") {
    Ok(Some(v)) => v
    _ => vowels
  }
}

pub fn count_vowels() -> Int {
  // let input = @pdk.Host::input()
  let input = "World"
  //
  let vowels = get_vowels()
  let vowels_arr = vowels.to_array()
  let count = input.as_iter().filter(fn(ch) { vowels_arr.contains(ch) }).count()
  //
  let mut total = get_total()
  total += count
  store_total(total)
  //
  let output = { count, total, vowels }
  let j = @jsonutil.to_json(output)
  let s = @jsonutil.stringify(j, spaces=0, newline=false)
  @pdk.Host::outputString(s)
  return 0
}
