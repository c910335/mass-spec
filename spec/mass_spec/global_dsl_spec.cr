require "./spec_helper"

server = HTTP::Server.new(8080) do |context|
  context.response.content_type = "application/json"
  context.response.headers["X-HTTP-Method"] = context.request.method
  context.response.print({path: context.request.path, method: context.request.method}.to_json)
end

server.listen

describe MassSpec::GlobalDSL do
  {% for method in %w(get head post put patch delete) %}
  describe "{{method.id}}" do
    it "performs an HTTP {{method.id.upcase}}" do
      {{method.id}} "/{{method.id}}"

      headers.should contain({"X-HTTP-Method", [{{method.upcase}}]})
    end
  end
  {% end %}

  describe "response" do
    it "gets the response of the previous request" do
      get "/response"

      response.should be_a(HTTP::Client::Response)
      response.body.should eq(%({"path":"/response","method":"GET"}))
    end
  end

  describe "headers" do
    it "gets the response headers of the previous request" do
      get "/headers"

      headers.should be_a(HTTP::Headers)
      headers.should contain({"X-HTTP-Method", ["GET"]})
    end
  end

  describe "status_code" do
    it "gets the status code of the previous request" do
      get "/status/code"

      status_code.should eq(200)
    end
  end

  describe "body" do
    it "gets the response body of the previous request" do
      get "/body"

      body.should eq(%({"path":"/body","method":"GET"}))
    end
  end

  describe "json_body" do
    it "gets the parsed response body of the previous request" do
      get "/json_body"

      json_body.should eq({"path" => "/json_body", "method" => "GET"})
    end
  end
end
