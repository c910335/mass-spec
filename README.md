# Mass Spec

[![Crystal CI](https://github.com/c910335/mass-spec/actions/workflows/crystal.yml/badge.svg)](https://github.com/c910335/mass-spec/actions/workflows/crystal.yml)
[![GitHub releases](https://img.shields.io/github/release/c910335/mass-spec.svg)](https://github.com/c910335/mass-spec/releases)
[![GitHub license](https://img.shields.io/github/license/c910335/mass-spec.svg)](https://github.com/c910335/mass-spec/blob/master/LICENSE)

Web API testing library

Mass Spec prevents [`HTTP::Server`](https://crystal-lang.org/api/latest/HTTP/Server.html) from starting a [`TCPServer`](https://crystal-lang.org/api/latest/TCPServer.html) and use [`IO::Memory`](https://crystal-lang.org/api/latest/IO/Memory.html) instead of [`TCPSocket`](https://crystal-lang.org/api/latest/TCPSocket.html) for fast testing.

Since Mass Spec works with standard library, it can easily support the frameworks based on [`HTTP::Server`](https://crystal-lang.org/api/latest/HTTP/Server.html).

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

server = HTTP::Server.new do |context|
  context.response.content_type = "application/json"
  context.response.print(context.request.body.try &.gets_to_end)
end

server.listen

describe "Server" do
  it "echoes in json" do
    post("/", body: {
      "Khassar de templari!" => "From order comes justice!",
      "Adun Toridas!"        => "Adun hide you",
      "Nahda gahla"          => nil,
    }.to_json)

    status_code.should eq(200)
    headers.should contain({"Content-Type", ["application/json"]})
    body.should eq(%({"Khassar de templari!":"From order comes justice!","Adun Toridas!":"Adun hide you","Nahda gahla":null}))
    json_body.should eq({
      "Khassar de templari!" => "From order comes justice!",
      "Adun Toridas!"        => "Adun hide you",
      "Nahda gahla"          => nil,
    })

    json_body.should contain({
      "Khassar de templari!" => "From order comes justice!",
      "Adun Toridas!"        => String,
    })
    json_body.should match({
      "Khassar de templari!" => String,
      "Adun Toridas!"        => "Adun hide you",
      "Nahda gahla"          => Nil,
    })
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
- json_body : [`JSON::Any`](https://crystal-lang.org/api/latest/JSON/Any.html) - The body parsed as [`JSON::Any`](https://crystal-lang.org/api/latest/JSON/Any.html)

### Expectations

Besides built-in expectations, Mass Spec also provides `contain` and `match` for `JSON::Any`.

```crystal
json = JSON.parse(%({"array":[1,2,3],"number":1,"float_number":1.5,"string":"str","null":null,"hash":{"a":1}}))

describe "contain with JSON::Any" do
  it "checks whether json contains the values or types" do
    json.should contain({
      "array"  => Array,
      "number" => 1,
      "hash"   => {"a" => Int64},
    })
  end
end

describe "match with JSON::Any" do
  it "checks whether json matches the values or types" do
    json.should match({
      "array"        => [1, 2, 3],
      "number"       => Int64,
      "float_number" => 1.5,
      "string"       => String,
      "null"         => nil,
      "hash"         => Hash,
    })
  end
end
```

### Configuration

You can specify `headers` that will be applied to every requests.

```crystal
MassSpec.configure do
  headers({"Authorization" => "Bearer some_access_token"})
end
```

### Frameworks

#### [Kemal](https://github.com/kemalcr/kemal)

Kemal doesn't run `HTTP::Server#listen` when `ENV["KEMAL_ENV"]` is `"test"`, so you need to set `MassSpec.server` manually.

```crystal
# src/your_app.cr
require "kemal"

get "/hello" do
  {hello: "kemal"}.to_json
end

Kemal.run

# spec/spec_helper.cr
ENV["KEMAL_ENV"] = "test"
require "spec"
require "mass_spec"
require "../src/*"
include MassSpec::GlobalDSL

Kemal.run do |config|
  MassSpec.server = config.server.not_nil! # set `MassSpec.server` manually
end

# spec/your_app_spec.cr
require "./spec_helper"

describe "GET /hello" do
  it "says hello to Kemal" do
    get "/hello"

    json_body.should eq({"hello" => "kemal"})
  end
end
```

#### [Amber](https://github.com/amberframework/amber)

```crystal
# src/controllers/hello_controller.cr
class HelloController < Amber::Controller::Base
  def hello
    respond_with { json({"hello" => "amber"}) }
  end
end

# config/routes.cr
Amber::Server.configure do
  routes :web do
    get "/hello", HelloController, :hello
  end
end

# spec/spec_helper.cr
ENV["AMBER_ENV"] = "test"
require "spec"
require "mass_spec"
require "../src/*" # not `require "../config/*"`
include MassSpec::GlobalDSL

# spec/controllers/spec_helper.cr
require "../spec_helper"

# spec/controllers/hello_controller_spec.cr
require "./spec_helper"

describe HelloController do
  describe "GET #hello" do
    it "says hello to Amber" do
      get "/hello"

      json_body.should eq({"hello" => "amber"})
    end
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
