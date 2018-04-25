class HTTP::Server
  def listen(reuse_port = false)
    MassSpec.server = self
  end

  def call(input)
    output = IO::Memory.new
    @processor.process(input, output)
    output.rewind
  end
end
