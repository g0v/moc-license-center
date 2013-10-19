class JadeHandler
  def initialize(app)
    @app = app
  end
 
  def call(env)
    if env["PATH_INFO"] =~ /\/$/
      env["PATH_INFO"] += "index.jade"
    end
 
    if env["PATH_INFO"] =~ /\.jade$/
     path =  env["PATH_INFO"][1..-1]
 
      body = %x{jade --path . < #{path} }
 
      [200, {"Content-Type" => "text/html"}, [body]]
    else
      status, headers, body = @app.call(env)
      [status, headers, body]
    end
  end
end
 
use JadeHandler