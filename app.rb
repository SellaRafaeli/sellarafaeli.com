puts "starting app..."
require 'bundler'
require 'active_support'
require 'active_support/core_ext'
require 'sinatra/reloader' #dev-only
# require 'sinatra/activerecord'
puts "requiring gems..."

Bundler.require
Dotenv.load

$app_name   = 'sellarafaeli.com'

require './setup'
require './my_lib'

require_all './db'
require_all './admin'
require_all './bl'
require_all './comm'
require_all './logging'
require_all './mw'

require "sinatra/streaming"

include Helpers #makes helpers globally available 

get '/ping' do
  {msg: "pong from #{$app_name}", val: 'CarWaiting (is the new TrainSpotting)'}
end

get '/timeout' do
  stream do |out|
    sleep 35
    out.puts "should never reach"
  end
end

get '/shouldnt_timeout' do
  stream do |out|
    out << "a"
    out.flush
    sleep 20
    out << "b"
    out.flush
    sleep 20
    out << "c"
    out.flush
    sleep 20
    out << "d"
    out.flush
    sleep 20
    out << 'should be OK'
    out.flush
  end
end

get '/load/:x' do
  {hits: $redis.incr('load')}
end
  
get '/' do
  md(:index)
end

get '/about' do
  md(:about)
end

get '/contact' do
  md(:contact)
end

get '/philosopher' do
  md(:philosopher)
end

get '/consulting' do
  md(:consulting)
end

get '/blog' do
  md(:'blog/index')
end

get '/blog/:id' do
  md(:"blog/#{pr[:id]}")
end

get '/okta_callback' do 
  pr
end

def md(file)  
  text = File.read 'views/'+file.to_s+'.md'
  html = Kramdown::Document.new(text, input: 'GFM', coderay_line_numbers: nil).to_html
  
  erb :template, locals: {content: html, basename: file}
end

