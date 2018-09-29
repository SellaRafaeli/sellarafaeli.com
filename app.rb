puts "starting app..."
require 'bundler'
require 'active_support'
require 'active_support/core_ext'
require 'sinatra/reloader' #dev-only
# require 'sinatra/activerecord'
puts "requiring gems..."

Bundler.require
Dotenv.load

$app_name   = 'topjobs'

require './setup'
require './my_lib'
require_all './db'
require_all './admin'
require_all './bl'
require_all './comm'
require_all './logging'
require_all './mw'

include Helpers #makes helpers globally available 

def reset_data
  $users.delete_many
  $users.add(_id: 'fiverr', nick: 'fiverr', email: 'hr@fiverr.com', is_org: true, login_token: 'fiverr')
  $users.add(_id: 'sella', email: 'sella.rafaeli@gmail.com', login_token: 'sella', desc: "frontend I love React", interest: 'I want a cool company', nick: 'js-ninja')
  $users.add(_id: 'other', email: 'other.user@gmail.com', login_token: 'other')

  $msgs.delete_many
  $msgs.add(from: 'fiverr', to: 'sella', text: 'hello sella')
  $msgs.add(from: 'fiverr', to: 'other', text: 'hello other')
end

get '/ping' do
  {msg: "pong from #{$app_name}", val: 'CarWaiting (is the new TrainSpotting)'}
end

get '/' do
  is_org ? (redirect '/search') : (erb :homepage, layout: :layout2)
end
