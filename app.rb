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

get '/books/my_judaism' do
  log_analytics(cookies[:reader_email], pr.just(:chapter)) if cookies[:reader_email]
  File.read(File.join('public', 'books/my_judaism.html'))
end

get '/books' do
  md(:books)
end

get '/load/:x' do
  {hits: $redis.incr('load')}
end
  
get '/old' do
  md(:index)
end

get '/' do 
  return erb :'gefengil/gefengil' if host.include?("gefengil")
  erb :'home/home'
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

get '/nda' do 
  erb :'nda'
end

get '/add' do 
  res = params[:a].to_i * params[:b].to_i
  return {res: res}
end

post '/multiply' do 
  res = params[:a].to_i + params[:b].to_i
  {res: res}
end

get '/consulting' do
  md(:consulting)
end

get '/spirituality/?:day?' do
  layout(:spirituality)
end

get '/podcast/?:path?' do
  # return {msg: 'ok'}
  html = erb :podcast
  erb :template, locals: {content: html, basename: 'podcast'}
end

get '/west_coast_judaism' do
  md(:west_coast_judaism)
end

get '/believe_in_now' do
  md(:'writings/believe_in_now')
end

get '/blog' do
  md(:'blog/index')
end

get '/blog/:id' do
  md(:"blog/#{pr[:id]}")
end

get '/articles' do
  layout(:articles)
end

get '/articles/:id' do
  md(:"articles/#{pr[:id]}")
end

get '/mindy_app_freelancer' do
  md(:'random/mindy_app_freelancer')
end

get '/okta_callback' do 
  pr
end

get '/balcony' do
  erb :'balcony'
end

get '/yoni2020' do 
  erb :'yoni2020'
end

get '/ai' do
  erb :'ai/ai'
end

get '/graph' do 
  return ':)'
  # send_email('sella.rafaeli@gmail.com', '/graph view', '<strong>Hello</strong> dear Postmark user.')
  erb :'graph/graph'
end 

get '/kerbel' do 
  erb :'kerbel/kerbel'
end

def layout(view, title = nil)
  html = erb view
  erb :template, locals: {content: html, basename: title || view}
end

def md(file, opts = {})  
  text = File.read 'views/'+file.to_s+'.md'
  html = Kramdown::Document.new(text, input: 'GFM', coderay_line_numbers: nil).to_html
  
  erb :template, locals: {content: html, basename: file}.merge(opts)
end

def md_book(file, opts = {})
  text = File.read 'views/'+file.to_s+'.md'
  html = Kramdown::Document.new(text, input: 'GFM', coderay_line_numbers: nil).to_html
  
  erb :book_template, locals: {content: html, basename: file}.merge(opts)
end