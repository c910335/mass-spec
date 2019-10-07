require "amber"

class HelloController < Amber::Controller::Base
  def hello
    respond_with { json({"hello" => "amber"}) }
  end
end

def with_headers_server
  HTTP::Server.new do |context|
    context.response.content_type = "application/json"
    context.response.print({headers: context.request.headers}.to_json)
  end.listen
end

def with_path_method_server
  HTTP::Server.new do |context|
    context.response.content_type = "application/json"
    context.response.headers["X-HTTP-Method"] = context.request.method
    context.response.print({path: context.request.path, method: context.request.method}.to_json)
  end.listen
end

def with_path_server
  HTTP::Server.new do |context|
    context.response.content_type = "application/json"
    context.response.print({path: context.request.path}.to_json)
  end.listen
end

def with_amber
  ENV["AMBER_ENV"] = "test"
  Amber::Server.configure do
    routes :web do
      get "/hello", HelloController, :hello
    end
  end
  Amber::Server.start
end
