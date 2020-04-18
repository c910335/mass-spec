require "./spec_helper"

describe JSON::Any do
  json = JSON.parse(%({"array":[1,2,3],"number":1,"float_number":1.5,"string":"str","null":null,"hash":{"a":1}}))

  describe "#includes?" do
    it "checks whether json contains the object" do
      json.should contain({
        "array"        => [1, 2, 3],
        "float_number" => 1.5,
        "string"       => "str",
        "hash"         => {
          "a" => 1,
        },
      })
      json.should_not contain({"foo" => "bar"})
    end

    it "checks whether json contains the types of the object" do
      json.should contain({
        "array"  => Array,
        "number" => Int64,
        "null"   => Nil,
        "hash"   => Hash,
      })
      json.should contain({"hash" => {"a" => Int64}})
      json.should_not contain({"array" => Hash})
    end
  end

  describe "#=~" do
    it "checks whether json matches the object" do
      json.should match({
        "array"        => [1, 2, 3],
        "number"       => 1,
        "float_number" => 1.5,
        "string"       => "str",
        "null"         => nil,
        "hash"         => {
          "a" => 1,
        },
      })
      json.should_not match({
        "array"        => [1, 2, 3],
        "float_number" => 1.5,
        "string"       => "str",
        "hash"         => {
          "a" => 1,
        },
      })
      json.should_not match({
        "array"        => [1, 3],
        "number"       => 2,
        "float_number" => 1.5,
        "string"       => "str",
        "null"         => nil,
        "hash"         => {
          "a" => 2,
        },
      })
      json.should_not match({
        "array"        => [1, 2, 3],
        "number"       => 1,
        "float_number" => 1.5,
        "string"       => "str",
        "null"         => nil,
        "hash"         => {
          "a" => 1,
        },
        "boolean" => true,
      })
    end

    it "checks whether json matches the types of the object" do
      json.should match({
        "array"        => Array,
        "number"       => Int64,
        "float_number" => Float64,
        "string"       => String,
        "null"         => Nil,
        "hash"         => Hash,
      })
      json.should_not match({
        "array"  => Array,
        "number" => Int64,
        "null"   => Nil,
        "hash"   => Hash,
      })
      json.should_not match({
        "array"        => Array,
        "number"       => Float64,
        "float_number" => Int64,
        "string"       => String,
        "null"         => Nil,
        "hash"         => Hash,
      })
      json.should_not match({
        "array"        => Array,
        "number"       => Int64,
        "float_number" => Float64,
        "string"       => String,
        "null"         => Nil,
        "hash"         => Hash,
        "boolean"      => Bool,
      })
    end
  end
end
