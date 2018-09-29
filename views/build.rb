#$ ruby generate_content.rb
require 'find'
require 'kramdown'
require 'erb'

def wrap_file_in_html(file_path, custom_content = nil)     
   basename = File.basename(file_path, ".html")
   basename = 'sellarafaeli.com' if basename == 'index'
   content  = "#{custom_content || File.read(file_path)}" 
   template = ERB.new File.read("template.erb"), nil, "%"
   template = template.result(binding)
   File.write(file_path,template)
end

#2. Find all Markdown files
md_file_paths = Find.find('.').to_a.select {|f| f =~ /.*\.md$/ }

#3. Turn each of them into an HTML file with same name in same place. 
md_file_paths.each do |path|
  html_path = path.sub('.md','.html')
  puts "generating #{path} into #{html_path}..."
  text = File.read(path)
  File.write(html_path, Kramdown::Document.new(text, input: 'GFM', coderay_line_numbers: nil).to_html)      ## use Kramdown to parse Github-flavored-markdown (GFM)
  wrap_file_in_html(html_path)    
end

puts "Done!"
  