struct JSON::Any
  def equal?(obj) : Bool
    {% begin %}
      case obj
        {% for type in %w(Array Bool Float64 Hash Int64 String Nil) %}
        when {{type.id}}.class
          self.raw.class <= {{type.id}}
        {% end %}
      else
        self == obj
      end
    {% end %}
  end

  def includes?(obj) : Bool
    case obj
    when Hash
      obj.all? do |k, v|
        self[k]? && self[k].includes? v
      end
    when Array
      i = -1
      !as_a?.nil? && as_a.size == obj.size && obj.all? do |e|
        i += 1
        self[i]? && self[i].includes? e
      end
    else
      equal?(obj)
    end
  end

  def =~(obj) : Bool
    case obj
    when Hash
      !as_h?.nil? && as_h.size == obj.size && as_h.all? do |k, v|
        obj.has_key?(k) && v =~ obj[k]
      end
    when Array
      i = -1
      !as_a?.nil? && as_a.size == obj.size && obj.all? do |e|
        i += 1
        self[i]? && self[i] =~ e
      end
    else
      equal?(obj)
    end
  end
end
