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
        body = Open3.popen3('node c:/users/etblue/appdata/roaming/npm/node_modules/jade/bin/jade --path . -O "{require: require}"') do |stdin, stdout, stderr|
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