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
    json_body.should match({
      "Khassar de templari!" => String,
      "Adun Toridas!"        => "Adun hide you",
      "Nahda gahla"          => Nil,
    })
  end
end

json = JSON.parse(%({"array":[1,2,3],"number":1,"float_number":1.5,"string":"str","null":null,"hash":{"a":1}}))

describe "contain with JSON::Any" do
  it "checks whether json contains the values or types" do
    json.should contain({
      "array"  => Array,
      "number" => 1,
      "hash"   => {"a" => Int64},
    })
  end
end

describe "match with JSON::Any" do
  it "checks whether json matches the values or types" do
    json.should match({
      "array"        => [1, 2, 3],
      "number"       => Int64,
      "float_number" => 1.5,
      "string"       => String,
      "null"         => nil,
      "hash"         => Hash,
    })
  end
end
