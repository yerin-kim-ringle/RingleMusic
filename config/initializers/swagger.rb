GrapeSwaggerRails.options.url = "/api/v1/apidoc"
GrapeSwaggerRails.options.before_action do
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end
GrapeSwaggerRails.options.app_name = "Ringle"
GrapeSwaggerRails.options.api_auth     = "Bearer"
GrapeSwaggerRails.options.api_key_name = "Authorization"
GrapeSwaggerRails.options.api_key_type = "header"