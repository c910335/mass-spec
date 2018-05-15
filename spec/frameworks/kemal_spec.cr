ENV["KEMAL_ENV"] = "test"
require "spec"
require "../../src/mass_spec"
require "kemal"

get "/hello" do
  {hello: "kemal"}.to_json
end

Kemal.run do |config|
  MassSpec.server = config.server.not_nil!
end

describe "GET /hello" do
  it "says hello to Kemal" do
    MassSpec.get "/hello"

    MassSpec.json_body.should eq({"hello" => "kemal"})
  end
end
