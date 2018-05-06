require "http/client"
require "http/server"
require "json"
require "./mass_spec/*"
require "./http/server"

module MassSpec
  include Properties
  extend GlobalDSL
end
