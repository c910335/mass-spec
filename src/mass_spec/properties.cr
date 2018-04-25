module MassSpec::Properties
  macro included
    class_property! server : HTTP::Server
    class_getter! response : HTTP::Client::Response
    class_getter! headers : HTTP::Headers
    class_getter! body : String
    class_getter! json_body : JSON::Type

    def self.response=(@@response)
      @@headers = response.headers
      @@body = response.body
      @@json_body = nil
    end

    def self.json_body
      @@json_body ||= JSON.parse(body).raw
    end
  end
end
