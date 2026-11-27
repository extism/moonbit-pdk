///|
test "Sum::to_json works as expected" {
  let sum : @add.Sum = { sum: 42, }
  let got = @json.ToJson::to_json(sum).stringify()
  let want =
    #|{"sum":42}
  inspect(got, content=want)
}
