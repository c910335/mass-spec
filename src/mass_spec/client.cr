class MassSpec::Client < HTTP::Client
  private def exec_internal(request)
    decompress = set_defaults request
    input = IO::Memory.new
    request.to_io(input)
    input.rewind
    output = MassSpec.server.call(input)
    HTTP::Client::Response.from_io(output, ignore_body: request.ignore_body?, decompress: decompress)
  end
end
