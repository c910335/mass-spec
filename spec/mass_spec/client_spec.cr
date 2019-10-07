require "./spec_helper"

describe MassSpec::Client do
  describe "#headers" do
    it "adds headers to configuration" do
      with_headers_server
      MassSpec.configure { headers({"a" => "1", "b" => "2"}) }
      get "/"

      MassSpec::Client.instance.headers.should eq(HTTP::Headers{"a" => "1", "b" => "2"})
      json_body.as_h["headers"].as_h.should contain({"a", "1"})
      json_body.as_h["headers"].as_h.should contain({"b", "2"})
    end
  end
end
