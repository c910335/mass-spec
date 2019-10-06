module MassSpec::Properties
  macro included
    class_property! server : HTTP::Server
    class_getter! response : HTTP::Client::Response
    class_getter! headers : HTTP::Headers
    class_getter! status_code : Int32
    class_getter! body : String
    class_getter! json_body : JSON::Any

    def self.response=(@@response)
      @@headers = response.headers
      @@status_code = response.status_code
      @@body = response.body
      @@json_body = nil
    end

    def self.json_body
      @@json_body ||= JSON.parse(body)
    end
  end
end
