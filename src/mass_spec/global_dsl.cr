module MassSpec::GlobalDSL
  CLIENT = MassSpec::Client.new("dummy")

  {% for method in %w(get head post put patch delete) %}
    def {{method.id}}(*args, **options)
      MassSpec.response = CLIENT.{{method.id}}(*args, **options)
    end
  {% end %}

  {% for getter in %w(response headers status_code body json_body) %}
    def {{getter.id}}
      MassSpec.{{getter.id}}
    end
  {% end %}
end
