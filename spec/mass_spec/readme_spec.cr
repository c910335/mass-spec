require "./spec_helper"

describe "Server" do
  it "returns the path in json" do
    with_path_server
    get("/nas/beru/uhn'adarr")

    status_code.should eq(200)
    headers.should contain({"Content-Type", ["application/json"]})
    body.should eq(%({"path":"/nas/beru/uhn'adarr"}))
    json_body.should eq({"path" => "/nas/beru/uhn'adarr"})
  end
end
