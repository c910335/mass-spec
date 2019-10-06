require "http/client"
require "http/server"
require "json"
require "./mass_spec/*"
require "./http/server"

module MassSpec
  include Properties
  extend GlobalDSL

  def self.configure
    with MassSpec::Client.instance yield
  end
end
