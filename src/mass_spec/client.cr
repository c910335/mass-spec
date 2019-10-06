class MassSpec::Client < HTTP::Client
  @@client : Client?
  getter headers = HTTP::Headers.new

  def self.instance
    @@client ||= new("dummy")
  end

  def headers(headers)
    @headers.merge! headers
  end

  private def exec_internal(request)
    request.headers.merge! @headers
    decompress = set_defaults request
    input = IO::Memory.new
    request.to_io(input)
    input.rewind
    output = MassSpec.server.call(input)
    HTTP::Client::Response.from_io(output, ignore_body: request.ignore_body?, decompress: decompress)
  end
end
