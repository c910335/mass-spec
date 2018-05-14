# Mass Spec

Web API testing library

Mass Spec prevents the [`HTTP::Server`](https://crystal-lang.org/api/latest/HTTP/Server.html) from starting a [`TCPServer`](https://crystal-lang.org/api/latest/TCPServer.html) and use [`IO::Memory`](https://crystal-lang.org/api/latest/IO/Memory.html) instead of [`TCPSocket`](https://crystal-lang.org/api/latest/TCPSocket.html) for fast testing.

Because Mass Spec works with standard library, it can easily support the frameworks based on [`HTTP::Server`](https://crystal-lang.org/api/latest/HTTP/Server.html).

## Installation

Add this to your application's `shard.yml`:

```yaml
development_dependencies:
  mass_spec:
    github: c910335/mass-spec
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
    headers.should contain({"Content-Type", ["application/json"]})
    body.should eq(%({"path":"/nas/beru/uhn'adarr"}))
    json_body.should eq({"path" => "/nas/beru/uhn'adarr"})
  end
end
```

### Making Requests

Mass Spec supports the following HTTP verbs via [`HTTP::Client`](https://crystal-lang.org/api/latest/HTTP/Client.html), and the usage of them is the same as [`HTTP::Client`](https://crystal-lang.org/api/latest/HTTP/Client.html).

- [`#get`](https://crystal-lang.org/api/latest/HTTP/Client.html#get%28path%2Cheaders%3AHTTP%3A%3AHeaders%3F%3Dnil%2C%2A%2Cform%3AHash%28String%2CString%29%7CNamedTuple%29%3AHTTP%3A%3AClient%3A%3AResponse-instance-method)
- [`#head`](https://crystal-lang.org/api/latest/HTTP/Client.html#head%28path%2Cheaders%3AHTTP%3A%3AHeaders%3F%3Dnil%2C%2A%2Cform%3AHash%28String%2CString%29%7CNamedTuple%29%3AHTTP%3A%3AClient%3A%3AResponse-instance-method)
- [`#post`](https://crystal-lang.org/api/latest/HTTP/Client.html#post%28path%2Cheaders%3AHTTP%3A%3AHeaders%3F%3Dnil%2C%2A%2Cform%3AHash%28String%2CString%29%7CNamedTuple%29%3AHTTP%3A%3AClient%3A%3AResponse-instance-method)
- [`#put`](https://crystal-lang.org/api/latest/HTTP/Client.html#put%28path%2Cheaders%3AHTTP%3A%3AHeaders%3F%3Dnil%2Cbody%3ABodyType%3Dnil%2C%26block%29-instance-method)
- [`#patch`](https://crystal-lang.org/api/latest/HTTP/Client.html#patch%28path%2Cheaders%3AHTTP%3A%3AHeaders%3F%3Dnil%2C%2A%2Cform%3AHash%28String%2CString%29%7CNamedTuple%29%3AHTTP%3A%3AClient%3A%3AResponse-instance-method)
- [`#delete`](https://crystal-lang.org/api/latest/HTTP/Client.html#delete%28path%2Cheaders%3AHTTP%3A%3AHeaders%3F%3Dnil%2Cbody%3ABodyType%3Dnil%29%3AHTTP%3A%3AClient%3A%3AResponse-instance-method)

### Handling Responses

After a request, you can access these getters.

- response : [`HTTP::Client::Response`](https://crystal-lang.org/api/latest/HTTP/Client/Response.html)
- status_code : [`Int32`](https://crystal-lang.org/api/latest/Int32.html)
- headers : [`HTTP::Headers`](https://crystal-lang.org/api/latest/HTTP/Headers.html)
- body : [`String`](https://crystal-lang.org/api/latest/String.html)
- json_body : [`JSON::Type`](https://crystal-lang.org/api/latest/JSON/Type.html) - The body parsed as [`JSON::Type`](https://crystal-lang.org/api/latest/JSON/Type.html)

## Contributing

1. Fork it ( https://github.com/c910335/mass-spec/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [c910335](https://github.com/c910335) Tatsiujin Chin - creator, maintainer
