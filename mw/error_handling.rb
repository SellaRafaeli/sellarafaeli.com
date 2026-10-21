$errors = $mongo.collection('errors')

module Helpers
  def log_e(err, data = {})  
    err = {msg: err.to_s, backtrace: err.backtrace.to_a.slice(0,4)} if err.is_a? Exception
    err = {} unless err.is_a? Hash
    err[:user_id]  = cuid
    err[:username] = cusername
    err[:path]     = request_path
    err[:params]   = JSON.parse(_params.to_json) #sometimes params has un-BSON able fields
    $errors.add(err)
  rescue => e
    nil
  end
end

error do 
  e = env['sinatra.error']
  # self-heal a stale Mongo topology (e.g. dead monitor threads) instead of failing until restart
  ($mongo.reconnect rescue nil) if e.is_a?(Mongo::Error::NoServerAvailable)
  log_e(e)
  data = {msg: "an error occurred", e: e.to_s}
  data[:backtrace] = e.backtrace.to_a.slice(0,4).to_s unless $prod
  return data if request_expects_json?
  error_page(500, 'Something broke', "That one's on me. The error has been logged.")
end

not_found do
  # Old links: /about.html, /blog/foo.html, /blog/ -> /about, /blog/foo, /blog
  path = request.path_info
  clean = path.sub(/\.html\z/, '').sub(%r{(.)/+\z}, '\\1')
  clean = '/' if clean == '/index'
  return redirect(clean, 301) if clean != path && request.get?
  return {msg: 'No such route.'} if request_expects_json?
  error_page(404, 'Nothing here', "That page doesn't exist, or it moved. Try the <a href='/blog'>blog</a> or the <a href='/'>front page</a>.")
end

def error_page(code, title, message)
  status code
  html = "<header class='page-head'><p class='kicker'>Error #{code}</p><h1>#{title}</h1><p class='lede'>#{message}</p></header>"
  erb :template, locals: {content: html, basename: title, title: title, page_class: 'index'}
end

get '/error' do
  a = b 
end


