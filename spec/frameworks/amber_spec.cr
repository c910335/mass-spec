require "./spec_helper"

describe HelloController do
  describe "GET #hello" do
    it "says hello to Amber" do
      with_amber
      get "/hello"

      json_body.should eq({"hello" => "amber"})
    end
  end
end
