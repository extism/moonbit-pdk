///| `process_ints` sums up an array of ints.
pub fn process_ints(ints : Array[Int]) -> Array[Int] {
  let mut sum = 0
  ints.eachi(
    fn(index, value) {
      sum += value
      ints[index] = sum
    },
  )
  ints
}
