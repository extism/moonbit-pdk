///|
/// `AllThree` represents a JSON object with all three array types.
#derive(Debug, Eq, ToJson)
pub(all) struct AllThree {
  ints : Array[Int32]
  floats : Array[Double]
  strings : Array[String]
}

///|
pub extend AllThree with Eq::{equal}

///|
#deprecated("Use `!=` instead", skip_current_package=true)
#doc(hidden)
pub extend AllThree with Eq::{not_equal}

///|
pub extend AllThree with ToJson::{to_json}

///|
#deprecated("Use `@debug.Debug::to_repr` via the trait instead", skip_current_package=true)
#doc(hidden)
pub extend AllThree with @debug.Debug::{to_repr}

///|
/// `process_all_three` processes all three array types.
pub fn process_all_three(all3 : AllThree) -> AllThree {
  {
    ints: process_ints(all3.ints),
    floats: process_floats(all3.floats),
    strings: process_strings(all3.strings),
  }
}
