begin 
	require './app'
	puts "TEST B"
	run Sinatra::Application
	puts "#{$app_name} is now running."
rescue => e 
	puts "Error starting server: #{e}, #{e.backtrace}"
end