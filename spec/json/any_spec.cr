require "./spec_helper"

describe JSON::Any do
  describe "#includes?" do
    json = JSON.parse(%({"array":[1,2,3],"number":1,"float_number":1.5,"string":"str","null":null,"hash":{"a":1}}))

    it "checks whether the object is included in the json" do
      json.should contain({
        "array"        => [1, 2, 3],
        "number"       => 1,
        "float_number" => 1.5,
        "string"       => "str",
        "null"         => nil,
        "hash"         => {
          "a" => 1,
        },
      })
      json.should_not contain({"array" => [1, 2]})
    end

    it "checks the types in the json" do
      json.should contain({
        "array"        => Array,
        "number"       => Int64,
        "float_number" => Float64,
        "string"       => String,
        "null"         => Nil,
        "hash"         => Hash,
      })
      json.should contain({"hash" => {"a" => Int64}})
      json.should_not contain({"array" => Hash})
    end
  end
end
