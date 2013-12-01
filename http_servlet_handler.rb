require 'open3'

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
      base = File.basename(path)
      dir = File.dirname(path) + "/src"
      body = nil
      
      Dir.chdir(dir) do
        if File.exists?('c:/users/etblue/appdata/roaming/npm/node_modules/jade/bin/jade')
          jade_cmd = 'node c:/users/etblue/appdata/roaming/npm/node_modules/jade/bin/jade --path . -O "{require: require}" -P ' 
        else
          jade_cmd = 'jade --path . -O "{require: require}" -P'
        end

        body = Open3.popen3(jade_cmd ) do |stdin, stdout, stderr|
          template = open(base,'r'){|f| f.read}

          stdin.write template
          stdin.close

          stdout.read + stderr.read.gsub(/\n/, '<br>')
        end
      end
      [200, {"Content-Type" => "text/html"}, [body]]
    else
      status, headers, body = @app.call(env)
      [status, headers, body]
    end 
  end  
end

use JadeHandler
