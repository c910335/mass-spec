class MassSpec::Client < HTTP::Client
  @@client : Client?
  getter headers = HTTP::Headers.new

  def self.instance
    @@client ||= new("mock")
  end

  def headers(headers)
    @headers.merge! headers
  end

  private def send_request(request)
    request.headers.merge! @headers
    set_defaults request
    run_before_request_callbacks(request)
    input = IO::Memory.new
    request.to_io(input)
    input.rewind
    @io = MassSpec.server.call(input)
  end
end
