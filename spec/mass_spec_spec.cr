require "./spec_helper"

server = HTTP::Server.new(8080) do |context|
  context.response.content_type = "application/json"
  context.response.print({path: context.request.path}.to_json)
end

server.listen

describe "Server" do
  it "returns the path in json" do
    get("/nas/beru/uhn'adarr")
    body.should eq(%({"path":"/nas/beru/uhn'adarr"}))
    json_body.should eq({"path" => "/nas/beru/uhn'adarr"})
  end
end
