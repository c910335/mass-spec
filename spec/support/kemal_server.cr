require "kemal"

get "/hello" do
  {hello: "kemal"}.to_json
end

Kemal.run
