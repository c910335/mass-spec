require "./spec_helper"

describe MassSpec::Client do
  describe "#headers" do
    it "adds headers to configuration" do
      with_headers_server
      MassSpec.configure { headers({"Authorization" => "Bearer some_access_token"}) }
      get "/"

      MassSpec::Client.instance.headers.should eq(HTTP::Headers{"Authorization" => "Bearer some_access_token"})
      json_body.should contain({"headers" => {"Authorization" => "Bearer some_access_token"}})
    end
  end
end
