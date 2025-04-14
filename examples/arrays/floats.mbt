///|
/// `process_floats` sums up an array of floats.
pub fn process_floats(floats : Array[Double]) -> Array[Double] {
  let mut sum = 0.0
  floats.eachi(fn(index, value) {
    sum += value
    floats[index] = sum
  })
  floats
}
