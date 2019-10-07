require "./spec_helper"

describe "Server" do
  it "echoes in json" do
    with_echo_server
    post("/", body: {
      "Khassar de templari!" => "From order comes justice!",
      "Adun Toridas!"        => "Adun hide you",
      "Nahda gahla"          => nil,
    }.to_json)

    status_code.should eq(200)
    headers.should contain({"Content-Type", ["application/json"]})
    body.should eq(%({"Khassar de templari!":"From order comes justice!","Adun Toridas!":"Adun hide you","Nahda gahla":null}))
    json_body.should eq({
      "Khassar de templari!" => "From order comes justice!",
      "Adun Toridas!"        => "Adun hide you",
      "Nahda gahla"          => nil,
    })
    json_body.should contain({
      "Khassar de templari!" => "From order comes justice!",
      "Adun Toridas!"        => String,
    })
  end
end

describe "contain with JSON::Any" do
  it "checks values or types" do
    JSON.parse(%({"array":[1,2,3],"number":1,"float_number":1.5,"string":"str","null":null,"hash":{"a":1}}))
      .should contain({
      "array"        => Array,
      "number"       => 1,
      "float_number" => Float64,
      "string"       => "str",
      "null"         => nil,
      "hash"         => Hash,
    })
  end
end
