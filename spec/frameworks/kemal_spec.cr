ENV["KEMAL_ENV"] = "test"
require "spec"
require "../../src/mass_spec"
require "../support/kemal_server"
include MassSpec::GlobalDSL

Kemal.run do |config|
  MassSpec.server = config.server.not_nil! # ameba:disable Lint/NotNil
end

describe "GET /hello" do
  it "says hello to Kemal" do
    get "/hello"

    json_body.should eq({"hello" => "kemal"})
  end
end
