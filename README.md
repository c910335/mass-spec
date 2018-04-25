# Mass Spec

Web API testing library

## Installation

Add this to your application's `shard.yml`:

```yaml
development_dependencies:
  mass_spec:
    github: c910335/mass_spec
```

## Usage

```crystal
require "spec"
require "mass_spec"
include MassSpec::GlobalDSL

server = HTTP::Server.new(8080) do |context|
  context.response.content_type = "application/json"
  context.response.print({path: context.request.path}.to_json)
end

server.listen

describe "Server" do
  it "returns the path in json" do
    get("/nas/beru/uhn'adarr")
    status_code.should eq(200)
    body.should eq(%({"path":"/nas/beru/uhn'adarr"}))
    json_body.should eq({"path" => "/nas/beru/uhn'adarr"})
  end
end
```

## Contributing

1. Fork it ( https://github.com/c910335/mass-spec/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [c910335](https://github.com/c910335) Tatsiujin Chin - creator, maintainer
