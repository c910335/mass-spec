require "./spec_helper"

server = HTTP::Server.new do |context|
  context.response.content_type = "application/json"
  context.response.print({headers: context.request.headers}.to_json)
end

server.listen

describe MassSpec::Client do
  describe "#headers" do
    it "adds headers to configuration" do
      MassSpec.configure { headers({"a" => "1", "b" => "2"}) }
      get "/"

      MassSpec::Client.instance.headers.should eq(HTTP::Headers{"a" => "1", "b" => "2"})
      json_body.as_h["headers"].as_h.should contain({"a", "1"})
      json_body.as_h["headers"].as_h.should contain({"b", "2"})
    end
  end
end
