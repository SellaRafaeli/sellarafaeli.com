module Helpers
  #call erb from places that don't have access to Sinatra's top level. 
  def zerb(*args, &block)
    # we need a Sinatra Application instance in order to call 'erb' from within Modules.
    # see 
    @rendering_app ||= Sinatra::Application.new.instance_variable_get :@instance
    @rendering_app.erb(*args, &block)
  end
end

def slugify(str)
  str.to_s.to_slug.normalize.to_s.slice(0,200)
end

def view(path, opts = {})
  opts[:layout] ||= :layout
  opts[:locals] = opts
  erb path, opts
end

get '/protected' do
  protected!
  erb :tester, layout: :layout
end

def reload
  exec $0, *ARGV
end
get '/refresh' do true end