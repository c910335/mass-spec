class HTTP::Server
  def bind_tcp(host : String, port : Int32, reuse_port : Bool = false)
  end

  def bind_tcp(port : Int32, reuse_port : Bool = false)
  end

  def listen
    MassSpec.server = self
  end

  def call(input)
    output = IO::Memory.new
    @processor.process(input, output)
    output.rewind
  end
end
