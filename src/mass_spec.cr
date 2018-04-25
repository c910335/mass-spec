require "http/client"
require "http/server"
require "./mass_spec/*"
require "./http/server"

module MassSpec
  class_property! server : HTTP::Server
end
