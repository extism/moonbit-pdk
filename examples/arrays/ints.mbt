///|
/// `process_ints` sums up an array of ints.
pub fn process_ints(ints : Array[Int32]) -> Array[Int32] {
  let mut sum = 0
  ints.eachi(fn(index, value) {
    sum += value
    ints[index] = sum
  })
  ints
}
