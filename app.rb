puts "starting app..."
require 'bundler'
require 'active_support'
require 'active_support/core_ext'
require 'sinatra/reloader' #dev-only
require "kramdown"
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

get '/gefen' do 
  return erb :'gefengil/gefengil'
end

get '/' do 
  return erb :'gefengil/gefengil' if request.host.include?("gefengil")
  layout(:'home/home', SITE_NAME, page_class: 'home')
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
  blog_post_page('believe_in_now')
end

get '/blog' do
  layout(:'blog/index', 'Blog', page_class: 'index', description: "Sella Rafaeli's blog on building web software.")
end

get '/blog/feed.xml' do
  content_type 'application/atom+xml'
  blog_feed_xml
end

get '/blog/:id' do
  blog_post_page(pr[:id])
end

get '/articles' do
  layout(:articles, 'Essays', page_class: 'index')
end

get '/articles/:id' do
  essay_page(pr[:id])
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

get '/linkedin_drafts' do 
  redirect 'https://github.com/SellaRafaeli/linkedinDrafts'
end

get '/graph' do 
  return ':)'
  # send_email('sella.rafaeli@gmail.com', '/graph view', '<strong>Hello</strong> dear Postmark user.')
  erb :'graph/graph'
end 

get '/kerbel' do 
  erb :'kerbel/kerbel'
end

def layout(view, title = nil, opts = {})
  html = erb view
  erb :template, locals: {content: html, basename: title || view, title: title}.merge(opts)
end

def md(file, opts = {})  
  path = 'views/'+file.to_s+'.md'
  raise Sinatra::NotFound unless File.file?(path)
  html = render_markdown(read_utf8(path))
  
  erb :template, locals: {content: html, basename: file}.merge(opts)
end

def md_book(file, opts = {})
  html = render_markdown(read_utf8('views/'+file.to_s+'.md'))
  
  erb :book_template, locals: {content: html, basename: file}.merge(opts)
end