module ActionDispatch
  class OriginalPath
    def initialize(app)
      @app = app
    end

    def call(env)
      path_info    = env["PATH_INFO"]
      query_string = env["QUERY_STRING"]
      script_name  = env["SCRIPT_NAME"]

      env["ORIGINAL_PATH"] = if query_string.present?
        "#{script_name}#{path_info}?#{query_string}"
      else
        "#{script_name}#{path_info}"
      end

      @app.call(env)
    end

  end
end

