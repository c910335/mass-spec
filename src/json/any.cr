struct JSON::Any
  def includes?(obj) : Bool
    {% begin %}
      case obj
        {% for type in %w(Array Bool Float64 Hash Int64 String Nil) %}
        when {{type.id}}.class
          self.raw.class <= {{type.id}}
        {% end %}
      when Hash
        obj.all? do |k, v|
          self[k]? && self[k].includes? v
        end
      when Array
        i = -1
        if as_a?
          as_a.size == obj.size && obj.all? do |e|
            i += 1
            self[i]? && self[i].includes? e
          end
        else
          false
        end
      else
        self == obj
      end
    {% end %}
  end
end
