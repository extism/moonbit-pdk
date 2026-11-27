///|
#derive(FromJson)
priv struct Add {
  a : Int32
  b : Int32
}

///|
#derive(ToJson)
pub(all) struct Sum {
  sum : Int32
}

///|
#export_name("add")
pub fn add() -> Int32 {
  let input = @host.input_string()
  let params : Add = @json.from_json(@json.parse(input)) catch {
    e => {
      @host.set_error(e.to_string())
      return 1
    }
  }
  //
  let sum = { sum: params.a + params.b, }
  @host.output_json_value(ToJson::to_json(sum))
  0 // success
}
