require 'shellwords'
require 'fileutils'
Dir.glob('portfolio/**/*.{png,jpg}') do |path|
  puts path
  FileUtils.mkdir_p("sample_images/#{File.dirname(path)}")
  %x{convert #{Shellwords.escape(path)}  -filter Lanczos -distort Resize 320x320 -trim  sample_images/#{Shellwords.escape(path)}}
end
