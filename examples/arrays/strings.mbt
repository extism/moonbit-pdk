/// `process_strings` concatenates an array of strings.
pub fn process_strings(strings : Array[String]) -> Array[String] {
  let parts = []
  strings.eachi(
    fn(index, value) {
      parts.push(value)
      // strings[index] = parts.join("|")
      // Yuck! https://github.com/moonbitlang/core/pull/993
      strings[index] = String::concat(parts, separator="|")
    },
  )
  strings
}
