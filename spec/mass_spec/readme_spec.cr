require "./spec_helper"

server = HTTP::Server.new do |context|
  context.response.content_type = "application/json"
  context.response.print({path: context.request.path}.to_json)
end

server.listen

describe "Server" do
  it "returns the path in json" do
    get("/nas/beru/uhn'adarr")

    status_code.should eq(200)
    headers.should contain({"Content-Type", ["application/json"]})
    body.should eq(%({"path":"/nas/beru/uhn'adarr"}))
    json_body.should eq({"path" => "/nas/beru/uhn'adarr"})
  end
end
