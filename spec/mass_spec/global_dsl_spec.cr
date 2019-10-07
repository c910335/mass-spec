require "./spec_helper"

describe MassSpec::GlobalDSL do
  {% for method in %w(get head post put patch delete) %}
  describe "#" + "{{method.id}}" do
    it "performs an HTTP {{method.id.upcase}}" do
      with_path_method_server
      {{method.id}} "/{{method.id}}"

      headers.should contain({"X-HTTP-Method", [{{method.upcase}}]})
    end
  end
  {% end %}

  describe "#response" do
    it "gets the response of the previous request" do
      with_path_method_server
      get "/response"

      response.should be_a(HTTP::Client::Response)
      response.body.should eq(%({"path":"/response","method":"GET"}))
    end
  end

  describe "#headers" do
    it "gets the response headers of the previous request" do
      with_path_method_server
      get "/headers"

      headers.should be_a(HTTP::Headers)
      headers.should contain({"X-HTTP-Method", ["GET"]})
    end
  end

  describe "#status_code" do
    it "gets the status code of the previous request" do
      with_path_method_server
      get "/status/code"

      status_code.should eq(200)
    end
  end

  describe "#body" do
    it "gets the response body of the previous request" do
      with_path_method_server
      get "/body"

      body.should eq(%({"path":"/body","method":"GET"}))
    end
  end

  describe "#json_body" do
    it "gets the parsed response body of the previous request" do
      with_path_method_server
      get "/json_body"

      json_body.should eq({"path" => "/json_body", "method" => "GET"})
    end
  end
end
