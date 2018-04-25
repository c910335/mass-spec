class MassSpec::Client < HTTP::Client
  private def exec_internal_single(request)
    decompress = set_defaults request
    input = IO::Memory.new
    request.to_io(input)
    input.rewind
    output = MassSpec.server.call(input)
    HTTP::Client::Response.from_io?(output, ignore_body: request.ignore_body?, decompress: decompress)
  end

  private def exec_internal_single(request)
    decompress = set_defaults request
    input = IO::Memory.new
    request.to_io(input)
    input.rewind
    output = MassSpec.server.call(input)
    HTTP::Client::Response.from_io?(output, ignore_body: request.ignore_body?, decompress: decompress) do |response|
      yield response
    end
  end

  private def self.exec(uri : URI, tls = nil)
    tls = tls_flag(uri, tls)
    host = validate_host(uri)

    port = uri.port
    path = uri.full_path
    user = uri.user
    password = uri.password

    Client.new(host, port, tls) do |client|
      if user && password
        client.basic_auth(user, password)
      end
      yield client, path
    end
  end
end
