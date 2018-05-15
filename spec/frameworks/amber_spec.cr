ENV["AMBER_ENV"] = "test"
require "spec"
require "../../src/mass_spec"
include MassSpec::GlobalDSL
require "amber"

class HelloController < Amber::Controller::Base
  def hello
    respond_with { json({"hello" => "amber"}) }
  end
end

Amber::Server.configure do
  routes :web do
    get "/hello", HelloController, :hello
  end
end

Amber::Server.start

describe HelloController do
  describe "GET #hello" do
    it "says hello to Amber" do
      get "/hello"

      json_body.should eq({"hello" => "amber"})
    end
  end
end
